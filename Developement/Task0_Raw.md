<!-- AI AGENT OPERATING CONTRACT — See Task_ai_agent_contract.md for full rules. This file is the raw intake queue. -->

## Raw Tasks Intake

- [x] Transferred 2026-07-08 -> **Add Cloudflare Worker Backend For Social Sync & Ephemeral Nudges** (`Task1_Engineered.md#L9`). Raw source: Build the Cloudflare Worker Backend (D1 & KV): Implement the Cloudflare API for the Partnership Junction and the Ephemeral Nudge System, replacing the current stubs in `lib/services/sync_service.dart`. (From `04_Social_and_Analytics.md`)
- [x] Transferred 2026-07-08 -> **Add Offline Inverted Index Search Engine For Local Documents** (`Task1_Engineered.md#L53`). Raw source: Implement the Multithreaded Inverted Index Engine: Build the search and retrieval system with the relational schema (Document metadata), Inverted Index mapping (Hash Tables & Merge Sort), and producer-consumer thread synchronization. (From `05_Search_Engine_Architecture.md`)
- [x] Transferred 2026-07-08 -> **Add JWT Authentication And Friend-Request Authorization For Sync APIs** (`Task1_Engineered.md#L100`). Raw source: Implement secure user authentication for sync APIs (e.g., JWTs and friend-request acceptance flows).

- [x] Transferred 2026-07-08 -> **Wire Mutual Habit Friends Into Home UI And Habit-Colored Rings** (`Task1_Engineered.md#L149`). Raw source: continue development; multi-user, mutual habit tracking, nudges, friends. (from 06_MULTI_USER.md). make the ring more similar to app_icon's ring. Assign different color for different Habit.

- [x] Transferred 2026-07-08 -> **Add Twin-App Friend Flow Test Harness** (`Task1_Engineered.md#L203`). Raw source: Install a twin of the hable to act as a friends app. test mutual habit tracking, nudginng, send and receive friend requests. Follow-up note: by tweaking APK package name maybe.

- [x] Transferred 2026-07-08 -> **3D Multi-User Social Features Ideation** (`07_Multi_User_Social_Features.md`). Raw source: work on ideation of tracking multi habbits, and seeing your friends habits as well, in a 3D abstract environment, get inspired by the way they spend their time, and plan yours based on that. and make it look cool and engaging. make possible to send your best wishes for your friends, on a special day, and based on their habits, it will suggest what to wish them, or just let them choose, and send it to them. it should be private and only them can see it. (on midway suggest related message, at the near end another option, like linkedin having a set of constant wishes for birthdays, make it same; different situation different kind of wishes (with emojis)). adding new habbits, inviting friends to partner for a habit, if they accept, they become your partner for that habit. create its doc in `Developement/07_Multi_User_Social_Features.md`.

- [x] Transferred 2026-07-08 -> **Add Profile-Based Habit CRUD UI** (`Task1_Engineered.md#L253`). Raw source: ui for habit CRUD has been missed.

- [x] Transferred 2026-07-08 -> **Complete Account, Friend Search, Habit Recording Sync, And Leaderboard MVP** (`Task1_Engineered.md#L297`). Raw source: Work on user authentication, registration, searching, recording, leaderboard scores, and other related matters.

- [x] Transferred 2026-07-09 -> **Run ADB Smoke Tests For Auth, Friend Harness, And Recent UI Changes** (`Task1_Engineered.md#L392`). Raw source: test recent changes via adb, do it twice. once without logging in, once with logging in. via the friend test harness. via the normal app. document the procedure in `Developement/08_Testing.md`. ensure it is run by you, and you see everything you should, and nothing you shouldn't. test every button and feature you added. and check if the .gitignore is updated.

- [x] Transferred 2026-07-09 -> **Audit And Align Hable Development Docs With Current Code** (`Task1_Engineered.md#L437`). Raw source: Update docs.

- [x] Transferred 2026-07-09 -> **Complete Cross-App Habit Lifecycle Sync And Twin-Harness Verification** (`Task1_Engineered.md#L485`). Raw source: Add a habit, set a time, sync it, update it, delete it. see it in your friends app (if you added them as friend), update it in your friends app, see it in your app. do the same for multi-day habits. after adding them in your app, add them in your friends app, see them in your app. test everything. Update docs.
- [x] Transferred 2026-07-09 -> **Wire Friend Requests Through Social Hub And Twin-Harness Verification** (`Task1_Engineered.md#L533`). Raw source: add a social feature, e.g., friend request. implement it via search and button (e.g., in settings or new people tab). after adding them in your app, add them in your friends app, see them in your app. test everything. Update docs.

- [x] Transferred 2026-07-09 -> **Reuse Onboarding Habit Presets In Habit Creation With Partner Invites And Clear Progress Labels** (`Task1_Engineered.md#L607`). Raw source: a list of habits we have at onboarding should be available on home page as well, so that we can add them to our list of habits in our profile. during creation user should able to radd partners (requesst will be send to partner to accept or deny). rewise the logic behind having the days inside the ring and having a streak (fire) trend next to the ring, seems duplicate info.

- [x] Transferred 2026-07-09 -> **Promote Habit Creation To Home Without Turning Home Into Profile** (`Task1_Engineered.md#L666`). Raw source: the app is uncomplete; no adding functionality at home for creating habit and you need to go to profile which is not right, rewise and fix. The UI design and UX. Best-practices explicitly included.

- [x] Transferred 2026-07-09 -> **Deploy Flutter Web To Cloudflare Pages With Production Smoke Tests** (`Task1_Engineered.md#L724`). Raw source: deploy the flutter app on cloudflare pages at hable.pages.dev and test it thoroughly. create a flutter build for web and test it out. after now system for testing backend could be able to use online build which will be easier to debug and track.

- [x] Transferred 2026-07-09 -> **Implement Email Authentication And PIN Reset Flow** (`Task1_Engineered.md`). Raw source: Continue developement of SignUp, SignIn, and Forgot Password process. You can look and inspire from email authentitcation from VibeCoding/campusweb (the sign in and sign up just says 'Network error')

- [x] Transferred 2026-07-09 -> **Build Social Friends List UI and Fix Partner Selection** (`Task1_Engineered.md#L779`). Raw source: report: Friend requests receives, get accepted, but not show up in the friends list (or partner list during creating new habit). no friend list exist on UI for now, so impossible to check. (I am using WEB App for testing).

- [x] UX Major Matter: the habit partner up should get first accepted from partners, and then it should show up at the homepage of partners. currenlty it gets accepted, but not show up in the partner's homepage, just in creator's homepage.

- [x] Transferred 2026-07-09 -> **Support Emoji Or Uploaded Profile Pictures** (`Task1_Engineered.md#L813`). Raw source: make possible to set Profile Picture; user should choose either a funny emoji avatar or upload an image profile picture. Uploaded profile pictures must be optimized server-side for web/profile display, stored, and used across the app.

- [x] work on seeing friends profile by tapping on their name at homepage, and the nudging is exclusively for partners on the partnered habits cards (inside the card). 
    - you can see friends profile, and their active habbits, and able to follow their habits and nudge them without being partner in that habbit.

- [x] Transferred 2026-07-09 -> **Verify Web-Era Changes On Android APKs** (`Task1_Engineered.md#L858`). Raw source: make sure new web changes is availble on android too. install new apk and test it.

- [ ] adapt and apply this design on leaderboard: [``` You are given a task to integrate an existing React component in the codebase

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
