<!-- AI AGENT OPERATING CONTRACT — See Task_ai_agent_contract.md for full rules. This file is the raw intake queue. -->

## Raw Tasks Intake

- [x] Transferred 2026-07-08 -> **Add Cloudflare Worker Backend For Social Sync & Ephemeral Nudges** (`Task2_Archived.md#add-cloudflare-worker-backend-for-social-sync-ephemeral-nudges`). Raw source: Build the Cloudflare Worker Backend (D1 & KV): Implement the Cloudflare API for the Partnership Junction and the Ephemeral Nudge System, replacing the current stubs in `lib/services/sync_service.dart`. (From `04_Social_and_Analytics.md`)
- [x] Transferred 2026-07-08 -> **Add Offline Inverted Index Search Engine For Local Documents** (`Task2_Archived.md#add-offline-inverted-index-search-engine-for-local-documents`). Raw source: Implement the Multithreaded Inverted Index Engine: Build the search and retrieval system with the relational schema (Document metadata), Inverted Index mapping (Hash Tables & Merge Sort), and producer-consumer thread synchronization. (From `05_Search_Engine_Architecture.md`)
- [x] Transferred 2026-07-08 -> **Add JWT Authentication And Friend-Request Authorization For Sync APIs** (`Task2_Archived.md#add-jwt-authentication-and-friend-request-authorization-for-sync-apis`). Raw source: Implement secure user authentication for sync APIs (e.g., JWTs and friend-request acceptance flows).

- [x] Transferred 2026-07-08 -> **Wire Mutual Habit Friends Into Home UI And Habit-Colored Rings** (`Task2_Archived.md#wire-mutual-habit-friends-into-home-ui-and-habit-colored-rings`). Raw source: continue development; multi-user, mutual habit tracking, nudges, friends. (from 06_MULTI_USER.md). make the ring more similar to app_icon's ring. Assign different color for different Habit.

- [x] Transferred 2026-07-08 -> **Add Twin-App Friend Flow Test Harness** (`Task2_Archived.md#add-twin-app-friend-flow-test-harness`). Raw source: Install a twin of the hable to act as a friends app. test mutual habit tracking, nudginng, send and receive friend requests. Follow-up note: by tweaking APK package name maybe.

- [x] Transferred 2026-07-08 -> **3D Multi-User Social Features Ideation** (`07_Multi_User_Social_Features.md`). Raw source: work on ideation of tracking multi habbits, and seeing your friends habits as well, in a 3D abstract environment, get inspired by the way they spend their time, and plan yours based on that. and make it look cool and engaging. make possible to send your best wishes for your friends, on a special day, and based on their habits, it will suggest what to wish them, or just let them choose, and send it to them. it should be private and only them can see it. (on midway suggest related message, at the near end another option, like linkedin having a set of constant wishes for birthdays, make it same; different situation different kind of wishes (with emojis)). adding new habbits, inviting friends to partner for a habit, if they accept, they become your partner for that habit. create its doc in `Developement/07_Multi_User_Social_Features.md`.

- [x] Transferred 2026-07-08 -> **Add Profile-Based Habit CRUD UI** (`Task1_Engineered.md#phase-5-profile-based-habit-crud-ui`). Raw source: ui for habit CRUD has been missed.

- [x] Transferred 2026-07-08 -> **Complete Account, Friend Search, Habit Recording Sync, And Leaderboard MVP** (`Task2_Archived.md#complete-account-friend-search-habit-recording-sync-and-leaderboard-mvp`). Raw source: Work on user authentication, registration, searching, recording, leaderboard scores, and other related matters.

- [x] Transferred 2026-07-09 -> **Run ADB Smoke Tests For Auth, Friend Harness, And Recent UI Changes** (`Task1_Engineered.md#run-adb-smoke-tests-for-auth-friend-harness-and-recent-ui-changes`). Raw source: test recent changes via adb, do it twice. once without logging in, once with logging in. via the friend test harness. via the normal app. document the procedure in `Developement/08_Testing.md`. ensure it is run by you, and you see everything you should, and nothing you shouldn't. test every button and feature you added. and check if the .gitignore is updated.

- [x] Transferred 2026-07-09 -> **Audit And Align Hable Development Docs With Current Code** (`Task1_Engineered.md#audit-and-align-hable-development-docs-with-current-code`). Raw source: Update docs.

- [x] Transferred 2026-07-09 -> **Complete Cross-App Habit Lifecycle Sync And Twin-Harness Verification** (`Task1_Engineered.md#complete-cross-app-habit-lifecycle-sync-and-twin-harness-verification`). Raw source: Add a habit, set a time, sync it, update it, delete it. see it in your friends app (if you added them as friend), update it in your friends app, see it in your app. do the same for multi-day habits. after adding them in your app, add them in your friends app, see them in your app. test everything. Update docs.
- [x] Transferred 2026-07-09 -> **Wire Friend Requests Through Social Hub And Twin-Harness Verification** (`Task1_Engineered.md#wire-friend-requests-through-social-hub-and-twin-harness-verification`). Raw source: add a social feature, e.g., friend request. implement it via search and button (e.g., in settings or new people tab). after adding them in your app, add them in your friends app, see them in your app. test everything. Update docs.

- [x] Transferred 2026-07-09 -> **Reuse Onboarding Habit Presets In Habit Creation With Partner Invites And Clear Progress Labels** (`Task2_Archived.md#reuse-onboarding-habit-presets-in-habit-creation-with-partner-invites-and-clear-progress-labels`). Raw source: a list of habits we have at onboarding should be available on home page as well, so that we can add them to our list of habits in our profile. during creation user should able to radd partners (requesst will be send to partner to accept or deny). rewise the logic behind having the days inside the ring and having a streak (fire) trend next to the ring, seems duplicate info.

- [x] Transferred 2026-07-09 -> **Promote Habit Creation To Home Without Turning Home Into Profile** (`Task2_Archived.md#promote-habit-creation-to-home-without-turning-home-into-profile`). Raw source: the app is uncomplete; no adding functionality at home for creating habit and you need to go to profile which is not right, rewise and fix. The UI design and UX. Best-practices explicitly included.

- [x] Transferred 2026-07-09 -> **Deploy Flutter Web To Cloudflare Pages With Production Smoke Tests** (`Task2_Archived.md#deploy-flutter-web-to-cloudflare-pages-with-production-smoke-tests`). Raw source: deploy the flutter app on cloudflare pages at hable.pages.dev and test it thoroughly. create a flutter build for web and test it out. after now system for testing backend could be able to use online build which will be easier to debug and track.

- [x] Transferred 2026-07-11 -> **Repair SignUp SignIn And Forgot Password Network Failures** (`Task1_Engineered.md#repair-signup-signin-and-forgot-password-network-failures`). Raw source: Continue developement of SignUp, SignIn, and Forgot Password process. You can look and inspire from email authentitcation from VibeCoding/campusweb (the sign in and sign up just says 'Network error'). Previous transfer note referenced **Implement Email Authentication And PIN Reset Flow**, but no matching engineered task anchor currently exists in `Task1_Engineered.md`.

- [x] Transferred 2026-07-09 -> **Build Social Friends List UI and Fix Partner Selection** (`Task2_Archived.md#build-social-friends-list-ui-and-fix-partner-selection`). Raw source: report: Friend requests receives, get accepted, but not show up in the friends list (or partner list during creating new habit). no friend list exist on UI for now, so impossible to check. (I am using WEB App for testing).

- [x] Transferred 2026-07-11 -> **Show Accepted Partner Habits On Recipient Home After Invite Acceptance** (`Task1_Engineered.md#show-accepted-partner-habits-on-recipient-home-after-invite-acceptance`). Raw source: UX Major Matter: the habit partner up should get first accepted from partners, and then it should show up at the homepage of partners. currenlty it gets accepted, but not show up in the partner's homepage, just in creator's homepage.

- [x] Transferred 2026-07-09 -> **Support Emoji Or Uploaded Profile Pictures** (`Task1_Engineered.md#support-emoji-or-uploaded-profile-pictures`). Raw source: make possible to set Profile Picture; user should choose either a funny emoji avatar or upload an image profile picture. Uploaded profile pictures must be optimized server-side for web/profile display, stored, and used across the app.

- [x] Transferred 2026-07-11 -> **Add Friend Profile Drilldown And Habit-Scoped Nudge Actions** (`Task1_Engineered.md#add-friend-profile-drilldown-and-habit-scoped-nudge-actions`). Raw source: work on seeing friends profile by tapping on their name at homepage, and the nudging is exclusively for partners on the partnered habits cards (inside the card). Follow-up detail: you can see friends profile, and their active habbits, and able to follow their habits and nudge them without being partner in that habbit.

- [x] Transferred 2026-07-09 -> **Verify Web-Era Changes On Android APKs** (`Task2_Archived.md#verify-web-era-changes-on-android-apks`). Raw source: make sure new web changes is availble on android too. install new apk and test it.

- [x] Transferred 2026-07-09 -> **Apply Flutter Podium Leaderboard Card Design** (`Task2_Archived.md#apply-flutter-podium-leaderboard-card-design`). Raw source adapted from the supplied React/shadcn `leaderboard-card` prompt for the Flutter/Riverpod Social Hub leaderboard. Original reference prompt: [``` You are given a task to integrate an existing React component in the codebase

    The codebase should support:
    - shadcn project structure  
    - Tailwind CSS
    - Typescript

    If it doesn't, provide instructions on how to setup project via shadcn CLI, install Tailwind or Typescript.

    Determine the default path for components and styles. 
    If default path for components is not /components/ui, provide instructions on why it's important to create this folder
    Copy-paste this component to /components/ui folder:
    ```tsx
    leaderboard-card.tsx
    "use client"

    import * as React from "react"

    import { cn } from "@/lib/utils"
    import {
    LeaderboardPodium,
    type LeaderboardRanking as LeaderboardPodiumRanking,
    } from "@/components/ui/leaderboard-podium"
    import {
    LeaderboardRankings,
    type LeaderboardRankingItem,
    } from "@/components/ui/leaderboard-rankings"

    interface LeaderboardRunOption {
    id: string
    label: string
    }

    interface LeaderboardCardProps extends React.HTMLAttributes<HTMLDivElement> {
    title?: string
    fromDate: string | Date
    toDate: string | Date
    podiumRankings: LeaderboardPodiumRanking[]
    rankings: LeaderboardRankingItem[]
    currentUserId?: string
    runOptions?: LeaderboardRunOption[]
    selectedRunId?: string
    onRunChange?: (runId: string) => void
    }

    function formatRangeDate(date: string | Date) {
    const parsed = date instanceof Date ? date : new Date(date)
    if (Number.isNaN(parsed.getTime())) return ""

    return parsed.toLocaleDateString(undefined, {
        month: "short",
        day: "numeric",
        year: "numeric",
    })
    }

    const LeaderboardCard = React.forwardRef<HTMLDivElement, LeaderboardCardProps>(
    (
        {
        className,
        title = "Leaderboard",
        fromDate,
        toDate,
        podiumRankings,
        rankings,
        currentUserId,
        runOptions,
        selectedRunId,
        onRunChange,
        ...props
        },
        ref
    ) => {
        const fromLabel = formatRangeDate(fromDate)
        const toLabel = formatRangeDate(toDate)
        const resolvedRunId = selectedRunId ?? runOptions?.[0]?.id ?? ""
        const hasOnRunChange = Boolean(onRunChange)
        const [localRunId, setLocalRunId] = React.useState(resolvedRunId)

        React.useEffect(() => {
        if (hasOnRunChange) return
        setLocalRunId(resolvedRunId)
        }, [hasOnRunChange, resolvedRunId])

        const activeRunId = hasOnRunChange ? resolvedRunId : localRunId

        return (
        <div
            ref={ref}
            className={cn("bg-card rounded-2xl border p-6 shadow-sm", className)}
            {...props}
        >
            <div className="mb-6 flex items-start justify-between gap-4">
            <div className="space-y-1">
                <h3 className="text-xl font-semibold">{title}</h3>
                <p className="text-muted-foreground text-sm">
                {fromLabel} - {toLabel}
                </p>
            </div>

            {runOptions && runOptions.length > 0 ? (
                <select
                aria-label="Select leaderboard run"
                value={activeRunId}
                onChange={(e) => {
                    if (onRunChange) {
                    onRunChange(e.target.value)
                    return
                    }
                    setLocalRunId(e.target.value)
                }}
                className="bg-background text-foreground rounded-md border px-3 py-1.5 text-sm"
                >
                {runOptions.map((option) => (
                    <option key={option.id} value={option.id}>
                    {option.label}
                    </option>
                ))}
                </select>
            ) : null}
            </div>

            <LeaderboardPodium rankings={podiumRankings} className="mb-6" />

            <LeaderboardRankings
            rankings={rankings}
            currentUserId={currentUserId}
            showPagination
            defaultPageSize={10}
            />
        </div>
        )
    }
    )

    LeaderboardCard.displayName = "LeaderboardCard"

    export { LeaderboardCard }
    export type { LeaderboardCardProps, LeaderboardRunOption }


    demo.tsx
    import { LeaderboardCard } from "@/components/ui/leaderboard-card"

    export default function DemoOne() {
    return (
        <LeaderboardCard
        title="Weekly Leaderboard"
        fromDate="2026-05-01"
        toDate="2026-05-07"
        currentUserId="u-5"
        podiumRankings={[
            { userId: "u-1", userName: "Ava Elizabeth Turner", rank: 1, value: 289400 },
            { userId: "u-2", userName: "Leo Harrison", rank: 2, value: 251800 },
            { userId: "u-3", userName: "Rowan Elijah", rank: 3, value: 238300 },
        ]}
        rankings={[
            { userId: "u-1", rank: 1, userName: "Ava Elizabeth Turner", byline: "Level 42 – Diamond", value: 289400, displayed: true },
            { userId: "u-2", rank: 2, userName: "Leo Harrison", byline: "Level 39 – Platinum", value: 251800, displayed: true },
            { userId: "u-3", rank: 3, userName: "Rowan Elijah", byline: "Level 35 – Gold", value: 238300, displayed: true },
            { userId: "u-4", rank: 4, userName: "Maya Chen", byline: "Level 31 – Silver", value: 198700, displayed: true },
            { userId: "u-5", rank: 5, userName: "You", byline: "Level 28 – Bronze", value: 156200, displayed: true },
        ]}
        />
    )
    }
    ```

    Implementation Guidelines
    1. Analyze the component structure and identify all required dependencies
    2. Review the component's argumens and state
    3. Identify any required context providers or hooks and install them
    4. Questions to Ask
    - What data/props will be passed to this component?
    - Are there any specific state management requirements?
    - Are there any required assets (images, icons, etc.)?
    - What is the expected responsive behavior?
    - What is the best place to use this component in the app?

    Steps to integrate
    0. Copy paste all the code above in the correct directories
    1. Install external dependencies
    2. Fill image assets with Unsplash stock images you know exist
    3. Use lucide-react icons for svgs or logos if component requires them
    ```]

- [x] Transferred 2026-07-09 -> **Verify Normal Android Account Creation Login And Logout Flow** (`Task1_Engineered.md#verify-normal-android-account-creation-login-and-logout-flow`). Raw source: work creating, logging in , logging out on android ADB

- [x] Transferred 2026-07-09 -> **Build Notification Center And Local Reminder MVP** (`Task1_Engineered.md#build-notification-center-and-local-reminder-mvp`). Raw source: work on notification system for reminding tasks, getting friends interactions (requests acceptance/denial, nudges, etc), sync between devices, cross platform (android and web/ios), etc.

- [x] Transferred 2026-07-11 -> **Add Partnership Roles And Enforce Habit Permissions In Backend** (`Task1_Engineered.md#add-partnership-roles-and-enforce-habit-permissions-in-backend`). Raw source: 1. Database Roles & Relationships (High Priority Blocker)
* **Objective:** Expand the D1 `partnerships` table to support Role-Based Access Control (RBAC) via a `role` enum to prevent client-side state conflicts.
* **Owner:** Can edit/delete the habit, complete/skip, and nudge participants.
* **Partner:** Can complete/skip, view details, and nudge others. Cannot edit/delete the habit.
* **Supporter:** Read-only view of progress, can send encouragement/nudges. by pressing and holding the habit ring and completing it (with same difficulty as owner/partner). Cannot complete/skip or edit. 
* **Relationship Types:** Sole creator, mutual friendships (send/accept), and multi-partner habits.
* **Action:** Engineer a D1 schema migration and update the Cloudflare Worker to enforce these permissions before updating the Flutter UI.

- [x] Transferred 2026-07-11 -> **Add Server-Side Gamification Progression To Daily Sync** (`Task1_Engineered.md#add-server-side-gamification-progression-to-daily-sync`). Raw source: 2. Gamification: Achievements, Badges & Points. Objective: Implement a server-side progression system returned via the `/api/sync/daily` payload to keep the Flutter client lightweight and prevent spoofing. Points System: Award 5 points per check-in. Award bonus points when all partners in a shared habit check in. Levels: Map total points to named tiers (e.g., "Newbie") to replace raw numbers on the user profile. Badges: Track milestones (first check-in, 10/100/1000 streaks, first nudge, first supporter) entirely on the backend. Action: Update the Cloudflare Worker to calculate and append unlocked achievements to the user payload during the `SyncQueue` flush.

- [x] Transferred 2026-07-11 -> **Polish Habit Cards And Profile With Role-Aware Progression Data** (`Task1_Engineered.md#polish-habit-cards-and-profile-with-role-aware-progression-data`). Raw source: 3. Habit Card & Profile UI Polish. Objective: Update the client UI to reflect the new roles and gamification data (Strictly blocked by Item 1). User Card: Compact the profile view to show the profile picture, name, username, and the dynamic Level Name. Habit Card Data: Display habit title, icon, current streak, target days, and a horizontal progress line along the bottom border. Social Ring: Show the habit icon inside a color-coded ring. Fill the ring upon completion; leave it empty for active/skipped states. Partner Visibility: Display a maximum of 4 partner/supporter avatars per card, adding a status ring around their profile pictures to indicate daily completion.

- [x] Transferred 2026-07-11 -> **Add Revocable iCal Feed For Native Calendar Subscriptions** (`Task1_Engineered.md#add-revocable-ical-feed-for-native-calendar-subscriptions`). Raw source: 4. Edge-Native Calendar Integration (iCal). Objective: Allow users to view daily habits in their native phone calendar without adding heavy, permission-bloated Flutter calendar dependencies. Architecture: Create a Cloudflare Worker route that generates a dynamic, read-only `.ics` (iCalendar) feed subscription link per user. Event Title: Generate dynamic motivational messages based on progress. Group multiple daily habits into a single summary event to prevent calendar app clutter. Event Description: Keep descriptions highly concise. Include partner names and the current target fraction (e.g., 3/5 days).

- [x] Transferred 2026-07-11 -> **Add Code-Native Mermaid Architecture Diagrams For Schema And Sync Flow** (`Task1_Engineered.md#add-code-native-mermaid-architecture-diagrams-for-schema-and-sync-flow`). Raw source: 5. System Architecture Documentation. Objective: Replace manual, text-heavy documentation tasks with maintainable, code-native diagrams. Database Schema: Generate a `Mermaid.js` Entity-Relationship (ER) diagram mapping D1 tables, columns, and relationships. System Flow: Create a `Mermaid.js` sequence diagram illustrating the offline-first sync architecture, showing interactions between Flutter, Riverpod, Drift, and Cloudflare Workers.

- [x] prepare the android build, and run on virtual device.
  - **Completion notes:** Android build completed successfully. Both app variants (primary and friend) compiled and installed on Android emulator (emulator-5554 running Android 17 API 37).
  - Primary APK: `/Users/h.ettefagh/Documents/VibeCoding/Flutter/hable/build/app/outputs/flutter-apk/app-primary-debug.apk`
  - Friend APK: `/Users/h.ettefagh/Documents/VibeCoding/Flutter/hable/build/app/outputs/flutter-apk/app-friend-debug.apk`
  - Both apps are installed and running on the virtual device.
  - Completed At: 2026-07-11 (Current session)

- [x] Transferred 2026-07-11 -> **Keep Partner Shared Habits Visible After Check-In And Surface Nudges** (`Task1_Engineered.md#keep-partner-shared-habits-visible-after-check-in-and-surface-nudges`). Raw source: HABIT PARTNERING bug report:
    - for partner, not creator, habit card shws up, but it gets deleted once the user checkes in (completes the ring), hoof, gone.
    - nudge is not implemented yet:
        - just the announcement of the nudge has been sent appears at the very bottom of the home screen for a second, which is not enough. also, it should be more visible and obvious.
        - (the nudged person) is not aware of the nudge at all, in app or when it's closed.
        - when user is nudged, the card does not change state (the ring should animate in a special way)
        - research about how nudging/poking/reminding works and what is the best way to implement it (not spamming, but effective, psychological and fun).
- [x] Transferred 2026-07-11 -> **Refine Habit Card Ring Icon Partner Rings And Responsive State Model** (`Task1_Engineered.md#refine-habit-card-ring-icon-partner-rings-and-responsive-state-model`). Raw source: Card UI:
        put the habit dedicated icon inside the ring, make the icon in the main ring bigger , but faded. very smooth along with the ring completion make it smaller but completeley visible (like this is something transparent recognizable, which established and stables by pressing down and holding the ring; exactly like a task during creation, a habit in a real life, which is a tough, which is a wheel, but not exist yet slowly wait difficulty of doing a real life task, which has been implemented into during completion mathematically, it's slowly established and appears after doing it in the real life, in a way that it is smooth, and not abruptly appears.) Encoding make these parameters, which used by during, the difficulty and level and a step of establishment of a habit reusable, in a way to New Zealand in the future indifference elements maybe instead of a progress or as a border, creating a dynamic background for the card. 
        - make the partner profile picture bigger, make its ring thickness momore like the main habit ring, and make it more visible. rings are the main element on the UI, make them pop! 
        - the habit cards arrangement should be responsible to the screen size, number of habits, and should not overflow. now there is no gap between last card and the very bottom.
        - in order of reducing ui elements, integrate the subtitle of habit name 'challenge day of X of Y' into the progress bar. bringing the habit name from top left to bottom over progress bar, make the ring and the partners the main focused ui elements. 
        - create habit states update (check-in, skip, missed, nudge) not developing a UI for it, just on code level
            - the first developed UI would be a should connect with the completion of the task the check-in, which now has a animation transition for the habit icon, and a very short appearance of the done UI, with his smooth transition to the established habit. In the next phases of developing the happiness state updates we would have a splash screen with different elements, just now focus on implementing the fundamental and the foundation of this approach.

- [x] Transferred 2026-07-11 -> **Add Privacy-Preserving Anonymous Usage Aggregates For Development Diagnostics** (`Task1_Engineered.md#add-privacy-preserving-anonymous-usage-aggregates-for-development-diagnostics`). Raw source: implement anonymous usage tracking for development and debugging purposes. Track how frequently users open the app, which screens they visit, and how long they spend on each screen. This data should be anonymized and should not include any personal information. no fingerprinting, no traceable ids; acknowledge-free, don't pass the limits which needs GDPR, but instead, implement it in a way that is GDPR-compliant.
    - haing an admin panel for it on the web. 
    - for ui use (npx @21st-dev/cli add larsen66/efferd-dashboard-2)
