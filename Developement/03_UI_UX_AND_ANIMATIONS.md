# 03: UI/UX & Animation Specifications (Native Flutter)

This document provides the complete technical specification and native Flutter code implementation for the dynamic "mud-resistance" long-press completion interaction.

## 1. Visual Philosophy ("Chill & Minimal")
* **Colors:** Muted tones (pastels, sage greens, warm grays). Reserve vibrant/neon colors strictly for the exact moment of a habit completion.
* **Typography:** Clean, rounded sans-serif. Generous line height and negative space.
* **Layout:** Protect the user from "dashboard fatigue." The Home Screen focuses ONLY on today's action. All historical data and charts belong exclusively on the Profile Screen. Ensure mobile viewports are dynamic and stable.
* **Habit Creation:** The shared `HabitFormSheet` is the single post-onboarding creation/edit surface. Home exposes a labeled add button in the header and an empty-state Add habit button; Profile remains the management/editing surface. The sheet offers quick-select chips from `standard_habits.dart`, a day-duration field, color selection, and an accepted-friend partner picker for new habits.
* **Home Suggestions:** Suggested preset cards are quick-start shortcuts for the empty Home state only. Once active habits exist, Home should prioritize today's habit cards and keep the add action compact.
* **Home Progress Labels:** Home habit cards should distinguish challenge progress (`Challenge: Day X of N`) from consecutive-completion streaks. Avoid duplicating day count and fire-streak language around the ring.
* **Per-Card Social Context:** Habit cards should carry the primary partner/supporter status surface. Show up to four avatars inline, keep role/status visible without opening another screen, and use a simple `+N` overflow indicator for larger groups.
* **Auth & Activation:** Initial signup/login should ask for username and password only. Email/PIN verification belongs in Profile as an optional cloud-sync/recovery activation card, so users can start quickly and opt into verified email later.
* **Profile Progression:** Profile should display server-owned `total_points`, level name, and achievement unlocks cached from `/api/sync/daily`. Do not infer badges from completed local habits as the source of truth.
* **Role-Gated Actions:** Supporters can observe and nudge but must not see active completion/skip affordances. Profile habit edit/archive controls should disable gracefully when cached role data says the user is not the owner.

### 2. Mandatory Friction (Skipping)
If a user skips a habit, open a glassmorphic bottom sheet requiring a text input (Journal Entry). The UI must visually reflect the penalty (extending the journey map).

### 3. Mathematical Model for Physical Resistance

The gesture's behavioral characteristics depend entirely on the habit timeline progression. The physical resistance behaves according to two variables: total duration ($D$) and current day index ($d$).

The baseline resistance coefficient ($R$) is bounded between $0.0$ and $1.0$:
$$R = 1.0 - \left(\frac{d}{D}\right)$$

This coefficient linearly maps to the animation controller configuration:
* **Maximum Target Duration (Day 1, $R = 1.0$):** 1500 milliseconds.
* **Minimum Target Duration (Final Day, $R = 0.0$):** 400 milliseconds.

**Important:** This math must be executed within a Riverpod `StateNotifier`, NOT within the UI widget's `build` method. The widget only receives the final `resistanceCoefficient` and `calculatedDurationMs`.

### 4. Flutter Implementation Blueprint

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
          Offset(0.3, 0.05 * (1.0 - widget.resistanceCoefficient)),
          Offset(0.6, 0.2 * (1.0 - widget.resistanceCoefficient)),
          const Offset(1.0, 1.0),
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
