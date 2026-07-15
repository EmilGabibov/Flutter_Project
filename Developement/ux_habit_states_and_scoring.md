# Scoring, Gamification, and Habit States

> [!NOTE]
> This document details the product experience, logic, and state moments related to Hable's scoring system, daily quotes, rewards, and UI habit states. It bridges the backend truth (Cloudflare Worker) with the frontend display (Flutter).

## 1. The Scoring System Contract

Scoring in Hable is fundamentally **backend-owned** to ensure trust and consistency across the social features. The Flutter client does not dictate score; it only fetches and displays cached score states provided by the `/api/sync/daily` and leaderboard endpoints. `api/sync/score` is explicitly **deprecated** (returns `410 Gone`).

### Score Calculations & Triggers
Scores are tracked continuously per user via the `total_score` column on the `users` table and recorded idempotently in `user_score_events`.
- **Completed Check-In (`completed_check_in`):** Awarded when a user successfully checks into a habit.
- **Shared Habit Bonus:** Currently scoped for bonus logic on the backend when multiple partners participate in a shared habit.

### Cumulative vs. Resets
Scores are **cumulative**. There are currently **no seasonal resets** or wiping of points at the start of a week/month. A user's `total_score` represents their lifetime engagement.
> **Future Gap:** If global scale requires it, a "Seasonal Leaderboard" or "Weekly Reset" layer may be designed later. For now, all points are cumulative lifetime points.

---

## 2. Leaderboard & Score Visibility

### Leaderboard Scope (Social Hub)
The leaderboard (Social Hub → Leaderboard tab) queries `/api/social/leaderboard`.
- **Visibility:** The leaderboard is **friend-scoped**. It displays the current user plus their **accepted friends**. It is not a global public leaderboard.
- **Sorting:** Ordered by `total_score DESC, username ASC`.
- **Update Cadence:** The leaderboard reflects the latest backend state when fetched.

### Profile Visibility
- **Current User Profile:** The user's total score, level, and earned badges are fetched via the daily sync and displayed.
- **Friend Profile:** When viewing a friend's profile, their score is visible as part of their public card.

### Surface Differences
The app intentionally shows score-related numbers at different levels of granularity:
- **Leaderboard total:** The Social leaderboard ranks accepted friends by backend-owned lifetime `total_score`. This is an all-time standing, not a per-day or per-habit value.
- **Profile lifetime score:** The current user profile reads backend `gamification.total_points` plus the backend-derived level and badges from `/api/sync/daily`. This should match the user’s lifetime score semantics, but it may refresh on a different cadence from the independently fetched leaderboard endpoint.
- **Per-check-in awards:** Completion splashes, Profile history rows, and the 30-day Journey chart show per-log awards such as `5 points earned`, `10 points earned`, or `+5 pts`. These are event-level rewards, not replacements for the lifetime total.

When these numbers differ, the expected explanation is usually **scope or timing**, not conflicting business logic: a single check-in award is one event, while profile and leaderboard totals are cumulative backend aggregates that refresh through separate network paths.

---

## 3. Rewards & Badges

Currently, rewards are structured around Levels and Streak Badges derived from points and continuous check-ins.
- **Implemented:** Users reach level tiers based on cumulative score. Badges are unlocked and returned via the daily gamification payload.
- **Deferred/Future Rewards:** Marketplace rewards, cosmetic profile borders, and in-app currency for avatar customization are potential future features, but are currently out of scope.

---

## 4. Encouraging Quotes & Motivation

Quotes are delivered by the Worker daily sync, cached in Drift, resolved through `QuoteProvider`, and displayed prominently on the Home dashboard.
- **Behavior:** Quotes serve as the emotional anchor for the day. The Worker fetches one inspirational Quotable quote per UTC day, accepts only trimmed text up to 180 Unicode code points, preserves the optional author, caches it in KV, and sends it as `/api/sync/daily.quote`; Flutter stores the same normalized text and author in `cached_quotes`. If the synced quote is absent or rejected as too long, the app falls back to deterministic local copy.
- **Onboarding quote beat:** The new-user slide sequence opens with the existing quote provider so first-run education starts with the same cached/fallback quote contract as Home and celebration surfaces.
- **First-run opening:** The first authenticated entry for a user can now pause on a dedicated quote splash before the main shell appears. This splash is storage-gated per user so it acts as a one-time emotional opening rather than a recurring blocker.
- **Implemented Personalization:** The local fallback path now reacts to coarse state buckets only: recent skips, social momentum (recent nudge / partner completion activity), active streak strength, and no-active-habit fresh-start states. Daily reminder copy uses the same coarse context buckets plus early/late timing buckets.
- **Remaining Gap:** This is still a lightweight local resolver, not a full experimentation or deeply adaptive copy system. Future work can expand locale, quiet-hours policy, or remote experiments without changing the offline-safe fallback contract.

---

## 5. Habit States: Product Principles & UX Moments

A core part of the Hable experience is how it feels to interact with habits across different states. Based on behavioral design principles (such as those in *Atomic Habits* or *Hooked*), providing immediate, satisfying feedback is crucial for habit formation.

### 5.1 "Empty Day" / No Completions
- **Research:** Users facing an empty list can feel overwhelmed. A blank slate should be treated as an opportunity, not a punishment.
- **Proposed UX (Future):** A soft, encouraging splash screen or an inline empty-state illustration that acknowledges the new day. "Every day is day one."

### 5.2 The Check-In Celebration
- **Research:** Immediate positive reinforcement strengthens the habit loop.
- **Current UX:** Habit completion now drains through a serialized celebration queue so badge reveals and habit splashes never overlap. The completion splash uses the completed habit's color as the animated backdrop, requires an explicit `Continue` action, and states the local reward plainly: `5 points earned` for a standard completion or `10 points earned` when the shared completion bonus lands.
- **Quote hierarchy:** When a celebration surface carries a quote, the quote now leads the composition as the first and largest reader-facing element rather than sitting as a footer beneath generic success copy.
- **History visibility:** Profile → habit history now preserves the per-log local points award as a compact `+5 pts` / `+10 pts` badge so users can verify what that check-in contributed before aggregate score surfaces refresh from sync.
- **Future polish:** Audio, richer milestone choreography, or broader reward-scene experimentation can still expand from this without changing the serialized overlay contract.

### 5.3 The Resting State (Completed Today)
- **Research:** Once a task is done, it should visually "get out of the way" to reduce cognitive load, but remain visible to provide a sense of accomplishment.
- **Current UX:** Completed cards remain visible but visually distinct.
- **Proposed Adjustment:** Integrate the 🔥 (streak) into the progress bar elegantly.
  > **Note on Streaks vs. Days:** The user shouldn't be overloaded with numbers. If a habit runs for 30 days, showing both "Day 14/30" and "🔥 14 Streak" is redundant. **Recommendation:** For challenge-based habits (e.g., 30-day challenge), emphasize the "Day X/Y" progress. For continuous lifestyle habits (no end date), emphasize the "🔥 Streak".

### 5.3.1 Completed Challenge Lifecycle
- Solo challenge habits that reach zero remaining days should leave Home automatically by moving into Profile's archived-history lane rather than staying as active cards or turning into a second badge system.
- Backend-owned achievements remain the canonical badge surface. Completed habits belong to history, not to a duplicate local achievements collection.
- Shared habits are different: a participant's daily completion must not auto-archive the shared metadata row until the explicit shared-lifecycle rules say so.

### 5.4 Streak Milestones
- **Research:** Variable rewards or unexpected celebrations for milestones (7 days, 30 days) significantly boost retention.
- **Proposed UX (Future):** Special animations and intense haptics when hitting a major streak milestone.

### 5.5 Skipping & Missed Check-Ins
- **Crucial Update:** A habit tracker should not provide a literal "Skip" button that lets a user easily dismiss the habit without consequence. Skipping a check-in is automatically registered as a missed check-in by simply letting the day expire.
- **Action Required (Gap):** Remove the explicit "Skip" button from the habit card UI.

### 5.6 Shared Habit Sync & Nudges
- **UX Moment:** When Bob completes a shared habit, Alice should see that completion reflected.
- **Nudge Receipt:** Receiving a nudge should feel supportive, not demanding. Visual chips like "Nudged by Alice" on the habit card help contextualize the notification.

---

## 6. Known Gaps & Backlog Inventory

The following items are recognized as missing or deferred and require separate implementation tasks:

1. **Remove "Skip" Button:** Remove the explicit skip action from the UI; uncompleted habits should simply expire at the end of the day.
2. **Consolidate "Add Habit" Buttons:** There are currently two Add Habit buttons in the UI. These need to be consolidated into a single, clear call-to-action.
3. **Streak vs. Progress UI Polish:** Redesign the habit card to elegantly integrate the 🔥 icon with the progress bar without numerical redundancy.
4. **Contextual Quotes:** Expand beyond the current coarse local resolver if the product later needs richer streak tiers, locale-specific writing, or server-driven experiments.
5. **Haptics & Animations:** Implement the proposed haptic feedback and micro-animations for check-ins and streak milestones.
6. **Seasonal Resets:** (Long-term) Define a policy and UI for seasonal leaderboard resets if cumulative scoring becomes uncompetitive for new users.
