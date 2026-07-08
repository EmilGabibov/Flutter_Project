import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

/// Physics-based "Mud" long-press completion button.
/// Consumes pre-computed [resistanceCoefficient] and [calculatedDurationMs]
/// from the Riverpod [ResistanceNotifier] — NO internal math.
class MudLongPressButton extends StatefulWidget {
  final double resistanceCoefficient;
  final int calculatedDurationMs;
  final VoidCallback onCompletion;
  final bool isCompleted;

  const MudLongPressButton({
    super.key,
    required this.resistanceCoefficient,
    required this.calculatedDurationMs,
    required this.onCompletion,
    this.isCompleted = false,
  });

  @override
  State<MudLongPressButton> createState() => _MudLongPressButtonState();
}

class _MudLongPressButtonState extends State<MudLongPressButton>
    with SingleTickerProviderStateMixin {
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
            ),
            child: child,
          );
        },
        child: SizedBox(
          width: 180,
          height: 180,
          child: Center(
            child: Column(
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
            ),
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
        painter: _MudButtonPainter(progress: 1.0, resistance: 0.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle_rounded,
                size: 48,
                color: AppTheme.completionGreen,
              ),
              const SizedBox(height: 8),
              Text(
                'Done!',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AppTheme.completionGreen,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MudButtonPainter extends CustomPainter {
  final double progress;
  final double resistance;

  _MudButtonPainter({required this.progress, required this.resistance});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background track
    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round
      ..color = AppTheme.surfaceVariant;
    canvas.drawCircle(center, radius - 6, bgPaint);

    // Dynamic progress arc
    final progressColor = Color.lerp(
      AppTheme.sageGreen,
      AppTheme.completionGreen,
      progress,
    )!;

    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0 + (resistance * 4.0 * (1.0 - progress))
      ..strokeCap = StrokeCap.round
      ..color = progressColor;

    final double sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 6),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _MudButtonPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.resistance != resistance;
  }
}
