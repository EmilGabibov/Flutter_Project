# Web Multi-User Browser Test Plan: Social & Leaderboard Flows

> [!NOTE]
> This QA plan outlines the expected behavior for the **deployed web build** (Cloudflare Pages) connecting to the production `/api/*` contract.
> 
> **Automated Execution:** The steps in this plan are fully automated in the `e2e/tests/shared_habit.spec.ts` Playwright test suite, which can be run locally using `npm run test` in the `e2e` directory. The manual guide below remains for ad-hoc debugging or production verification.

## 1. Environment & Prerequisites
- **Target:** Deployed web build (e.g., `https://hable.app` or specific preview URL).
- **Isolation Requirement:** You must use **two completely isolated browser sessions** to prevent state pollution. This can be achieved by:
  - Using two different physical browser apps (e.g., Chrome and Firefox).
  - Using two separate browser profiles in Chrome.
  - Using one normal window and one Incognito/Private window.
- **Test Accounts:**
  - **User A (Alice):** Seeded or newly registered user.
  - **User B (Bob):** Seeded or newly registered user.

> [!WARNING]
> Do not use the same browser session or profile for both users. Local storage (Drift web, token state) will collide and invalidate the test.

## 2. Test Execution Steps

### Step 1: Authentication & Isolation Check
1. **User A (Alice):** Open the deployed web app in Browser 1. Register or log in. Verify successful entry into the main Home dashboard.
2. **User B (Bob):** Open the deployed web app in Browser 2. Register or log in. Verify successful entry.
3. **Validation:** Check that User A's profile only shows User A's data, and User B's profile only shows User B's data.

### Step 2: Friend Search & Request
1. **User A:** Navigate to the Social Hub.
2. **User A:** Open the "Find Friends" search interface.
3. **User A:** Search for User B's exact username.
4. **Validation:** User B should appear in the search results.
5. **User A:** Click "Send Friend Request" to User B.

### Step 3: Accept / Decline Friend Request
1. **User B:** Navigate to the Social Hub → Activity/Requests tab.
2. **Validation:** User A's friend request should appear as pending.
3. **User B:** Click **Accept**.
4. **Validation:** User A should now appear in User B's friend list, and User B in User A's friend list.
5. **User A or User B:** Long-press an accepted friend card in the Friends tab and choose **Unfriend** from the context menu. Confirm the removal.
6. **Validation:** After a sync or refresh, the friendship should disappear from both users' accepted-friends lists, and a search for the other user should show `none` for `relationship_state`.
   *Note: Decline flow is supported. You can repeat Steps 2 & 3 with a third user (User C) to verify the Decline button removes the pending request and does not add the friend.*

> [!IMPORTANT]
> **Revoke Friendship:** The ability to unfriend or revoke an active friendship is supported in the deployed web build via the Friends tab long-press menu.

### Step 4: Habit Creation & Partner Invite
1. **User A:** Return to the Home tab and tap the FAB to create a new Habit.
2. **User A:** Fill in the habit title and details.
3. **User A:** During creation, use the partner selection UI to add User B (now an accepted friend) as a partner.
4. **User A:** Save/Create the habit.
5. **Validation:** The habit should appear on User A's dashboard. A habit invite should be queued for User B.

### Step 5: Habit Invite Acceptance
1. **User B:** Navigate to the Home dashboard or Social Activity feed.
2. **Validation:** An invitation banner or notification from User A for the new habit should be visible.
3. **User B:** Accept the habit invitation.
4. **Validation:** The shared habit should now appear on User B's Home dashboard as an active habit.

### Step 6: Nudge Send / Receive
1. **User A:** On the shared habit card on the Home dashboard, tap the nudge/hand action directed at User B.
2. **User B:** Wait a moment or refresh if required. Check the Social Activity feed or habit card UI.
3. **Validation:** User B should receive a visual indication of the nudge (e.g., a "Nudged by User A" chip or notification row).

### Step 7: Dual Check-Ins & Point Scoring
1. **User A:** Complete (check-in) the shared habit from the Home dashboard.
2. **User B:** Complete (check-in) the shared habit from their Home dashboard.
3. **Validation:** A short press/release on the mud completion control must **not** complete the habit or advance shared progress. Only a full sustained hold through the required duration should complete.
4. **Validation:** Both users should see the habit marked as completed for the day only after a valid hold. Shared habit cards should remain visible on Home after check-in. Both users should see their personal point scores increment based on the completion, with the shared bonus/state update appearing only after all participants complete.

### Step 8: Leaderboard Verification
1. **User A:** Navigate to the Social Hub → Leaderboard.
2. **User B:** Navigate to the Social Hub → Leaderboard.
3. **Validation:** The leaderboard should accurately reflect the updated scores of both User A and User B following their successful check-ins. Verify that the score syncs correctly from the server, indicating that scoring is properly server-owned.

## 3. Post-Execution & Cleanup
- Document any failures directly against the steps above.
- *Cleanup:* Revoke friendship is supported, so use it to reset the test accounts if clean state is required.
