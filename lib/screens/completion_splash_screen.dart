import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hable/database/database.dart';
import 'package:hable/models/celebration_feedback.dart';
import 'package:hable/providers/quote_provider.dart';
import 'package:hable/l10n/app_localizations.dart';

/// A dynamic typographic splash screen triggered upon final habit completion.
/// It displays a dynamic congratulation message and the 'Quote of the Day'
/// fetched from the daily sync.
class CompletionSplashScreen extends ConsumerStatefulWidget {
  final Habit habit;
  final String? emoji;
  final CompletionCelebrationSpec? celebration;
  final int? pointsEarned;

  const CompletionSplashScreen({
    super.key,
    required this.habit,
    this.emoji,
    this.celebration,
    this.pointsEarned,
  });

  @override
  ConsumerState<CompletionSplashScreen> createState() =>
      _CompletionSplashScreenState();
}

class _CompletionSplashScreenState extends ConsumerState<CompletionSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _isDismissing = false;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _controller.duration = Duration.zero;
      _controller.value = 1.0;
    } else {
      _controller.duration = const Duration(milliseconds: 600);
    }
  }

  void _dismiss() {
    if (_isDismissing) return;
    setState(() {
      _isDismissing = true;
      // Reassign scale animation to zoom all the way down to 0 on exit
      _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
      );
    });
    _controller.reverse().then((_) {
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quoteAsync = ref.watch(quoteProvider);
    final celebration =
        widget.celebration ??
        resolveCompletionCelebration(
          habit: widget.habit,
          streakCount: 0,
          sharedBonusEarned: false,
        );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: celebration.backgroundColor.withValues(alpha: 0.98),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                alignment: _isDismissing
                    ? const Alignment(0.66, 1.0)
                    : Alignment.center,
                scale: _scaleAnimation.value,
                child: child,
              ),
            );
          },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: IgnorePointer(
                      child: _CelebrationBackdrop(
                        baseColor: celebration.backgroundColor,
                        accentColor: celebration.accentColor,
                        progress: _controller,
                      ),
                    ),
                  ),
                  if (celebration.particleCount > 0)
                    Positioned.fill(
                      child: IgnorePointer(
                        child: _CelebrationParticleField(
                          particleCount: celebration.particleCount,
                          color: celebration.accentColor,
                          progress: _controller,
                        ),
                      ),
                    ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              quoteAsync.when(
                                data: (quote) => Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(text: '"${quote.text}"'),
                                      if (quote.author != null &&
                                          quote.author!.isNotEmpty)
                                        TextSpan(
                                          text: '\n— ${quote.author}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                color: Colors.white70,
                                                fontWeight: FontWeight.w500,
                                                fontStyle: FontStyle.normal,
                                              ),
                                        ),
                                    ],
                                  ),
                                  key: const Key('completion-splash-quote'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w800,
                                        height: 1.35,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                loading: () => const CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                                error: (_, __) => const SizedBox.shrink(),
                              ),
                              const SizedBox(height: 28),
                              if (celebration.kicker != null) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.22,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    celebration.kicker!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.4,
                                        ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                              if (widget.emoji != null &&
                                  widget.emoji!.isNotEmpty)
                                Text(
                                  widget.emoji!,
                                  style: const TextStyle(fontSize: 80),
                                )
                              else
                                const Icon(
                                  Icons.check_circle_rounded,
                                  size: 80,
                                  color: Colors.white,
                                ),
                              const SizedBox(height: 24),
                              Text(
                                celebration.headline,
                                style: Theme.of(context).textTheme.headlineLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                celebration.supportingText,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              if ((widget.pointsEarned ?? 0) > 0) ...[
                                const SizedBox(height: 18),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(999),
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.22,
                                      ),
                                    ),
                                  ),
                                  child: Text(
                                    '${widget.pointsEarned} points earned',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w800,
                                        ),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 32),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: _dismiss,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor:
                                        celebration.backgroundColor,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 16,
                                    ),
                                    textStyle: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w800),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(
                                      context,
                                    )!.completionContinue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CelebrationBackdrop extends StatelessWidget {
  final Color baseColor;
  final Color accentColor;
  final Animation<double> progress;

  const _CelebrationBackdrop({
    required this.baseColor,
    required this.accentColor,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, _) {
        final intensity = Curves.easeOut.transform(progress.value);
        return DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center:
                  Alignment.lerp(
                    Alignment.topCenter,
                    Alignment.center,
                    intensity,
                  ) ??
                  Alignment.center,
              radius: 0.9 + (0.25 * intensity),
              colors: [
                accentColor.withValues(alpha: 0.32 + (0.18 * (1 - intensity))),
                baseColor.withValues(alpha: 0.0),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CelebrationParticleField extends StatelessWidget {
  final int particleCount;
  final Color color;
  final Animation<double> progress;

  const _CelebrationParticleField({
    required this.particleCount,
    required this.color,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, _) {
        return CustomPaint(
          painter: _CelebrationParticlePainter(
            progress: progress.value,
            color: color,
            particleCount: particleCount,
          ),
        );
      },
    );
  }
}

class _CelebrationParticlePainter extends CustomPainter {
  final double progress;
  final Color color;
  final int particleCount;

  const _CelebrationParticlePainter({
    required this.progress,
    required this.color,
    required this.particleCount,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    for (var i = 0; i < particleCount; i++) {
      final normalized = (i + 1) / particleCount;
      final angle = normalized * 6.28318;
      final distance = 60 + (220 * progress * normalized);
      final dx =
          center.dx + (distance * normalized) * (i.isEven ? 1 : -1) * 0.6;
      final dy =
          center.dy +
          (distance * 0.35 * (i % 3 == 0 ? -1 : 1)) +
          (progress * progress * 120);
      final radius = 2 + (normalized * 4);
      final paint = Paint()
        ..color =
            Color.lerp(
              Colors.white.withValues(alpha: 0.0),
              color.withValues(alpha: 0.42 * (1 - progress)),
              normalized,
            ) ??
            color.withValues(alpha: 0.2);
      canvas.drawCircle(
        Offset(dx + (18 * progress * normalized * (angle > 3.14 ? -1 : 1)), dy),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CelebrationParticlePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.particleCount != particleCount;
  }
}
