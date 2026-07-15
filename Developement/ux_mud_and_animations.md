# 03: UI/UX & Animation Specifications (Native Flutter)

This document provides the complete technical specification and native Flutter code implementation for the dynamic "mud-resistance" long-press completion interaction.

## 1. Visual Philosophy ("Chill & Minimal")
* **Colors:** Muted tones (pastels, sage greens, warm grays). Reserve vibrant/neon colors strictly for the exact moment of a habit completion.
* **Typography:** Clean, rounded sans-serif. Generous line height and negative space.
* **Layout:** Protect the user from "dashboard fatigue." The Home Screen focuses ONLY on today's action. All historical data and charts belong exclusively on the Profile Screen. Ensure mobile viewports are dynamic and stable.
* **Primary Navigation:** Authenticated Hable uses a focused three-tab shell: Home, Social, and Profile. Do not add Settings as a fourth tab; Profile owns the gear entry to nested Settings.
* **Habit Creation:** The shared `HabitFormSheet` is the single post-onboarding creation/edit surface. Home exposes a persistent FAB and an empty-state Add habit button; Profile remains the management/editing surface. The sheet should read quickly: keep helper copy sparse, offer quick-select chips from `standard_habits.dart`, use anchored finite-duration selection with a bounded slider (default `21`, anchors `21/33/40`, minimum `1`), keep color selection visible, and expose the accepted-friend partner picker only for new habits. Unlimited/lifetime durations remain out of scope until scoring, mud progression, and calendar load rules are engineered separately.
* **Home Suggestions:** Suggested preset cards are quick-start shortcuts for the empty Home state only. Once active habits exist, Home should prioritize today's habit cards and keep the add action compact.
* **Home Progress Labels:** Home habit cards should distinguish the calendar-based challenge timeline (`Day X of N` for today in the challenge) from earned completion progress and from consecutive-completion streaks. Avoid duplicating day count and fire-streak language around the ring, and do not let same-day check-ins increment the visible timeline label.
* **Notification Entry:** Home exposes a compact bell icon with a local unread badge. Tapping the bell switches to the Social tab's Activity section (unified notification feed), not a separate pushed screen. The badge watches `unreadNotificationCountProvider`.
* **Skip Privacy:** The skip journal is a private local reflection surface. The UI may require the text before applying the skip penalty, but that free-form note must not be sent in shared-habit sync payloads or partner-facing APIs.
* **Per-Card Social Context:** Habit cards should carry the primary partner/supporter status surface. Show up to four avatars inline, keep role/status visible without opening another screen, and use a simple `+N` overflow indicator for larger groups. Tapping partner identity opens that friend's profile; nudging must be a separate hand action tied to the specific habit card.
* **Social Hub Tabs:** The Social tab uses three internal tabs: **Friends** (accepted friends list with inline pending requests at top and a search icon for find-friends sheet), **Activity** (unified chronological feed of notifications, nudges, friend requests, invites, and messages from `NotificationEvents` Drift table), and **Leaderboard** (friends ranking card). Find Friends is a bottom sheet triggered by the search icon in the Social header, not a standalone tab.
* **Card-Local Nudge Feedback:** A received nudge should be visible on the relevant habit card, not only in a snackbar or notification center. Use a bounded 24-hour treatment such as a habit-colored pulse around the ring plus a compact "Nudged by X" chip from `PartnerSnapshots.lastNudgeAt`. Sending a nudge should also show a short-lived card-local "Nudge queued for X" chip next to the selected habit.
* **Auth & Activation:** Initial signup/login should ask for username and password only. Email/PIN verification belongs in nested Settings as an optional cloud-sync/recovery activation card, so users can start quickly and opt into verified email later.
* **New-User Onboarding Slides:** Logged-out users first see a muted sage/pastel slide sequence before the auth form. The slides introduce the day-one quote, Mud resistance with the 1500ms press concept, first-commit presets/durations, partner rings, gentle reminders, deferred verification, private journals, and the no-skip main-ring model. The final slide hands off to sign-up, while the slide header keeps a direct Log in path for returning users. Seeded test login still bypasses the slide sequence through the auth auto-login skeleton.
* **Profile Progression:** Profile should display server-owned `total_points`, level name, achievement unlocks, charts, calendar, and all-habit management cached from Drift/daily sync. Do not infer badges from completed local habits as the source of truth.
* **Settings Placement:** Durable account/system controls live in nested Settings behind the Profile gear. This includes cloud activation, emoji-only avatar customization, sign out, daily reminders, the current accessibility controls, and language selection. Deeper accessibility expansion can still land as separate follow-up work.
* **Avatar Customization:** The current MVP avatar picker is emoji-only. The UI should show a deterministic failure message if the backend rejects an avatar update; URL uploads and media profile photos remain out of scope until a dedicated storage task exists.
* **Reminder Control Placement:** The smallest reminder MVP lives in Settings as a daily reminder card with explicit enable/disable and time selection. Permission prompts must come only from the user toggling reminders on.
* **Role-Gated Actions:** Supporters can observe and nudge but must not see active completion/skip affordances. Profile habit edit/archive controls should disable gracefully when cached role data says the user is not the owner.
* **Friend Profile Actions:** Friend active-habit rows may offer `Follow` as a local habit-creation prefill and `Encourage` as the existing queue-backed nudge path. They must not create hidden remote follow state or show private journal data.
* **Social Loading States:** Friend search, pending requests, and leaderboard loads should resolve to data, empty, or clear error states with bounded request timeouts. They must not leave a permanent spinner when the route, CORS, or backend process is unavailable.
* **Skeleton & Empty States:** Main surfaces should preserve layout shape while providers resolve. Use lightweight skeleton blocks/cards for Home, Social Hub, Profile chart/friend loads, Notification Center, Auth auto-login, Habit Form partner chips, avatar picker updates, and calendar feed loading. Empty states should use structured cards with icon, title, and concise guidance rather than plain centered text.

### 2. Mandatory Friction (Skipping)
If a user skips a habit, open a glassmorphic bottom sheet requiring a text input (Journal Entry). The UI must visually reflect the penalty (extending the journey map).

### 3. Mud Check-In: Mathematical Resistance Model (Specialized — Do Not Simplify)

> [!IMPORTANT]
> **The Mud mathematical check-in is a specialized, physics-driven interaction unique to Hable.** Its algorithm is NOT subject to normal UI refactoring rules. Do not simplify, extract, or inline the resistance math into the widget `build()` method. The `StateNotifier` isolation boundary is mandatory (see `sys_offline_architecture.md §3 — The Resistance State Isolation`). Haptic intervals and curve control points are intentionally calibrated — do not remove or approximate them.

The gesture's behavioral characteristics depend entirely on the habit timeline progression. The physical resistance behaves according to a tiered model based on total duration ($D$) and current day index ($d$).

The baseline resistance coefficient ($R$) is bounded between $0.0$ and $1.0$ and mapped to tiers:
* **Mastery Band (Final 3 Check-ins or $D \le 3$):** $R = 1.0$ (1500ms) - The hardest resistance, reserved for the end of the journey to signify mastery.
* **Tier 1 (First third of non-mastery days):** $R = 0.8$ (1280ms) - Initial challenge.
* **Tier 2 (Middle third of non-mastery days):** $R = 0.5$ (950ms) - Developing.
* **Tier 3 (Final third of non-mastery days):** $R = 0.2$ (620ms) - Proficient, the easiest resistance just before the final mastery spike.

This coefficient linearly maps to the animation controller configuration:
* **Maximum Target Duration ($R = 1.0$):** 1500 milliseconds.
* **Minimum Target Duration ($R = 0.0$):** 400 milliseconds.

**Important:** This math must be executed within a Riverpod `StateNotifier`, NOT within the UI widget's `build` method. The widget only receives the final `resistanceCoefficient` and `calculatedDurationMs`.

**User tuning layer:** A separate persistent preference layer may modulate the final provider outputs through a bounded preset model (`Gentle`, `Standard`, `Intense`) and an on/off haptic toggle. That tuning must remain outside `MudLongPressButton`, persist per signed-in user/device, and only adjust the computed scalar outputs and haptic density rather than replacing the baseline progression formula above.

**Cancellation rule:** The hold duration starts when the user presses the mud control itself, and completion is valid only while that press remains active through the full required duration. Releasing early must cancel the attempt, reverse the ring back to idle, and must not grant completion, shared progress, or score.

> [!NOTE]
> This section is the canonical mathematical specification for the Mud check-in. Any divergence in the Flutter implementation must be documented and justified here before the implementation is merged.

### 4. Mud Check-In: Flutter Implementation Blueprint (Canonical Reference)

> [!IMPORTANT]
> The code below is the **canonical reference implementation** for the Mud long-press completion widget. Do not refactor the `CatmullRomCurve` control points, haptic feedback intervals, or `AnimationController` disposal pattern without updating this spec first. These values are physics-calibrated against the 0.0–1.0 resistance range.

**Habit-card ring and emoji contract:** Custom-habit emoji is persisted as a leading title prefix and must be resolved through the shared habit-title parser anywhere the ring renders; no additional local database or sync field is needed. The standard card uses a `6px` idle ring and a `12px` established ring. Completion feedback may use the brief green success treatment, then settles with an ease-out transition to the configured habit color; when reduced motion is enabled, it settles directly. The footer progress bar is `6px`, and its day/streak labels use `12px` text. Partner avatar rings remain independently habit-colored.

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// The values here must be passed in via a Riverpod Consumer reading from the StateNotifier
class MudLongPressButton extends StatefulWidget {
  final double resistanceCoefficient;
  final int calculatedDurationMs;
  final VoidCallback onCompletion;

  const MudLongPressButton({
    Key? key,
    required this.resistanceCoefficient,
    required this.calculatedDurationMs,
    required this.onCompletion,
  }) : super(key: key);

  @override
  _MudLongPressButtonState createState() => _MudLongPressButtonState();
}

class _MudLongPressButtonState extends State<MudLongPressButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _curveAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  @override
  void didUpdateWidget(covariant MudLongPressButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.calculatedDurationMs != widget.calculatedDurationMs) {
      _controller.dispose();
      _initAnimation();
    }
  }

  void _initAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.calculatedDurationMs),
    );

    final Curve dynamicCurve = CurvedAnimation(
      parent: _controller,
      curve: Interval(
        0.0, 1.0,
        curve: CatmullRomCurve([
          const Offset(0.0, 0.0),
          // Control point 1: very slow start when resistance is high (early days).
          // As resistance drops (later days), the curve starts rising sooner.
          Offset(0.3, 0.05 * (1.0 - widget.resistanceCoefficient)),
          // Control point 2: mid-curve acceleration shaped by resistance.
          Offset(0.6, 0.2 * (1.0 - widget.resistanceCoefficient)),
          const Offset(1.0, 1.0), // Always completes fully at gesture end.
        ]),
      ),
    ).curve;

    _curveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: dynamicCurve),
    )..addListener(() {
        _handleHapticFeedback();
      })
     ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          HapticFeedback.lightImpact();
          widget.onCompletion();
        }
      });
  }

  void _handleHapticFeedback() {
    if (widget.resistanceCoefficient > 0.5 && _controller.value < 0.4) {
      if ((_controller.value * 100).toInt() % 8 == 0) {
        HapticFeedback.selectionClick();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPressStart: (_) => _controller.forward(),
      onLongPressEnd: (_) {
        if (!_controller.isCompleted) {
          _controller.animateTo(
            0.0,
            duration: Duration(milliseconds: (widget.calculatedDurationMs * 0.5).toInt()),
            curve: Curves.easeOutQuint,
          );
        }
      },
      child: AnimatedBuilder(
        animation: _curveAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: MudButtonPainter(
              progress: _curveAnimation.value,
              resistance: widget.resistanceCoefficient,
            ),
            child: child,
          );
        },
        child: Container(
          width: 200,
          height: 200,
          alignment: Alignment.center,
          child: Text(
            "Hold to Complete",
            style: TextStyle(fontWeight: FontWeight.w500, letterSpacing: 0.5),
          ),
        ),
      ),
    );
  }
}

class MudButtonPainter extends CustomPainter {
  final double progress;
  final double resistance;

  MudButtonPainter({required this.progress, required this.resistance});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;
    
    canvas.drawCircle(center, radius - 4, bgPaint);

    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0 + (resistance * 4.0 * (1.0 - progress))
      ..strokeCap = StrokeCap.round;

    final double sweepAngle = 2 * 3.141592653589793 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 4),
      -3.141592653589793 / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant MudButtonPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.resistance != resistance;
  }
}
```
