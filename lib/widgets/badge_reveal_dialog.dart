import 'dart:math';
import 'package:flutter/material.dart';

class BadgeRevealDialog extends StatefulWidget {
  final String title;
  final String subtitle;
  final VoidCallback onDismiss;

  const BadgeRevealDialog({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.onDismiss,
  }) : super(key: key);

  static Future<void> show(
    BuildContext context,
    String title,
    String subtitle,
  ) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black87,
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) {
        return BadgeRevealDialog(
          title: title,
          subtitle: subtitle,
          onDismiss: () {},
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
            ),
            child: child,
          ),
        );
      },
    );
  }

  @override
  _BadgeRevealDialogState createState() => _BadgeRevealDialogState();
}

class _BadgeRevealDialogState extends State<BadgeRevealDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _controller.duration = Duration.zero;
      _controller.value = 1.0;
    } else {
      _controller.duration = const Duration(seconds: 3);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Custom Particle Background
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                painter: _ParticlePainter(_controller.value),
                size: Size.infinite,
              );
            },
          ),

          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Achievement Unlocked!',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.5),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.star_rounded,
                  size: 80,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 32),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text(
                  widget.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onDismiss();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Awesome!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final double progress;
  _ParticlePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(42); // Fixed seed for consistent spread
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < 50; i++) {
      final angle = random.nextDouble() * 2 * pi;
      // Explode outwards and fall down slightly
      final distance = random.nextDouble() * 300 * progress + 50;
      final dx = center.dx + cos(angle) * distance;
      final dy =
          center.dy + sin(angle) * distance + (progress * progress * 200);

      final radius = random.nextDouble() * 4 + 2;
      final opacity = (1.0 - progress).clamp(0.0, 1.0);

      final colors = [
        Colors.yellow,
        Colors.orange,
        Colors.redAccent,
        Colors.white,
      ];
      final color = colors[random.nextInt(colors.length)].withOpacity(opacity);

      final paint = Paint()..color = color;
      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ParticlePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
