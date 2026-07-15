import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../l10n/app_localizations.dart';
import '../theme/app_theme.dart';
import '../models/habit_visual_state.dart';
import '../providers/mud_tuning_provider.dart';

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
  final HabitVisualState visualState;

  /// Per-habit accent color for the ring arc. Defaults to sage green.
  final Color habitColor;

  /// Optional habit icon/emoji to render inside the ring.
  final String? habitIcon;

  /// Reusable visual parameters for icon scale, opacity, ring thickness, etc.
  final HabitVisualParameters visualParameters;
  final bool hapticsEnabled;
  final MudHapticProfile hapticProfile;

  const MudLongPressButton({
    super.key,
    required this.resistanceCoefficient,
    required this.calculatedDurationMs,
    required this.onCompletion,
    this.visualState = HabitVisualState.idle,
    this.habitColor = AppTheme.sageGreen,
    this.habitIcon,
    this.visualParameters = HabitVisualParameters.standard,
    this.hapticsEnabled = true,
    this.hapticProfile = MudHapticProfile.standard,
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
  bool _isHolding = false;
  bool _completedDuringCurrentHold = false;
  bool _shouldAnimateEstablishedSettle = false;

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  @override
  void didUpdateWidget(covariant MudLongPressButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.visualState != widget.visualState) {
      _shouldAnimateEstablishedSettle =
          oldWidget.visualState == HabitVisualState.checkInComplete &&
          widget.visualState == HabitVisualState.established;
    }
    if (oldWidget.calculatedDurationMs != widget.calculatedDurationMs ||
        oldWidget.resistanceCoefficient != widget.resistanceCoefficient) {
      _controller.dispose();
      _initAnimation();
    }
  }

  void _initAnimation() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: max(100, widget.calculatedDurationMs)),
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

    _curveAnimation =
        Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(CurvedAnimation(parent: _controller, curve: dynamicCurve))
          ..addListener(_handleHapticFeedback)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed &&
                _isHolding &&
                !_completedDuringCurrentHold) {
              _completedDuringCurrentHold = true;
              if (widget.hapticsEnabled) {
                switch (widget.hapticProfile) {
                  case MudHapticProfile.soft:
                    HapticFeedback.selectionClick();
                    break;
                  case MudHapticProfile.standard:
                    HapticFeedback.lightImpact();
                    break;
                  case MudHapticProfile.strong:
                    HapticFeedback.mediumImpact();
                    break;
                }
              }
              widget.onCompletion();
            }
          });

    // ─ Icon animations: fade in and scale down during hold ─
    _iconOpacityAnimation = Tween<double>(
      begin: widget.visualParameters.idleIconOpacity,
      end: widget.visualParameters.completedIconOpacity,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _iconScaleAnimation = Tween<double>(
      begin: widget.visualParameters.idleIconScale,
      end: widget.visualParameters.completedIconScale,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  void _handleHapticFeedback() {
    if (!widget.hapticsEnabled) return;
    if (widget.resistanceCoefficient > 0.5 && _controller.value < 0.4) {
      final modulus = switch (widget.hapticProfile) {
        MudHapticProfile.soft => 12,
        MudHapticProfile.standard => 8,
        MudHapticProfile.strong => 6,
      };
      if ((_controller.value * 100).toInt() % modulus == 0) {
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
    final loc = AppLocalizations.of(context)!;
    if (widget.visualState == HabitVisualState.checkInComplete) {
      return _buildCompletionFlashState(loc);
    }

    if (widget.visualState == HabitVisualState.established) {
      return _buildEstablishedState(context);
    }

    final isDisabled =
        widget.visualState == HabitVisualState.established ||
        widget.visualState == HabitVisualState.missed ||
        widget.visualState == HabitVisualState.skipped ||
        widget.visualState == HabitVisualState.checkInComplete;

    final isDimmed =
        widget.visualState == HabitVisualState.missed ||
        widget.visualState == HabitVisualState.skipped;

    return Semantics(
      button: true,
      label: loc.mudCompleteHabitLabel,
      hint: loc.mudLongPressHint,
      value: '${(_curveAnimation.value * 100).toInt()}%',
      onLongPress: isDisabled ? null : () => widget.onCompletion(),
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: isDisabled ? null : (_) => _startHold(),
        onPointerUp: isDisabled ? null : (_) => _cancelHold(),
        onPointerCancel: isDisabled ? null : (_) => _cancelHold(),
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
                isDimmed: isDimmed,
              ),
              child: child,
            );
          },
          child: SizedBox(
            width: 180,
            height: 180,
            child: Center(
              child: isDimmed
                  ? Opacity(opacity: 0.5, child: _buildIconContent())
                  : _buildIconContent(),
            ),
          ),
        ),
      ),
    );
  }

  void _startHold() {
    _isHolding = true;
    _completedDuringCurrentHold = false;
    _controller.forward(from: 0.0);
  }

  void _cancelHold() {
    _isHolding = false;
    if (_completedDuringCurrentHold) {
      return;
    }
    if (_controller.value <= 0.0) {
      return;
    }
    _controller.animateTo(
      0.0,
      duration: Duration(
        milliseconds: max(100, (widget.calculatedDurationMs * 0.5).toInt()),
      ),
      curve: Curves.easeOutQuint,
    );
  }

  Widget _buildCompletionFlashState(AppLocalizations loc) {
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
                loc.mudDone,
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

  Widget _buildEstablishedState(BuildContext context) {
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    return SizedBox(
      width: 180,
      height: 180,
      child: TweenAnimationBuilder<Color?>(
        tween: ColorTween(
          begin: disableAnimations
              ? widget.habitColor
              : _shouldAnimateEstablishedSettle
              ? AppTheme.completionGreen
              : widget.habitColor,
          end: widget.habitColor,
        ),
        duration: disableAnimations
            ? Duration.zero
            : Duration(milliseconds: widget.visualParameters.completionFlashMs),
        curve: Curves.easeOutCubic,
        builder: (context, settledColor, child) {
          return CustomPaint(
            painter: _MudButtonPainter(
              progress: 1.0,
              resistance: 0.0,
              habitColor: widget.habitColor,
              completionColor: settledColor ?? widget.habitColor,
              ringThickness: widget.visualParameters.establishedRingThickness,
            ),
            child: child,
          );
        },
        child: Center(
          child: widget.habitIcon != null && widget.habitIcon!.isNotEmpty
              ? Opacity(
                  opacity: widget.visualParameters.completedIconOpacity,
                  child: Transform.scale(
                    scale: widget.visualParameters.completedIconScale,
                    child: Text(
                      widget.habitIcon!,
                      style: const TextStyle(fontSize: 56),
                    ),
                  ),
                )
              : Icon(Icons.spa_rounded, size: 40, color: widget.habitColor),
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
            animation: Listenable.merge([
              _iconScaleAnimation,
              _iconOpacityAnimation,
            ]),
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
            AppLocalizations.of(context)!.mudHoldToComplete,
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
  final Color? completionColor;
  final double ringThickness;
  final bool isDimmed;

  _MudButtonPainter({
    required this.progress,
    required this.resistance,
    this.habitColor = AppTheme.sageGreen,
    this.completionColor,
    this.ringThickness = 6.0,
    this.isDimmed = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // ── Background track (thin, muted) ──────────────────────────────────────
    final baseColor = isDimmed
        ? AppTheme.deepCharcoal.withValues(alpha: 0.2)
        : habitColor;

    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringThickness * 0.6
      ..strokeCap = StrokeCap.round
      ..color = baseColor.withValues(alpha: 0.12);
    canvas.drawCircle(center, radius - 10, bgPaint);

    if (progress <= 0) return;

    // ── Dynamic progress arc — app-icon-inspired thick rounded ring ──────────
    // Ring starts thin and grows thicker under high resistance ("mud" feel).
    final arcThickness = ringThickness + (resistance * 6.0 * (1.0 - progress));

    // Color: lerps from habit pastel to green for completion feedback, unless
    // an established-state transition supplies its configured settled color.
    final targetColor = isDimmed
        ? AppTheme.deepCharcoal.withValues(alpha: 0.4)
        : completionColor ?? AppTheme.completionGreen;
    final progressColor = Color.lerp(baseColor, targetColor, progress)!;

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
        oldDelegate.completionColor != completionColor ||
        oldDelegate.ringThickness != ringThickness ||
        oldDelegate.isDimmed != isDimmed;
  }
}
