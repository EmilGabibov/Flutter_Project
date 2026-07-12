# Hable: Raw Ideas & Feature Backlog to discuss them with ai chat bots

document different sections, tabs, and pages (home, profile, social, settings, etc):
Then revise the structure and the placement of them, how should it be organized, and what should it contain. Consider using the tabs for the main navigation elements, and a page for the most important action (creating a habit).
try to minimalize the clutter, try to use the minimum amount of ui elements to achive the maximum amount of information and functionality in these sections. (thinking as a designer): this is a habit tracker, which the user should see and use everyday. it needs to be simple, elegant, and easy to use. it should not be overwhelming, or complicated. the ui should be clean, and modern, and most important.. it should be fun to use! and engaging. think about the current ui, and how it can be improved. (thinking as a developer): in terms user journey, and the most common user actions, how can we optimize the user flow? are there any redundant steps? can we simplify the process? are there any missing steps? are there any patterns you've noticed in the current ui that could be improved or streamlined?. try to put yourself in the user's shoes and think about how they would interact with the app. what would make their experience better? what would make it more enjoyable? 
    - home: (the main screen, it should display the current habits, and the user's progress. it should also have a clear and obvious way to create a new habit. the layout should be simple and uncluttered, with the most important information being the most prominent. it should be easy to navigate, and the user should be able to quickly and easily find what they need. it should be visually appealing, and the user should enjoy using it. also, we should 
    - profile: (should display the user's profile, including their name, username, and profile picture. it should also display the user's habits, and their progress. the layout should be simple and uncluttered, with the most important information being the most prominent. it should be easy to navigate, and the user should be able to quickly and easily find what they need. it should be visually appealing, and the user should enjoy using it. also, we should 
    - social: (should display the user's friends, and their partnered, and supported habits. it should also display the user's nudges (as an activity history), and their progress. it should be easy to navigate, and the user should be able to quickly and easily scan their friends and informed on mutual habit related obligations. it should be visually appealing, and the user should enjoy using it. also, we should be able to open friends profile.
    - settings: (should display the user's settings, including their notification preferences, and their account information (email (authenticated or not), name, username, profile picture (able to modify, set another emoji or uploading a picture), etc.). it should be easy to navigate, and the user should be able to quickly and easily find what they need. it should be visually appealing, and the user should enjoy using it. also, we should consider the foundation for future set of settings, like accessibility and language.
    - creating habit: (should display the habit creation form like an onboarding, but with a few extra options, like adding partners, able to set custom emoji, etc. information being the most prominent. it should be easy to navigate, and the user should be able to quickly and easily find what they need. it should be visually appealing, and the user should enjoy using it.

# Issue 1 — The app never updates itself. You always have to restart.

## What is happening

When you do something in the app — send a friend request, accept one, complete a habit, send a nudge — the backend server receives it and saves it correctly. You can see this in the server logs. But the app on the other person's screen (or even your own screen after switching tabs) never reflects the change. Nothing moves. Nothing updates.


## Gemini Prompt — Issue 1


You are a Flutter developer working on Hable, a habit-tracking app that uses:
- Flutter + Riverpod (state management)
- Drift (local SQLite, offline-first)
- Cloudflare Workers backend (REST API)
- connectivity_plus for network detection
- workmanager for background tasks

PROBLEM:
The app receives and sends data to the backend correctly (confirmed by server logs),
but the UI never auto-refreshes. Users must fully restart the app to see any changes
— friend requests, accepted friendships, notifications, partner habit updates, or
leaderboard scores. This makes live demos and normal social use impossible.

ROOT CAUSE:
SyncService.pullDailySync(userId) exists and works correctly, but it is only called
once — in HomeScreen.initState. There is no periodic polling, no timer, no lifecycle
hook to re-trigger it while the app is open. The Social tab, Profile tab, and
Notification Center all read from Drift StreamProviders, so they will update
automatically as soon as Drift is refreshed — the missing piece is triggering
pullDailySync regularly.

REQUIREMENTS:
1. Poll GET /api/sync/daily silently every 7 seconds while the app is in the foreground
2. Stop polling the moment the app goes to the background (WidgetsBindingObserver)
3. Resume polling when the app comes back to the foreground
4. Polling must be silent — no loading spinners, no UI blocking, no jank
5. Add a "Refresh" IconButton in the Social Hub header for manual refresh
6. Re-use the existing SyncService.pullDailySync() — do NOT create new HTTP calls
7. Prevent duplicate overlapping polls (use a timestamp guard: skip if last poll
   was less than 5 seconds ago)
8. The polling mechanism must also trigger ref.invalidate on the relevant Riverpod
   providers after each sync so the UI picks up new Drift data immediately

CONTEXT:
- SyncService is in lib/services/sync_service.dart
- syncServiceProvider is in lib/providers/sync_provider.dart
- HomeScreen is in lib/screens/home_screen.dart
- Social Hub screen/tabs are in lib/screens/social/
- Riverpod providers to invalidate after sync:
    * activeHabitsProvider
    * habitPartnersProvider
    * currentUserProvider
    * unreadNotificationCountProvider
    * acceptedFriendsProvider (or equivalent)
- App entry point with lifecycle awareness: lib/main.dart (HableApp class)

DELIVERABLES:

Step 1 — Create a PollingNotifier or use a plain Timer in a StateNotifier:
  - Track lastSyncAt: DateTime
  - Expose a syncNow(String userId) method
  - syncNow calls SyncService.pullDailySync(userId) and then invalidates providers
  - Guard: if DateTime.now().difference(lastSyncAt) < 5 seconds, skip

Step 2 — Add WidgetsBindingObserver to HableApp (lib/main.dart):
  - On AppLifecycleState.resumed: start Timer.periodic(7 seconds, syncNow)
  - On AppLifecycleState.paused or detached: cancel timer
  - On initial launch (app opened): fire one immediate syncNow

Step 3 — Wire the timer to the logged-in userId:
  - Read userId from authProvider inside the observer
  - Only start polling if isAuthenticated == true
  - Stop polling on logout

Step 4 — Add a Refresh button to the Social Hub header:
  - IconButton with Icons.refresh_rounded or Icons.sync_rounded
  - On tap: call syncNow(userId) immediately
  - Show a brief rotating animation while sync is in progress (AnimatedRotation,
    not a blocking spinner)

Step 5 — Test:
  - Open app as User A (Chrome), open app as User B (Android emulator)
  - User A sends friend request to User B
  - Without restarting: User B should see the friend request within 7-10 seconds
  - User B accepts the request
  - Without restarting: User A should see the friendship within 7-10 seconds
  - Switch tabs on User A (Home → Social → back): UI still current, no stale data
  - Background the app for 30 seconds, foreground it: one immediate sync fires

AVOID:
- Making new HTTP calls outside SyncService.pullDailySync
- Blocking the UI thread or showing progress indicators for routine polls
- Running the timer when the app is backgrounded (battery drain)
- Calling pullDailySync with a null or stale userId
- Creating duplicate timers if the lifecycle event fires more than once


# Issue 2 — You can add yourself as your own friend

## What is happening

While clicking around the app, it was possible to send a friend request to yourself. After restarting the app, you appeared in your own friends list. This is clearly wrong — you should never be your own friend.

 Gemini Prompt — Issue 2


You are a Flutter developer working on Hable, a social habit-tracking app.

PROBLEM:
A user was able to send a friend request to themselves. After restarting the app,
they appeared in their own friends list. This corrupts the social graph and can
cause loops in the partnership and leaderboard systems.

The backend correctly returns HTTP 400 with { error: "Cannot send a friend request
to yourself" } when requester_id === recipient_id. However:
1. The Flutter frontend never checks before sending the request
2. The HTTP 400 error response is silently swallowed — no snackbar, no message
3. After sync, the self-row may end up cached in Drift as an accepted friend

ROOT CAUSE (triple failure):
A — No client-side guard: the "Send Request" button is enabled even when the
    target user is the currently logged-in user
B — No error surfacing: the HTTP 400 response from the backend is not shown
    to the user; the UI just does nothing
C — Stale Drift cache: if a self-friendship row ever made it into accepted_friends
    or friend_relationships in Drift, it persists across restarts

REQUIREMENTS:
1. Frontend guard: if targetUserId == currentUserId, disable the button entirely
   and optionally show a label like "That's you" instead of "Add Friend"
2. Error handling: if backend returns 400 for any friend request action, show a
   clear SnackBar with the error message from the response body
3. Drift cleanup: when writing accepted friends to the local cache during
   pullDailySync, skip any row where friend_id == current userId
4. One-time cleanup: on app startup, delete any friend_relationships or
   accepted_friends rows where the stored userId matches the current logged-in userId

CONTEXT:
- Current userId comes from ref.watch(authProvider).userId
- Friend search is in the Social Hub "Find Friends" bottom sheet
- Friend request send action is likely in a social provider or directly in the widget
- Backend endpoint: POST /api/social/friend-request with { target_user_id }
- Backend response on self-request: HTTP 400, { error: "Cannot send a friend
  request to yourself" }
- Drift tables involved: accepted_friends, friend_relationships
- SyncService.pullDailySync handles writing accepted friends to Drift

DELIVERABLES:

Step 1 — Add client-side guard in the Find Friends sheet:
  - Before rendering the "Add Friend" button for a search result, check:
      if (result.userId == ref.watch(authProvider).userId)
        → render a greyed-out chip labeled "You" instead of the action button
  - Also guard the send-request function itself:
      if (targetUserId == currentUserId) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You can't add yourself as a friend"))
        );
        return;
      }

Step 2 — Add error handling on 400/409 responses:
  - In the friend request send function, after the HTTP call:
      if (response.statusCode == 400 || response.statusCode == 409) {
        final error = jsonDecode(response.body)['error'] ?? 'Request failed';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error))
        );
        return;
      }

Step 3 — Filter self-rows in Drift during sync:
  - In SyncService.pullDailySync, when processing accepted_friends list:
      if (friendId == userId) continue; // skip self-rows
  - Same filter when processing partner snapshots:
      if (partnerUserId == userId) skip the upsert

Step 4 — Startup cleanup:
  - In AppDatabase, add a method: Future<void> removeSelfFromSocialCache(String userId)
      → DELETE FROM accepted_friends WHERE friend_user_id = userId
      → DELETE FROM friend_relationships WHERE user_id = userId
         AND relationship_state = 'accepted'
  - Call this method once after auth is confirmed (in _AppGate after userId is known)

Step 5 — Test:
  - Search for your own username in Find Friends
  - Confirm "Add Friend" button is replaced with "You" chip or is disabled
  - Attempt to trigger the request programmatically → confirm 400 snackbar appears
  - Restart app → confirm you are not in your own friends list
  - Confirm leaderboard does not include a duplicate self-row

# Issue 3 — Lots of empty space on screen, content is bunched in the middle

## What is happening

On both the web version (Chrome) and the Android emulator, many screens have a large empty area at the top. The actual content — friend cards, habit cards, lists, the leaderboard — starts in the vertical middle of the screen and then continues downward. All the space above the content is just blank.

On a phone screen this means you can see fewer habits or friends at once than you should. On web it is even worse because the browser window is bigger but the content still sits in the middle. It feels unfinished and wastes a lot of usable space.


  
## Gemini Prompt — Issue 3

You are a Flutter developer working on Hable, a cross-platform habit app targeting
Android (primary) and Flutter Web (secondary).

PROBLEM:
Multiple screens waste vertical screen space. Content is vertically centered instead
of top-aligned, leaving large blank areas above the content. On Android this reduces
visible habits/friends per screen. On web the problem is amplified because more
vertical space is available but unused.

Affected screens confirmed by testing:
- Social Hub: Friends tab, Activity tab, Leaderboard tab
- Home: habit cards list
- Profile: habit management section, charts section
- Notification Center: notification list

ROOT CAUSE:
Widgets are wrapped in Center() or use fixed SizedBox heights for top padding instead
of flex-based layouts. ListView/Column children are not top-aligned. No max-width
constraint exists for web, causing content to span the full browser width.

REQUIREMENTS:
1. All content lists must start from the top of the available screen area, directly
   below the app header or status bar (use SafeArea, not manual padding)
2. Replace Center() wrapping non-empty scrollable content with
   Column(crossAxisAlignment: CrossAxisAlignment.start) or top-aligned ListView
3. Use Expanded/Flexible for widgets that should fill remaining vertical space
4. Cards must size themselves to their content — no fixed heights unless necessary
5. Empty states (truly empty, no data) may remain centered — this is correct UX
6. Web: wrap page content in ConstrainedBox(maxWidth: 600) + Center so it does
   not stretch across a full browser window
7. SliverFillRemaining with hasScrollBody: false should only be used for
   empty states, not content lists

CONTEXT — SCREENS TO FIX:

lib/screens/home_screen.dart
  - SliverFillRemaining wraps empty state → correct, keep as-is
  - Habit cards use SliverList → should be top-aligned already, check padding
  - Remove any excessive top padding above the greeting header

lib/screens/social/ (Friends tab, Activity tab, Leaderboard tab)
  - Check if tabs use Center() as root widget
  - Friends list: pending requests at top, then accepted friends → ListView from top
  - Activity/Notification feed: ListView.builder from top, no centering
  - Leaderboard: scrollable list from top, not a centered card

lib/screens/profile_screen.dart
  - Charts section: top-aligned in CustomScrollView SliverToBoxAdapter → check
  - Manage Habits section: SliverList should top-align → verify no excess spacing
  - Remove any SizedBox(height: X) that artificially push content down

lib/screens/notification_center_screen.dart
  - Root: should be ListView.builder or CustomScrollView, not Center
  - Notifications should render from top of screen body

DELIVERABLES:

Step 1 — Audit and fix each affected screen:
  For EACH screen:
    a. Remove Center() wrapping any list or content area
    b. Replace with Column(crossAxisAlignment: CrossAxisAlignment.start) +
       Expanded(child: ListView.builder(...))
    c. Use SafeArea(top: true) at screen root instead of manual SizedBox heights
    d. Ensure ListView.builder uses padding: EdgeInsets.only(bottom: 96) for
       floating action button clearance, nothing extra on top

Step 2 — Web max-width wrapper:
  - Create a reusable widget:
      class WebConstrainedBody extends StatelessWidget {
        final Widget child;
        const WebConstrainedBody({required this.child});
        @override
        Widget build(BuildContext context) {
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600),
              child: child,
            ),
          );
        }
      }
  - Wrap the body of Social Hub, Notification Center, and Profile in this widget
  - Do NOT wrap Home (it already uses CustomScrollView SliverList which handles width)

Step 3 — Fix card heights:
  - Remove any Container(height: X) or SizedBox(height: X) wrapping habit cards
    or friend cards unless the height is truly needed for a visual element
  - Use IntrinsicHeight or let Column/Card size itself naturally

Step 4 — Test on both platforms:
  - Android emulator: open Home, Social (all 3 tabs), Profile, Notification Center
    → content must start at the top, no blank space above first card
  - Chrome (web): same screens → content should be centered with max 600px width,
    not spanning full browser window
  - Empty states (no habits, no friends, no notifications): these may remain centered

AVOID:
- Removing Center() from empty-state widgets (centered empty states are correct)
- Using shrinkWrap: true on root-level ListViews (causes performance issues)
- Hard-coding pixel heights for dynamic content
- Applying maxWidth constraint to Home screen (it already handles responsiveness)

# Issue 4 — After completing a habit there is no way to go back

## What is happening

When you hold the circular button to complete a habit, the animation plays and the button switches to show a green checkmark with "Done!" written underneath. That part works correctly.

The problem is what happens next: nothing. The screen just stays on that "Done!" state. There is no button to go back to the habit list, no automatic dismissal, no "Next habit" link, nothing. The only way out is to close the app and reopen it.


## Gemini Prompt — Issue 4

You are a Flutter developer on Hable, a habit-tracking app with a physics-based
long-press completion button called MudLongPressButton.

PROBLEM:
After a user completes a habit by holding the MudLongPressButton, the button
renders a checkmark and "Done!" text (via _buildCompletedState). The UI then
freezes in this state permanently. There is no way to navigate back to the habit
list without restarting the app.

TRACED CODE PATH (so you understand exactly what is happening):
1. User long-presses MudLongPressButton
2. AnimationController plays (400–1500ms depending on resistance)
3. addStatusListener fires when AnimationStatus.completed → calls widget.onCompletion()
4. onCompletion → _handleCompletion in _HabitCardState (home_screen.dart):
     - await db.insertLog(...)
     - await db.enqueueSync(...)
     - await db.completeHabitDay(...)
     - await ref.read(syncServiceProvider).flushPending()
     - ref.invalidate(todaysLogProvider(habit.habitId))
     - ref.invalidate(streakProvider(habit.habitId))
     - ref.invalidate(activeHabitsProvider(widget.userId))
     ← NO DISMISSAL, NO NAVIGATION, NO RESET HERE
5. Riverpod re-fetches todaysLogProvider → returns log with status=completed
6. isCompletedToday = true
7. MudLongPressButton receives isCompleted: true → calls _buildCompletedState()
8. Renders: checkmark icon + "Done!" text
9. ← UI is permanently stuck here

RELEVANT FILES:
- lib/widgets/mud_long_press_button.dart
  → _buildCompletedState() shows the frozen "Done!" state
  → isCompleted property controls which state renders
  → No auto-reset or navigation logic exists in this file

- lib/screens/home_screen.dart → _HabitCardState
  → _handleCompletion() is the callback
  → Calls ref.invalidate() but has no post-completion flow
  → isCompletedToday is derived from todaysLogProvider stream
  → Card is inside a SliverList in a CustomScrollView

REQUIREMENTS:
Implement OPTION A — Auto-reset card after 1.2 seconds:
  1. After _handleCompletion finishes all its awaits, wait 1.2 seconds
  2. Then reset the visual completion state so the card returns to normal
  3. The card should return to its default appearance:
     - Ring resets to empty (progress = 0)
     - "Hold to Complete" text returns
     - Skip button reappears (if not already skipped today)
  4. Transition must be smooth — use FadeTransition or AnimatedOpacity to
     cross-fade from "Done!" state back to default ring state
  5. After reset, the card stays in the list (it's still an active habit),
     it just no longer shows "completed" visually

Implementation detail for OPTION A:
  - Add a local state variable to _HabitCardState:
      bool _showingCompletionFeedback = false;
  - In _handleCompletion, after the last await:
      setState(() => _showingCompletionFeedback = true);
      await Future.delayed(const Duration(milliseconds: 1200));
      if (!mounted) return;
      setState(() => _showingCompletionFeedback = false);
  - In the build method, pass isCompleted to MudLongPressButton as:
      isCompleted: isCompletedToday && _showingCompletionFeedback
  - This way: button shows "Done!" for 1.2s, then reverts to normal ring
  - BUT: todaysLogProvider still returns completed log, so if user tries to
    hold again it immediately shows "Done!" (prevents double completion)

ADDITIONAL REQUIREMENTS:
  - Add a short haptic feedback at the moment of completion:
      HapticFeedback.mediumImpact() just before the 1.2s delay
  - Show a SnackBar during the 1.2s window:
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✓ ${habit.title} completed today!'),
          duration: Duration(milliseconds: 2000),
          behavior: SnackBarBehavior.floating,
          backgroundColor: habitColor.withOpacity(0.92),
        )
      );
  - After the 1.2s reset, the skip button should be hidden (habit was completed
    today, not skipped) — this is already handled by isCompletedToday logic

SKIP BUTTON BEHAVIOUR AFTER COMPLETION:
  - isCompletedToday = true → skip button must be hidden entirely
  - isSkippedToday = true → completion ring must be ignored (IgnorePointer)
  - These conditions are already in the code; confirm they still work after
    the reset (they should, because todaysLogProvider still returns completed)

TEST PLAN:
  1. Open Home with at least one active habit
  2. Hold the ring until completion animation finishes
  3. Confirm: "Done!" checkmark appears + snackbar appears + haptic fires
  4. Wait 1.2 seconds
  5. Confirm: card smoothly fades back to normal ring appearance
  6. Confirm: holding the ring again does NOT re-complete (ring should be
     visually holdable but onCompletion should not re-fire because isCompletedToday
     is still true from the Drift log)
  7. Refresh app (hot restart, not full restart) — card should remain in normal
     ring state, not stuck in "Done!" state

AVOID:
  - Navigating away from the screen (users may have multiple habits to complete)
  - Popping to a different route (the habit card is inline, not a pushed page)
  - Hard-resetting the Riverpod provider in a way that loses the isCompletedToday
    flag (if user already completed today, that state must persist)
  - Jarring transitions — use Curves.easeInOut for all fade animations
  - Blocking the UI during the 1.2s delay (Future.delayed must not freeze scroll)

# Issue 5 — Changing your avatar shows an error, but it actually worked

## What is happening

In Settings, there is an "Customize avatar" button where you can pick an emoji as your profile picture. When you tap a new emoji and confirm, the app immediately shows an error message saying it failed. But if you then restart the app, your new avatar is there — it actually saved correctly on the server.

The error is a false alarm. The backend accepted the change, but the app doesn't know that because the local user data in the database (Drift) wasn't updated. The profile card is still showing the old emoji from cache, and because the new emoji doesn't match what's in the cache, something in the comparison or response handling is triggering the error message incorrectly.


## Gemini Prompt — Issue 5


You are a Flutter developer on Hable, a habit-tracking app.

PROBLEM:
When a user changes their avatar (emoji) in Settings → Customize avatar:
1. The app shows an error snackbar: "Adding avatar failed" or similar
2. BUT the backend correctly saved the new avatar (confirmed: visible after restart)
3. The local profile card still shows the old avatar after the update attempt
4. After app restart the new avatar appears correctly

This is a false-negative error combined with a missing optimistic update. The
backend succeeds, the client panics incorrectly, and the local cache is stale.

BACKEND CONTRACT (confirmed working):
  PUT /api/user/avatar
  Request body: { "avatar_url": "🎉" }  (emoji only, URLs are rejected)
  Success response: HTTP 200, { "success": true, "avatar_url": "🎉" }
  Error responses:
    400 → { "error": "Avatar must be an emoji from the picker" }
    401 → Unauthorized (bad/expired JWT)
    500 → Server error

ROOT CAUSES (three separate failures):

A — No optimistic update:
  The app waits for the server response before updating the UI. During this wait,
  if any code path incorrectly interprets the state, it shows an error. Fix: update
  Drift immediately on submit, then reconcile with server response.

B — Response parsing bug:
  The success check likely does: if (response.statusCode != 200) showError()
  But may be reading the wrong field, checking the wrong condition, or the
  async/await chain is losing the response body before it is checked. The
  error fires even on HTTP 200.

C — No Drift refresh after success:
  After PUT succeeds, the authProvider or userProvider is not re-fetched, so
  currentUserProvider still streams the old user row from Drift. Profile card
  shows stale avatar.

CONTEXT:
- Avatar picker: lib/widgets/avatar_picker_sheet.dart (or inside profile_screen.dart
  _SettingsAccountCard)
- Avatar update method: likely authProvider.notifier.updateAvatar(emoji) or a
  direct HTTP call in the widget
- User model in Drift: has avatarUrl field
- currentUserProvider streams User? from Drift watchCurrentUser()
- After update, profile card reads currentUserProvider to display avatar

REQUIREMENTS:
1. Optimistic update: on submit, immediately update local Drift user row with the
   new emoji BEFORE sending the PUT request
2. Show success snackbar on HTTP 200
3. On HTTP 200: keep the optimistic update, call pullDailySync or invalidate
   currentUserProvider to confirm from server
4. On HTTP 400 (bad emoji): rollback Drift to previous avatar, show error snackbar
   with the backend error message
5. On HTTP 401/500: rollback Drift to previous avatar, show appropriate error
6. Loading state: disable submit button and show a small CircularProgressIndicator
   inside it while the PUT is in flight
7. After success: pop the bottom sheet (Navigator.of(context).pop())

DELIVERABLES:

Step 1 — Implement optimistic update in the avatar update function:
  Future<void> updateAvatar(String newEmoji) async {
    // 1. Read current avatar for potential rollback
    final user = await db.getCurrentUser();
    final previousAvatar = user?.avatarUrl;

 2. Optimistic update: write new emoji to Drift immediately
    await db.updateUserAvatar(userId, newEmoji);

    // 3. Send to backend
    try {
      final response = await http.put(
        Uri.parse('$apiBaseUrl/api/user/avatar'),
        headers: await _getAuthHeaders(),
        body: jsonEncode({ 'avatar_url': newEmoji }),
      );

      if (response.statusCode == 200) {
        // Success — optimistic update was correct, confirm it
        return; // done
      } else {
        // Failure — rollback
        if (previousAvatar != null) {
          await db.updateUserAvatar(userId, previousAvatar);
        }
        final error = jsonDecode(response.body)['error'] ?? 'Update failed';
        throw Exception(error);
      }
    } catch (e) {
      // Network error — rollback
      if (previousAvatar != null) {
        await db.updateUserAvatar(userId, previousAvatar);
      }
      rethrow;
    }
  }

Step 2 — Add updateUserAvatar to AppDatabase (database.dart):
  Future<void> updateUserAvatar(String userId, String avatarUrl) =>
    (update(users)..where((u) => u.userId.equals(userId))).write(
      UsersCompanion(
        avatarUrl: Value(avatarUrl),
        updatedAt: Value(DateTime.now()),
      ),
    );

Step 3 — Fix the AvatarPickerSheet UI:
  - Add loading state: bool _isSubmitting = false
  - On submit button tap:
      setState(() => _isSubmitting = true);
      try {
        await ref.read(authProvider.notifier).updateAvatar(selectedEmoji);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Avatar updated ✓'))
        );
        Navigator.of(context).pop(); // close sheet
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')))
        );
      } finally {
        if (mounted) setState(() => _isSubmitting = false);
      }
  - Submit button: disable and show spinner when _isSubmitting == true

Step 4 — Trigger currentUserProvider refresh after success:
  - In authProvider after successful updateAvatar: call ref.invalidate(currentUserProvider)
    OR: since Drift watchCurrentUser() is a stream, the update in Step 2 will
    automatically emit the new user row — confirm this is wired correctly

Step 5 — Test:
  - Open Settings → Customize avatar
  - Tap a new emoji
  - Confirm: profile card updates IMMEDIATELY (before server responds)
  - Confirm: submit button shows spinner and is disabled
  - Confirm: success snackbar appears ("Avatar updated ✓")
  - Confirm: sheet closes automatically
  - Close and reopen app: new avatar persists
  - Test error case: if possible, modify the request to send a URL instead of emoji
    → confirm rollback to old avatar + error snackbar + sheet stays open

AVOID:
  - Showing "failed" when the server returned 200 (the original bug)
  - Non-optimistic updates (waiting for server before showing change)
  - Keeping the sheet open after success
  - Silent swallowing of errors (always show snackbar with reason)
  - Forgetting to rollback Drift when server returns an error

  

# Issue 6 — After restarting the app, all habits and data are gone

## What is happening

This is the most serious issue. A user added habits to the app and completed some of them, earning 25 points. Everything seemed fine. Then the app was closed and reopened.

After restart:
- The Home screen was completely empty — no habits at all
- The Profile screen showed no habit distribution chart data
- The 25 points were gone from the display



## Gemini Prompt — Issue 6


You are a Flutter developer on Hable, a habit-tracking app built with Flutter +
Riverpod + Drift (local SQLite) + Cloudflare Workers backend.

CRITICAL PROBLEM:
After a user closes and reopens the app, all habits disappear from the Home screen,
the Profile chart shows "No data yet", and earned points are gone. The backend
correctly stored the data (25 points awarded confirms this). The problem is entirely
on the client side — data is either not being persisted, not being restored after
restart, or being loaded for the wrong user.

CONFIRMED EVIDENCE:
- Server has the data: 25 points were awarded, confirming habit creation and
  completion reached the backend successfully
- After restart: Home screen is empty (activeHabitsProvider returns [])
- After restart: Profile pie chart shows zero data (getLogDistribution returns 0s)
- Data reappears after re-login or longer wait, confirming it is not permanently lost

POSSIBLE ROOT CAUSES (investigate all of these):

ROOT CAUSE A — userId is different after restart:
  Drift queries filter by userId: watchActiveHabits(userId), getLogDistribution(userId)
  If the userId read from secure storage after restart is null, empty, or different
  from the one used to create the habits, all queries return empty.
  CHECK: Log userId at app startup and compare to userId used during habit creation.

ROOT CAUSE B — Habits exist in Drift but with wrong status:
  completeHabitDay() changes habit status to HabitStatus.completed when
  currentDuration reaches 0. If a user completed all days in a 1-day habit test,
  the habit is removed from watchActiveHabits (which filters status = 'active').
  CHECK: Query ALL habits (not just active) on restart to see if they exist.

ROOT CAUSE C — pullDailySync() never runs on restart:
  On app restart, HomeScreen.initState calls _pullDailySync(), but this runs
  AFTER the widget builds. If authProvider is not yet initialized, userId is null,
  and pullDailySync is called with an empty string or not called at all.
  CHECK: Add a debug log at the top of pullDailySync — does it fire on restart?
  Does it receive a non-empty userId?

ROOT CAUSE D — SyncService.init() fails silently on restart:
  SyncService.init() calls _processQueue() immediately and registers the
  connectivity listener. If the auth token is missing/expired, _processQueue
  will fail silently (catch block just prints to debug console).
  CHECK: Are there sync queue items still pending (is_processed = false) after restart?

ROOT CAUSE E — Auth session not persisted between restarts:
  authProvider reads JWT token and userId from FlutterSecureStorage on init.
  If either key is missing, the auth state is not restored and the app shows the
  login screen — but _AppGate's loading state might pass through too quickly,
  briefly showing an authenticated-but-empty state before redirecting.
  CHECK: Does the app show a login screen flash before showing empty Home?

REQUIREMENTS — FIX ALL FIVE LAYERS:

1. GUARANTEED userId PERSISTENCE:
   - On login (register OR login endpoint success): persist BOTH jwt_token AND
     user_id to FlutterSecureStorage
   - On authProvider init (app startup): restore BOTH from storage
   - Add an assertion/log: debugPrint('[Auth] Restored userId: $userId')
   - If userId is null after storage restore → force logout and redirect to auth

2. STARTUP DIAGNOSTIC (temporary, remove before release):
   - Add AppDatabase.debugPrintAllData(String userId) method:
       Future<void> debugPrintAllData(String userId) async {
         final allHabits = await (select(habits)).get();
         debugPrint('[Debug] All habits in DB: ${allHabits.length}');
         for (final h in allHabits) {
           debugPrint('  habitId=${h.habitId} userId=${h.userId} '
               'title=${h.title} status=${h.status} '
               'currentDuration=${h.currentDuration} isSynced=${h.isSynced}');
         }
         final user = await getUser(userId);
         debugPrint('[Debug] Current user: ${user?.userId} '
             'score=${user?.totalScore}');
         final pending = await getPendingSyncItems();
         debugPrint('[Debug] Pending sync queue items: ${pending.length}');
       }
   - Call this in _AppGate immediately after userId is confirmed, before rendering

3. PULL DAILY SYNC ON STARTUP (guaranteed, not fire-and-forget):
   - In _AppGate, after auth is confirmed and userId is non-null:
       await ref.read(syncServiceProvider).pullDailySync(userId);
       ref.invalidate(activeHabitsProvider(userId));
       ref.invalidate(currentUserProvider);
   - This ensures habits from the server populate Drift before HomeScreen renders
   - Show a brief loading indicator (CircularProgressIndicator) during this pull
   - Only show MainNavigationShell AFTER pullDailySync completes

4. FLUSH SYNC ON APP BACKGROUND:
   - Add WidgetsBindingObserver to HableApp (main.dart)
   - Override didChangeAppLifecycleState:
       if (state == AppLifecycleState.paused ||
           state == AppLifecycleState.detached) {
         ref.read(syncServiceProvider).flushPending();
       }
   - This guarantees pending habit creations and logs are sent before the OS
     kills the app, so data exists on the server for the next startup sync

5. FIX ACTIVE HABITS QUERY TO NEVER RETURN EMPTY FOR WRONG REASON:
   - In AppDatabase, add a diagnostic query:
       Future<int> countAllHabitsForUser(String userId) =>
         (selectOnly(habits)
           ..addColumns([habits.habitId.count()])
           ..where(habits.userId.equals(userId)))
           .map((row) => row.read(habits.habitId.count()) ?? 0)
           .getSingleOrNull()
           .then((v) => v ?? 0);
   - In HomeScreen, if activeHabitsProvider returns empty, call this to check
     if habits exist with other statuses (completed/abandoned)
   - If count > 0 but active == 0: show message "All habits completed!" instead
     of the generic empty state which implies no habits were ever created

DELIVERABLES:

Step 1 — Auth persistence (lib/providers/auth_provider.dart):
  - Locate where login success is handled
  - After successful login/register response, add:
      await _storage.write(key: 'user_id', value: userId);
      await _storage.write(key: 'jwt_token', value: token);
  - In authProvider init, read both back:
      final userId = await _storage.read(key: 'user_id');
      final token = await _storage.read(key: 'jwt_token');
      if (userId != null && token != null) {
        state = AuthState(userId: userId, isAuthenticated: true, ...);
      }

Step 2 — Startup sync in _AppGate (lib/main.dart):
  - Modify _AppGate.build to wait for an explicit startup sync:
      if (authState.isAuthenticated && authState.userId != null) {
        // Pull fresh data before showing the shell
        ref.read(syncServiceProvider).pullDailySync(authState.userId!);
        return MainNavigationShell(userId: authState.userId!);
      }
  - Add a startupSyncCompleteProvider (FutureProvider) that calls pullDailySync
    once and resolves when done — show loading until it resolves

Step 3 — Lifecycle flush (lib/main.dart HableApp):
  - Add `with WidgetsBindingObserver` to HableApp state
  - Register: WidgetsBinding.instance.addObserver(this)
  - Implement: didChangeAppLifecycleState
  - On paused: ref.read(syncServiceProvider).flushPending()

Step 4 — Debug logging (temporary):
  - Add debugPrintAllData call in _AppGate after userId confirmed
  - Run the app, reproduce the empty-screen bug
  - Share the debug log — it will confirm which root cause is active

Step 5 — Fix empty state to distinguish "no habits" vs "all completed":
  - Update HomeScreen empty state to check countAllHabitsForUser
  - If count > 0: show "All habits completed! Add a new one."
  - If count == 0: show existing "No active habits yet. Start one from Home."

TEST PLAN:
  1. Login as test user, add 2 habits, complete one
  2. Confirm Home shows both habits, points appear on Profile
  3. Note the userId from debug logs
  4. Force-close the app (not just background — kill from recent apps)
  5. Reopen the app
  6. Confirm: same userId is restored (check debug log)
  7. Confirm: both habits appear on Home within 3 seconds of opening
  8. Confirm: points appear on Profile
  9. Confirm: sync queue is empty (all items sent)
  10. Turn off wifi, close app, reopen → habits must appear from Drift cache
      even without network (offline-first guarantee)

AVOID:
  - Querying Drift with null userId (always guard with if userId == null return early)
  - Assuming the sync queue will drain itself without being explicitly flushed
  - Showing the home screen before pullDailySync completes on first load
  - Silent error swallowing in SyncService (upgrade debugPrint to error logging
    for startup-critical paths)
  - Treating "no active habits" and "habits exist but are completed" the same way
