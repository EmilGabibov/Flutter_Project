import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../database/database.dart';
import '../../providers/habit_providers.dart';
import '../../providers/social_providers.dart';
import '../skeletons.dart';

class HabitEnvironmentVisualizer extends ConsumerStatefulWidget {
  final double height;

  const HabitEnvironmentVisualizer({super.key, this.height = 300});

  @override
  ConsumerState<HabitEnvironmentVisualizer> createState() =>
      _HabitEnvironmentVisualizerState();
}

class _HabitEnvironmentVisualizerState
    extends ConsumerState<HabitEnvironmentVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final userId = userAsync.value?.userId;

    if (userId == null) {
      return SizedBox(
        height: widget.height,
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: HableSkeletonBlock(
            height: double.infinity,
            borderRadius: BorderRadius.all(Radius.circular(28)),
          ),
        ),
      );
    }

    final habitsAsync = ref.watch(activeHabitsProvider(userId));
    final partnersAsync = ref.watch(allPartnersProvider);

    final habits = habitsAsync.value ?? [];
    final partners = partnersAsync.value ?? [];

    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _EnvironmentPainter(
              habits: habits,
              partners: partners,
              animationValue: _controller.value,
            ),
          );
        },
      ),
    );
  }
}

class _EnvironmentPainter extends CustomPainter {
  final List<Habit> habits;
  final List<PartnerSnapshot> partners;
  final double animationValue;

  _EnvironmentPainter({
    required this.habits,
    required this.partners,
    required this.animationValue,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Center of the canvas
    final center = Offset(size.width / 2, size.height / 2);

    // Draw background (subtle gradient/stars could go here)

    // Parse hex to color
    Color hexToColor(String hex) {
      hex = hex.replaceAll('#', '');
      if (hex.length == 6) {
        hex = 'FF$hex';
      }
      return Color(int.parse(hex, radix: 16));
    }

    // A helper to draw a glowing 3D-ish orb
    void drawOrb(
      Offset position,
      double radius,
      Color color, {
      bool isPartner = false,
    }) {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      // Glow effect
      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
      canvas.drawCircle(position, radius * 1.5, glowPaint);

      // Main orb
      final gradient = RadialGradient(
        colors: [
          color.withValues(alpha: 0.8),
          color.withValues(alpha: 0.4),
          color.withValues(alpha: 0.1),
        ],
        stops: const [0.2, 0.7, 1.0],
      );
      final rect = Rect.fromCircle(center: position, radius: radius);
      paint.shader = gradient.createShader(rect);
      canvas.drawCircle(position, radius, paint);

      // Inner highlight to simulate 3D sphere
      final highlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: isPartner ? 0.2 : 0.4)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        position.translate(-radius * 0.3, -radius * 0.3),
        radius * 0.3,
        highlightPaint,
      );
    }

    // Layout variables
    final random = Random(42); // Deterministic layout based on index

    // 1. Draw connections (lines between user habits and partner habits)
    for (int i = 0; i < habits.length; i++) {
      final habit = habits[i];
      final habitColor = hexToColor(habit.colorHex);
      final angle =
          (i / max(1, habits.length)) * 2 * pi + (animationValue * pi * 0.5);
      final distance = size.width * 0.2;
      final habitPos = Offset(
        center.dx + cos(angle) * distance,
        center.dy + sin(angle) * distance * 0.6, // Pseudo-3D tilt
      );

      // Find partners for this habit
      final habitPartners = partners
          .where((p) => p.habitId == habit.habitId)
          .toList();
      for (int j = 0; j < habitPartners.length; j++) {
        final p = habitPartners[j];
        final pAngle = angle + (j + 1) * 0.5 + (animationValue * pi * 2);
        final pDistance = 50.0 + random.nextDouble() * 30.0;
        final pPos = Offset(
          habitPos.dx + cos(pAngle) * pDistance,
          habitPos.dy + sin(pAngle) * pDistance * 0.6,
        );

        // Draw connection line
        final linePaint = Paint()
          ..color = habitColor.withValues(alpha: 0.2)
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke;
        canvas.drawLine(habitPos, pPos, linePaint);

        // Draw partner orb (smaller)
        final pRadius = 8.0 + min((p.currentDuration / 10.0), 10.0);
        drawOrb(pPos, pRadius, habitColor, isPartner: true);
      }
    }

    // 2. Draw main user habits (drawn last so they appear on top)
    for (int i = 0; i < habits.length; i++) {
      final habit = habits[i];
      final habitColor = hexToColor(habit.colorHex);
      final angle =
          (i / max(1, habits.length)) * 2 * pi + (animationValue * pi * 0.5);
      final distance = size.width * 0.2;
      final habitPos = Offset(
        center.dx + cos(angle) * distance,
        center.dy + sin(angle) * distance * 0.6,
      );

      final radius =
          15.0 +
          min(
            (habit.currentDuration /
                    (habit.targetDuration == 0 ? 1 : habit.targetDuration)) *
                20.0,
            30.0,
          );
      drawOrb(habitPos, radius, habitColor);
    }
  }

  @override
  bool shouldRepaint(covariant _EnvironmentPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.habits.length != habits.length ||
        oldDelegate.partners.length != partners.length;
  }
}
