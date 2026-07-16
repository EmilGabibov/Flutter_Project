<!-- AI AGENT OPERATING CONTRACT — See ai_agent_contract.md for full rules. This file is the raw intake queue (§5 / §2). -->

## Raw Tasks Intake

<a id="configure-web-push-secrets-so-api-push-config-stops-returning-503"></a>
### Configure Web Push Secrets So `/api/push/config` Stops Returning `503`

**Raw source:** Web notification enablement fails on the production web app because `GET https://hable.pages.dev/api/push/config` returns `503 Service Unavailable` during the subscribe flow.

**Issue:** The browser-side web push path is present, but the backend config endpoint reports `push_unconfigured` because the deployed Pages environment is missing the Web Push VAPID bindings. That prevents the app from returning the public key needed to subscribe, so notification setup fails before the permission/subscription flow can complete.

**Triage:**
- *Should exist:* Yes.
- *Smallest safe scope:* Wire the production Pages deployment to the required Web Push secrets and verify `/api/push/config` returns `200` with a public key.
- *Skipped scope:* Do not redesign notification UX, change reminder delivery behavior, or add new push features in this task.
- *Boundaries:* Keep the fix limited to deployment/configuration and the existing config/subscribe endpoints.

**Action:** Ensure the deployed Hable web backend has `VAPID_PUBLIC_KEY`, `VAPID_PRIVATE_KEY`, and `VAPID_SUBJECT` available so the config endpoint can serve the public key to the existing Web Push client. If the reminder dispatch path is being exercised too, keep `PUSH_DISPATCH_TOKEN` aligned with the same deployment, but do not broaden this task into the push delivery implementation itself.

**Acceptance criteria:**
- `/api/push/config` returns `200` in the production web deployment.
- The response includes a non-empty `public_key` value.
- The web notification subscription flow can proceed past config fetch.
- The task remains scoped to deployment/config wiring, not a notification redesign.
