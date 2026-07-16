const baseUrl = process.env.HABLE_API_BASE_URL ?? 'http://127.0.0.1:8787';
const userId = process.env.HABLE_RELEASE_SMOKE_USER_ID ?? 'local-user-1';
const allowMutation = process.env.HABLE_RELEASE_SMOKE_ALLOW_MUTATION === '1';
const habitId = 'release-smoke-owned-habit';

async function readBody(response) {
  const text = await response.text();
  if (!text.trim()) return {};
  try {
    return JSON.parse(text);
  } catch {
    return { raw: text };
  }
}

async function request(path, options = {}) {
  const response = await fetch(`${baseUrl}${path}`, options);
  return { response, body: await readBody(response) };
}

function authHeaders(token) {
  return {
    'content-type': 'application/json',
    authorization: `Bearer ${token}`,
  };
}

function assert(condition, message, detail) {
  if (!condition) {
    throw new Error(`${message}${detail ? ` ${JSON.stringify(detail)}` : ''}`);
  }
}

async function expectStatus(label, path, options, statuses = [200]) {
  const result = await request(path, options);
  assert(
    statuses.includes(result.response.status),
    `${label}: expected ${statuses.join(', ')}, got ${result.response.status}`,
    result.body,
  );
  console.log(`PASS ${label}`);
  return result.body;
}

async function login() {
  const body = await expectStatus('authenticated fixture login', '/api/auth/login', {
    method: 'POST',
    headers: { 'content-type': 'application/json' },
    body: JSON.stringify({ user_id: userId }),
  });
  assert(body.token && body.user_id === userId, 'fixture login returned an invalid session', body);
  return body.token;
}

async function profile(token) {
  return expectStatus(
    'authenticated profile read',
    `/api/social/user/${encodeURIComponent(userId)}/profile`,
    { headers: authHeaders(token) },
  );
}

async function resetFixture(token, label = 'fixture reset') {
  await expectStatus(
    label,
    `/api/sync/habit/${habitId}`,
    { method: 'DELETE', headers: authHeaders(token) },
  );
  const resetProfile = await profile(token);
  assert(
    !resetProfile.habits?.some((habit) => habit.id === habitId),
    `${label} left owned data behind`,
    resetProfile.habits,
  );
}

async function runCycle(token, cycle) {
  await resetFixture(token, `fixture reset before cycle ${cycle}`);

  await expectStatus(`fixture habit write cycle ${cycle}`, '/api/sync/habit', {
    method: 'POST',
    headers: authHeaders(token),
    body: JSON.stringify({
      habit_id: habitId,
      title: 'Release Smoke Habit',
      description: 'Bounded fixture-owned release smoke data.',
      target_duration: 3,
      color_hex: 'FF9CAF88',
      status: 'active',
    }),
  });

  const writtenProfile = await profile(token);
  const writtenHabit = writtenProfile.habits?.find((habit) => habit.id === habitId);
  assert(writtenHabit?.title === 'Release Smoke Habit', `cycle ${cycle} read did not return the written habit`, writtenProfile.habits);

  await expectStatus(`fixture core write action cycle ${cycle}`, '/api/sync/log', {
    method: 'POST',
    headers: authHeaders(token),
    body: JSON.stringify({
      log_id: `release-smoke-owned-log-${cycle}`,
      habit_id: habitId,
      status: 'completed',
      logged_at: '2026-01-01T12:00:00.000Z',
    }),
  });

  const completedProfile = await profile(token);
  const completedHabit = completedProfile.habits?.find((habit) => habit.id === habitId);
  assert(completedHabit?.current_duration === 1, `cycle ${cycle} started with stale progress`, completedHabit);
  await resetFixture(token, `fixture reset after cycle ${cycle}`);
}

async function run() {
  console.log(`Release fixture smoke against ${baseUrl}`);
  const token = await login();

  await expectStatus(
    'invalid-session error is safe',
    '/api/sync/daily',
    { headers: { authorization: 'Bearer invalid-release-smoke-token' } },
    [401, 403],
  );
  const initialProfile = await profile(token);
  assert(initialProfile.user?.id === userId, 'profile read returned the wrong fixture user', initialProfile.user);

  if (!allowMutation) {
    console.log('BLOCKED authenticated fixture write: set HABLE_RELEASE_SMOKE_ALLOW_MUTATION=1 for an isolated local fixture.');
    return;
  }

  try {
    await runCycle(token, 1);
    await runCycle(token, 2);
    console.log('PASS repeated fixture reset, recreate, progress, and cleanup');
  } finally {
    await resetFixture(token, 'final fixture cleanup');
  }
}

run().catch((error) => {
  console.error(`BLOCKED release fixture smoke: ${error.message}`);
  process.exitCode = 2;
});
