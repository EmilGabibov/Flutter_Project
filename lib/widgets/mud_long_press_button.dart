import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../models/habit_visual_state.dart';

/// Physics-based "Mud" long-press completion button.
/// Consumes pre-computed [resistanceCoefficient] and [calculatedDurationMs]
/// from the Riverpod [ResistanceNotifier] — NO internal math.
///
/// Now supports rendering a habit icon inside the ring with smooth animations
/// from larger/faded to smaller/fully visible during hold completion.
class MudLongPressButton extends StatefulWidget {
  final double resistanceCoefficient;
  final int calculatedDurationMs;
  final VoidCallback onCompletion;
  final bool isCompleted;
  /// Per-habit accent color for the ring arc. Defaults to sage green.
  final Color habitColor;
  /// Optional habit icon/emoji to render inside the ring.
  final String? habitIcon;
  /// Reusable visual parameters for icon scale, opacity, ring thickness, etc.
  final HabitVisualParameters visualParameters;

  const MudLongPressButton({
    super.key,
    required this.resistanceCoefficient,
    required this.calculatedDurationMs,
    required this.onCompletion,
    this.isCompleted = false,
    this.habitColor = AppTheme.sageGreen,
    this.habitIcon,
    this.visualParameters = HabitVisualParameters.standard,
  });

  @override
  State<MudLongPressButton> createState() => _MudLongPressButtonState();
}

class _MudLongPressButtonState extends State<MudLongPressButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _curveAnimation;
  late Animation<double> _iconScaleAnimation;
  late Animation<double> _iconOpacityAnimation;

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  @override
  void didUpdateWidget(covariant MudLongPressButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.calculatedDurationMs != widget.calculatedDurationMs ||
        oldWidget.resistanceCoefficient != widget.resistanceCoefficient) {
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
        0.0,
        1.0,
        curve: Cubic(
          0.3,
          0.05 * (1.0 - widget.resistanceCoefficient),
          0.6,
          0.2 * (1.0 - widget.resistanceCoefficient),
        ),
      ),
    ).curve;

    _curveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: dynamicCurve),
    )
      ..addListener(_handleHapticFeedback)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          HapticFeedback.lightImpact();
          widget.onCompletion();
        }
      });

    // ─ Icon animations: fade in and scale down during hold ─
    _iconOpacityAnimation = Tween<double>(
      begin: widget.visualParameters.idleIconOpacity,
      end: widget.visualParameters.completedIconOpacity,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _iconScaleAnimation = Tween<double>(
      begin: widget.visualParameters.idleIconScale,
      end: widget.visualParameters.completedIconScale,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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
    if (widget.isCompleted) {
      return _buildCompletedState();
    }

    return GestureDetector(
      onLongPressStart: (_) => _controller.forward(),
      onLongPressEnd: (_) {
        if (!_controller.isCompleted) {
          _controller.animateTo(
            0.0,
            duration: Duration(
                milliseconds: (widget.calculatedDurationMs * 0.5).toInt()),
            curve: Curves.easeOutQuint,
          );
        }
      },
      child: AnimatedBuilder(
        animation: _curveAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: _MudButtonPainter(
              progress: _curveAnimation.value,
              resistance: widget.resistanceCoefficient,
              habitColor: widget.habitColor,
              ringThickness: Tween<double>(
                begin: widget.visualParameters.idleRingThickness,
                end: widget.visualParameters.progressingRingThickness,
              ).evaluate(_curveAnimation),
            ),
            child: child,
          );
        },
        child: SizedBox(
          width: 180,
          height: 180,
          child: Center(
            child: _buildIconContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildCompletedState() {
    return SizedBox(
      width: 180,
      height: 180,
      child: CustomPaint(
        painter: _MudButtonPainter(
          progress: 1.0,
          resistance: 0.0,
          habitColor: widget.habitColor,
          ringThickness: widget.visualParameters.progressingRingThickness,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_rounded,
                size: 48,
                color: widget.habitColor,
              ),
              const SizedBox(height: 8),
              Text(
                'Done!',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: widget.habitColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the icon content inside the ring.
  /// If a habit icon is provided, display it with animations.
  /// Otherwise, show a default spa icon with hold-to-complete text.
  Widget _buildIconContent() {
    if (widget.habitIcon != null && widget.habitIcon!.isNotEmpty) {
      return Stack(
        alignment: Alignment.center,
        children: [
          // Animated habit icon inside the ring
          AnimatedBuilder(
            animation: Listenable.merge([_iconScaleAnimation, _iconOpacityAnimation]),
            builder: (context, child) {
              return Opacity(
                opacity: _iconOpacityAnimation.value,
                child: Transform.scale(
                  scale: _iconScaleAnimation.value,
                  child: Text(
                    widget.habitIcon!,
                    style: const TextStyle(fontSize: 56),
                  ),
                ),
              );
            },
          ),
        ],
      );
    } else {
      // Default icon with hold-to-complete text
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.spa_rounded,
            size: 40,
            color: AppTheme.deepCharcoal.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 8),
          Text(
            'Hold to Complete',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              fontSize: 14,
              color: AppTheme.deepCharcoal.withValues(alpha: 0.7),
            ),
          ),
        ],
      );
    }
  }

}

class _MudButtonPainter extends CustomPainter {
  final double progress;
  final double resistance;
  final Color habitColor;
  final double ringThickness;

  _MudButtonPainter({
    required this.progress,
    required this.resistance,
    this.habitColor = AppTheme.sageGreen,
    this.ringThickness = 6.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // ── Background track (thin, muted) ──────────────────────────────────────
    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringThickness * 0.6
      ..strokeCap = StrokeCap.round
      ..color = habitColor.withValues(alpha: 0.12);
    canvas.drawCircle(center, radius - 10, bgPaint);

    if (progress <= 0) return;

    // ── Dynamic progress arc — app-icon-inspired thick rounded ring ──────────
    // Ring starts thin and grows thicker under high resistance ("mud" feel).
    final arcThickness = ringThickness + (resistance * 6.0 * (1.0 - progress));

    // Color: lerps from habit pastel → vivid completion green at 100%
    final progressColor = Color.lerp(
      habitColor,
      AppTheme.completionGreen,
      progress,
    )!;

    // Soft glow shadow beneath the arc
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = arcThickness + 8
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
      ..color = progressColor.withValues(alpha: 0.25);

    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = arcThickness
      ..strokeCap = StrokeCap.round
      ..color = progressColor;

    final double sweepAngle = 2 * pi * progress;
    final arcRect = Rect.fromCircle(center: center, radius: radius - 10);

    canvas.drawArc(arcRect, -pi / 2, sweepAngle, false, glowPaint);
    canvas.drawArc(arcRect, -pi / 2, sweepAngle, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant _MudButtonPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.resistance != resistance ||
        oldDelegate.habitColor != habitColor ||
        oldDelegate.ringThickness != ringThickness;
  }
}
