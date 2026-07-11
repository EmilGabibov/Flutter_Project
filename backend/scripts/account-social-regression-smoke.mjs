const baseUrl = process.env.HABLE_API_BASE_URL ?? 'http://127.0.0.1:8787';
const runId = Date.now();

async function parseResponse(response) {
  const text = await response.text();
  if (!text.trim()) return {};
  try {
    return JSON.parse(text);
  } catch {
    return { raw: text };
  }
}

async function expectResponse(label, response, expectedStatuses = [200]) {
  const body = await parseResponse(response);
  if (!expectedStatuses.includes(response.status)) {
    throw new Error(
      `${label} failed: expected ${expectedStatuses.join(', ')}, got ${response.status} ${JSON.stringify(body)}`,
    );
  }
  console.log(`OK ${label}: ${response.status}`);
  return body;
}

function authHeaders(token) {
  return {
    'content-type': 'application/json',
    ...(token ? { authorization: `Bearer ${token}` } : {}),
  };
}

function post(path, token, body) {
  return fetch(`${baseUrl}${path}`, {
    method: 'POST',
    headers: authHeaders(token),
    body: JSON.stringify(body),
  });
}

function put(path, token, body) {
  return fetch(`${baseUrl}${path}`, {
    method: 'PUT',
    headers: authHeaders(token),
    body: JSON.stringify(body),
  });
}

function get(path, token) {
  return fetch(`${baseUrl}${path}`, {
    headers: token ? { authorization: `Bearer ${token}` } : {},
  });
}

function assert(condition, message, detail) {
  if (!condition) {
    throw new Error(`${message}${detail ? ` ${JSON.stringify(detail)}` : ''}`);
  }
}

async function register(username) {
  const response = await expectResponse(
    `register ${username}`,
    await post('/api/auth/register', null, {
      username,
      password: 'password123',
    }),
  );
  assert(response.token, 'Registration returned no token', response);
  assert(response.user_id, 'Registration returned no user id', response);
  return response;
}

async function searchFor(token, query, userId) {
  const search = await expectResponse(
    `search ${query}`,
    await get(`/api/social/search?q=${encodeURIComponent(query)}`, token),
  );
  const user = search.results.find((item) => item.user_id === userId || item.id === userId);
  assert(user, `Search results missing ${userId}`, search);
  assert(!('total_score' in user), 'Search leaked total_score', user);
  assert(!('habits' in user), 'Search leaked habit data', user);
  return user;
}

async function createHabit(ownerToken, habitId, title) {
  await expectResponse(
    `create ${title}`,
    await post('/api/sync/habit', ownerToken, {
      habit_id: habitId,
      title,
      target_duration: 7,
      color_hex: 'FF9CAF88',
      status: 'active',
      updated_at: new Date().toISOString(),
    }),
  );
}

async function inviteAndAccept(ownerToken, recipientToken, habitId, targetUserId) {
  const invitation = await expectResponse(
    `invite ${targetUserId}`,
    await post('/api/social/habit-invitation', ownerToken, {
      habit_id: habitId,
      target_user_id: targetUserId,
    }),
  );
  await expectResponse(
    'accept habit invitation',
    await post('/api/social/habit-invitation/accept', recipientToken, {
      invitation_id: invitation.invitation_id,
    }),
  );
}

async function run() {
  console.log(`Running account/social regression smoke against ${baseUrl}`);
  const alice = await register(`regressa${runId}`);
  const bob = await register(`regressb${runId}`);

  const login = await expectResponse(
    'case-insensitive username login',
    await post('/api/auth/login', null, {
      username: alice.username.toUpperCase(),
      password: 'password123',
    }),
  );
  assert(login.user_id === alice.user_id, 'Login returned wrong user', login);

  await expectResponse(
    'profile activation PIN request',
    await post('/api/user/email/request-pin', alice.token, {
      email: `activate-${runId}@example.test`,
    }),
  );

  const avatar = await expectResponse(
    'emoji avatar update',
    await put('/api/user/avatar', alice.token, { avatar_url: '🤖' }),
  );
  assert(avatar.avatar_url === '🤖', 'Avatar update did not echo selected emoji', avatar);

  await expectResponse(
    'non-emoji avatar rejected',
    await put('/api/user/avatar', alice.token, {
      avatar_url: 'https://example.test/avatar.png',
    }),
    [400],
  );

  const bobInitial = await searchFor(alice.token, bob.username.slice(0, 8), bob.user_id);
  assert(bobInitial.relationship_state === 'none', 'Initial search should be relationship none', bobInitial);

  const request = await expectResponse(
    'friend request',
    await post('/api/social/friend-request', alice.token, {
      target_user_id: bob.user_id,
    }),
  );
  await expectResponse(
    'friend request accept',
    await post('/api/social/friend-request/accept', bob.token, {
      request_id: request.request_id,
    }),
  );

  const leaderboard = await expectResponse(
    'friends leaderboard',
    await get('/api/social/leaderboard', alice.token),
  );
  const leaderboardIds = leaderboard.leaderboard.map((row) => row.id);
  assert(leaderboardIds.includes(alice.user_id), 'Leaderboard missing current user', leaderboard);
  assert(leaderboardIds.includes(bob.user_id), 'Leaderboard missing accepted friend', leaderboard);

  const habitId = `regression-nudge-${runId}`;
  await createHabit(alice.token, habitId, 'Regression Nudge Habit');
  await inviteAndAccept(alice.token, bob.token, habitId, bob.user_id);

  await expectResponse(
    'habit-scoped nudge',
    await post('/api/social/nudge', alice.token, {
      target_user_id: bob.user_id,
      habit_id: habitId,
    }),
  );

  const bobDaily = await expectResponse(
    'recipient daily sync with nudge',
    await get('/api/sync/daily', bob.token),
  );
  assert(
    bobDaily.nudges.some(
      (nudge) =>
        nudge.senderId === alice.user_id &&
        (nudge.habitId === habitId || nudge.habit_id === habitId),
    ),
    'Daily sync missing habit-scoped nudge',
    bobDaily.nudges,
  );

  console.log('Account/social regression smoke completed.');
}

run().catch((error) => {
  console.error(error);
  process.exit(1);
});
