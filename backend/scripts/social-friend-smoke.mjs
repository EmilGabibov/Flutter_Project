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

async function register(label, username) {
  const response = await expectResponse(
    `${label} register`,
    await post('/api/auth/register', null, {
      username,
      password: 'password123',
      email: `${username}@example.test`,
    }),
  );
  assert(response.token, `${label} registration returned no token`, response);
  assert(response.user_id, `${label} registration returned no user id`, response);
  return response;
}

async function searchFor(token, query, userId) {
  const search = await expectResponse(
    `search ${query}`,
    await get(`/api/social/search?q=${encodeURIComponent(query)}`, token),
  );
  const user = search.results.find((item) => item.user_id === userId || item.id === userId);
  assert(user, `Search results missing ${userId}`, search);
  return user;
}

async function run() {
  console.log(`Running social friend smoke against ${baseUrl}`);
  const alice = await register('Alice smoke', `smokea${runId}`);
  const bob = await register('Bob smoke', `smokeb${runId}`);

  const initialBob = await searchFor(alice.token, bob.username.slice(0, 8), bob.user_id);
  assert(initialBob.relationship_state === 'none', 'Initial relationship should be none', initialBob);
  assert(!('total_score' in initialBob), 'Search leaked total_score', initialBob);
  assert(!('habits' in initialBob), 'Search leaked habit data', initialBob);

  await expectResponse(
    'self request rejected',
    await post('/api/social/friend-request', alice.token, {
      target_user_id: alice.user_id,
    }),
    [400],
  );

  const firstRequest = await expectResponse(
    'Alice sends Bob request',
    await post('/api/social/friend-request', alice.token, {
      target_user_id: bob.user_id,
    }),
  );
  assert(firstRequest.relationship_state === 'pending_outgoing', 'First request should be outgoing pending', firstRequest);

  const duplicateRequest = await expectResponse(
    'duplicate Alice request is idempotent',
    await post('/api/social/friend-request', alice.token, {
      target_user_id: bob.user_id,
    }),
  );
  assert(duplicateRequest.request_id === firstRequest.request_id, 'Duplicate request returned a different request id', {
    firstRequest,
    duplicateRequest,
  });
  assert(duplicateRequest.relationship_state === 'pending_outgoing', 'Duplicate request should stay pending_outgoing', duplicateRequest);

  const bobSeesAlicePending = await searchFor(bob.token, alice.username.slice(0, 8), alice.user_id);
  assert(
    bobSeesAlicePending.relationship_state === 'pending_incoming',
    'Bob should see Alice as pending_incoming',
    bobSeesAlicePending,
  );

  const bobRequests = await expectResponse(
    'Bob lists incoming requests',
    await get('/api/social/friend-request', bob.token),
  );
  assert(
    bobRequests.friend_requests.some((item) => item.id === firstRequest.request_id),
    'Bob request list missing Alice request',
    bobRequests,
  );

  await expectResponse(
    'Bob declines Alice request',
    await post('/api/social/friend-request/decline', bob.token, {
      request_id: firstRequest.request_id,
    }),
  );

  const bobRequestsAfterDecline = await expectResponse(
    'Bob request list clears declined request',
    await get('/api/social/friend-request', bob.token),
  );
  assert(
    !bobRequestsAfterDecline.friend_requests.some((item) => item.id === firstRequest.request_id),
    'Declined request is still listed',
    bobRequestsAfterDecline,
  );

  const secondRequest = await expectResponse(
    'Alice can resend after decline',
    await post('/api/social/friend-request', alice.token, {
      target_user_id: bob.user_id,
    }),
  );
  assert(secondRequest.relationship_state === 'pending_outgoing', 'Resent request should be pending_outgoing', secondRequest);

  await expectResponse(
    'Bob accepts Alice request',
    await post('/api/social/friend-request/accept', bob.token, {
      request_id: secondRequest.request_id,
    }),
  );

  const acceptedBob = await searchFor(alice.token, bob.username.slice(0, 8), bob.user_id);
  assert(acceptedBob.relationship_state === 'accepted', 'Alice should see Bob as accepted', acceptedBob);
  const acceptedAlice = await searchFor(bob.token, alice.username.slice(0, 8), alice.user_id);
  assert(acceptedAlice.relationship_state === 'accepted', 'Bob should see Alice as accepted', acceptedAlice);

  const acceptedDuplicate = await expectResponse(
    'accepted duplicate request is idempotent',
    await post('/api/social/friend-request', alice.token, {
      target_user_id: bob.user_id,
    }),
  );
  assert(acceptedDuplicate.relationship_state === 'accepted', 'Accepted duplicate should stay accepted', acceptedDuplicate);

  console.log('Social friend smoke completed.');
}

run().catch((error) => {
  console.error(error);
  process.exit(1);
});
