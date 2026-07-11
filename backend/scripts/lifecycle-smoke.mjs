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

async function loginSeedUser(label, userId) {
  const response = await expectResponse(
    `${label} test login`,
    await post('/api/auth/login', null, { user_id: userId }),
  );
  assert(response.token, `${label} login returned no token`, response);
  return response.token;
}

async function ensureFriendship(aliceToken, bobToken) {
  const search = await expectResponse(
    'Alice searches Bob',
    await get('/api/social/search?q=bo', aliceToken),
  );
  assert(
    Array.isArray(search.results) &&
      search.results.some((user) => user.id === 'local-user-2'),
    'Bob missing from search results',
    search,
  );
  const bobResult = search.results.find((user) => user.id === 'local-user-2');
  assert(
    ['none', 'pending_outgoing', 'pending_incoming', 'accepted'].includes(
      bobResult.relationship_state,
    ),
    'Bob search result missing relationship state',
    bobResult,
  );
  assert(!('total_score' in bobResult), 'Search leaked total_score', bobResult);

  const request = await expectResponse(
    'Alice sends Bob a friend request',
    await post('/api/social/friend-request', aliceToken, {
      target_user_id: 'local-user-2',
    }),
  );
  if (request.relationship_state === 'accepted') {
    return;
  }
  if (request.relationship_state === 'pending_incoming') {
    const aliceRequests = await expectResponse(
      'Alice lists reciprocal friend requests',
      await get('/api/social/friend-request', aliceToken),
    );
    const reciprocalRequest = aliceRequests.friend_requests.find(
      (item) => item.requester_id === 'local-user-2',
    );
    assert(
      reciprocalRequest,
      'Alice could not see reciprocal Bob friend request',
      aliceRequests,
    );
    await expectResponse(
      'Alice accepts reciprocal Bob friend request',
      await post('/api/social/friend-request/accept', aliceToken, {
        request_id: reciprocalRequest.id,
      }),
    );
    return;
  }
  assert(
    request.relationship_state === 'pending_outgoing',
    'Alice request should be pending_outgoing before Bob accepts',
    request,
  );
  const bobRequests = await expectResponse(
    'Bob lists friend requests',
    await get('/api/social/friend-request', bobToken),
  );
  const requestToAccept =
    bobRequests.friend_requests.find((item) => item.id === request.request_id) ??
    bobRequests.friend_requests.find(
      (item) => item.requester_id === 'local-user-1',
    );
  assert(requestToAccept, 'Bob could not see Alice friend request', bobRequests);

  await expectResponse(
    'Bob accepts Alice friend request',
    await post('/api/social/friend-request/accept', bobToken, {
      request_id: requestToAccept.id,
    }),
  );
  const aliceDaily = await expectResponse(
    'Alice daily sync contains Bob as accepted friend',
    await get('/api/sync/daily', aliceToken),
  );
  assert(
    aliceDaily.accepted_friends.some(
      (friend) => friend.friend_id === 'local-user-2',
    ),
    'Alice daily sync missing Bob accepted friend',
    aliceDaily.accepted_friends,
  );
}

async function createHabit(ownerToken, habitId, title, targetDuration) {
  await expectResponse(
    `${title} habit metadata sync`,
    await post('/api/sync/habit', ownerToken, {
      habit_id: habitId,
      title,
      target_duration: targetDuration,
      color_hex: 'FF9CAF88',
      status: 'active',
      updated_at: new Date().toISOString(),
    }),
  );
}

async function inviteAndAccept({
  ownerToken,
  recipientToken,
  habitId,
  targetUserId,
}) {
  const invitation = await expectResponse(
    `Invite ${targetUserId} to ${habitId}`,
    await post('/api/social/habit-invitation', ownerToken, {
      habit_id: habitId,
      target_user_id: targetUserId,
    }),
  );
  await expectResponse(
    `Accept invitation for ${habitId}`,
    await post('/api/social/habit-invitation/accept', recipientToken, {
      invitation_id: invitation.invitation_id,
    }),
  );
}

async function dailyPartnerRow(token, habitId, partnerId) {
  const daily = await expectResponse(
    `Daily sync for ${habitId}`,
    await get('/api/sync/daily', token),
  );
  return daily.partners.find(
    (partner) =>
      partner.habit_id === habitId && partner.partner_id === partnerId,
  );
}

async function run() {
  console.log(`Running lifecycle smoke against ${baseUrl}`);
  const aliceToken = await loginSeedUser('Alice', 'local-user-1');
  const bobToken = await loginSeedUser('Bob', 'local-user-2');

  await ensureFriendship(aliceToken, bobToken);

  const normalHabitId = `smoke-normal-${runId}`;
  await createHabit(aliceToken, normalHabitId, 'Smoke Normal Habit', 3);
  await inviteAndAccept({
    ownerToken: aliceToken,
    recipientToken: bobToken,
    habitId: normalHabitId,
    targetUserId: 'local-user-2',
  });

  const bobNormal = await dailyPartnerRow(
    bobToken,
    normalHabitId,
    'local-user-1',
  );
  assert(
    bobNormal?.title === 'Smoke Normal Habit' &&
      bobNormal.viewer_remaining_days === 3,
    'Bob did not receive Alice normal habit metadata',
    bobNormal,
  );

  await expectResponse(
    'Alice logs normal habit completion',
    await post('/api/sync/log', aliceToken, {
      log_id: `alice-normal-log-${runId}`,
      habit_id: normalHabitId,
      status: 'completed',
      logged_at: new Date().toISOString(),
    }),
  );
  await expectResponse(
    'Bob logs normal habit completion',
    await post('/api/sync/log', bobToken, {
      log_id: `bob-normal-log-${runId}`,
      habit_id: normalHabitId,
      status: 'completed',
      logged_at: new Date().toISOString(),
    }),
  );
  const bobNormalAfterLog = await dailyPartnerRow(
    bobToken,
    normalHabitId,
    'local-user-1',
  );
  assert(
    bobNormalAfterLog?.viewer_remaining_days === 2,
    'Bob viewer remaining days did not decrement after completion',
    bobNormalAfterLog,
  );

  await expectResponse(
    'Alice updates normal habit metadata',
    await post('/api/sync/habit', aliceToken, {
      habit_id: normalHabitId,
      title: 'Smoke Normal Habit Updated',
      target_duration: 5,
      color_hex: 'FFFFAA00',
      status: 'active',
      updated_at: new Date().toISOString(),
    }),
  );
  const bobNormalAfterUpdate = await dailyPartnerRow(
    bobToken,
    normalHabitId,
    'local-user-1',
  );
  assert(
    bobNormalAfterUpdate?.title === 'Smoke Normal Habit Updated' &&
      bobNormalAfterUpdate.target_duration === 5 &&
      bobNormalAfterUpdate.color_hex === 'FFFFAA00',
    'Bob did not receive Alice metadata update',
    bobNormalAfterUpdate,
  );

  await expectResponse(
    'Bob cannot update Alice-owned habit',
    await post('/api/sync/habit', bobToken, {
      habit_id: normalHabitId,
      title: 'Unauthorized Update',
      target_duration: 1,
      color_hex: 'FF000000',
      status: 'active',
      updated_at: new Date().toISOString(),
    }),
    [403],
  );

  const multiDayHabitId = `smoke-multiday-${runId}`;
  await createHabit(aliceToken, multiDayHabitId, 'Smoke Multi-Day Habit', 21);
  await inviteAndAccept({
    ownerToken: aliceToken,
    recipientToken: bobToken,
    habitId: multiDayHabitId,
    targetUserId: 'local-user-2',
  });
  const bobMultiDay = await dailyPartnerRow(
    bobToken,
    multiDayHabitId,
    'local-user-1',
  );
  assert(
    bobMultiDay?.target_duration === 21 &&
      bobMultiDay.viewer_remaining_days === 21,
    'Bob did not receive Alice multi-day habit correctly',
    bobMultiDay,
  );

  const bobOwnedHabitId = `smoke-bob-owned-${runId}`;
  await createHabit(bobToken, bobOwnedHabitId, 'Smoke Bob-Owned Habit', 7);
  await inviteAndAccept({
    ownerToken: bobToken,
    recipientToken: aliceToken,
    habitId: bobOwnedHabitId,
    targetUserId: 'local-user-1',
  });
  const aliceSeesBobOwned = await dailyPartnerRow(
    aliceToken,
    bobOwnedHabitId,
    'local-user-2',
  );
  assert(
    aliceSeesBobOwned?.title === 'Smoke Bob-Owned Habit' &&
      aliceSeesBobOwned.target_duration === 7,
    'Alice did not receive Bob-owned shared habit',
    aliceSeesBobOwned,
  );

  await expectResponse(
    'Alice archives normal habit',
    await post('/api/sync/habit', aliceToken, {
      habit_id: normalHabitId,
      title: 'Smoke Normal Habit Updated',
      target_duration: 5,
      color_hex: 'FFFFAA00',
      status: 'abandoned',
      updated_at: new Date().toISOString(),
    }),
  );
  const bobNormalAfterArchive = await dailyPartnerRow(
    bobToken,
    normalHabitId,
    'local-user-1',
  );
  assert(
    bobNormalAfterArchive?.status === 'abandoned',
    'Bob did not receive archived status',
    bobNormalAfterArchive,
  );

  const privateHabitId = `smoke-private-${runId}`;
  await createHabit(aliceToken, privateHabitId, 'Smoke Private Habit', 2);
  const bobPrivateRow = await dailyPartnerRow(
    bobToken,
    privateHabitId,
    'local-user-1',
  );
  assert(!bobPrivateRow, 'Bob received a non-partner private habit', bobPrivateRow);

  console.log('LIFECYCLE_SMOKE_PASS');
}

run().catch((error) => {
  console.error(error instanceof Error ? error.message : error);
  process.exit(1);
});
