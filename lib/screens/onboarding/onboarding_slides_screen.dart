import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/quote_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/skeletons.dart';
import '../../widgets/usage_tracked_screen.dart';

class OnboardingSlidesScreen extends ConsumerStatefulWidget {
  final VoidCallback onGetStarted;
  final VoidCallback onLogIn;

  const OnboardingSlidesScreen({
    super.key,
    required this.onGetStarted,
    required this.onLogIn,
  });

  @override
  ConsumerState<OnboardingSlidesScreen> createState() =>
      _OnboardingSlidesScreenState();
}

class _OnboardingSlidesScreenState
    extends ConsumerState<OnboardingSlidesScreen> {
  late final PageController _pageController;
  int _currentIndex = 0;

  static const List<_OnboardingSlide> _slides = [
    _OnboardingSlide(
      icon: Icons.wb_sunny_outlined,
      eyebrow: 'Day one',
      title: 'Every day is day one.',
      body:
          'Start with a calm read, then one deliberate action. Hable keeps the first step small enough to repeat.',
      quoteLed: true,
    ),
    _OnboardingSlide(
      icon: Icons.touch_app_outlined,
      eyebrow: 'Mud',
      title: 'Start through the mud.',
      body:
          'New habits ask for a steady 1500ms press. That resistance is the point: effort first, stability later.',
    ),
    _OnboardingSlide(
      icon: Icons.flag_outlined,
      eyebrow: 'Commit',
      title: 'Pick a first commit.',
      body:
          'Choose a standard habit or set your own day count. The science-backed 21, 33, and 40 day targets stay close by.',
    ),
    _OnboardingSlide(
      icon: Icons.group_outlined,
      eyebrow: 'Partners',
      title: 'Bring a partner.',
      body:
          'Shared habits show partner progress through habit-colored rings, so support lives directly on the habit card.',
    ),
    _OnboardingSlide(
      icon: Icons.notifications_none_rounded,
      eyebrow: 'Reminders',
      title: 'Let reminders stay gentle.',
      body:
          'Hable asks before scheduling. Turn reminders on only when you want quiet nudges, not demands.',
    ),
    _OnboardingSlide(
      icon: Icons.lock_outline_rounded,
      eyebrow: 'Privacy',
      title: 'Keep reflection private.',
      body:
          'Email verification waits in Settings, and journal reflections stay private. Partners see progress, not your notes.',
    ),
    _OnboardingSlide(
      icon: Icons.check_circle_outline_rounded,
      eyebrow: 'Tracker',
      title: 'No skip button on the ring.',
      body:
          'The main tracker is built for action. Missed days expire naturally, while private reflection stays available when needed.',
    ),
  ];

  bool get _isLastSlide => _currentIndex == _slides.length - 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (_isLastSlide) {
      widget.onGetStarted();
      return;
    }
    await _pageController.nextPage(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return UsageTrackedScreen(
      screenName: 'onboarding',
      child: Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          'Hable',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const Spacer(),
                        TextButton(
                          key: const Key('onboarding-log-in'),
                          onPressed: widget.onLogIn,
                          child: const Text('Log in'),
                        ),
                      ],
                    ),
                    Expanded(
                      child: PageView.builder(
                        key: const Key('onboarding-slide-page-view'),
                        controller: _pageController,
                        itemCount: _slides.length,
                        onPageChanged: (index) {
                          setState(() => _currentIndex = index);
                        },
                        itemBuilder: (context, index) {
                          return _OnboardingSlideView(
                            slide: _slides[index],
                            quote: _slides[index].quoteLed
                                ? ref.watch(quoteProvider)
                                : null,
                            availableHeight: constraints.maxHeight,
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 14),
                    _ProgressDots(
                      count: _slides.length,
                      currentIndex: _currentIndex,
                    ),
                    const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        key: const Key('onboarding-primary-action'),
                        onPressed: _next,
                        child: Text(_isLastSlide ? 'Start setup' : 'Next'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _OnboardingSlide {
  final IconData icon;
  final String eyebrow;
  final String title;
  final String body;
  final bool quoteLed;

  const _OnboardingSlide({
    required this.icon,
    required this.eyebrow,
    required this.title,
    required this.body,
    this.quoteLed = false,
  });
}

class _OnboardingSlideView extends StatelessWidget {
  final _OnboardingSlide slide;
  final AsyncValue<String>? quote;
  final double availableHeight;

  const _OnboardingSlideView({
    required this.slide,
    required this.quote,
    required this.availableHeight,
  });

  @override
  Widget build(BuildContext context) {
    final isCompact = availableHeight < 680;
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: isCompact ? 16 : 28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: isCompact ? 64 : 76,
                height: isCompact ? 64 : 76,
                decoration: BoxDecoration(
                  color: AppTheme.sageGreen.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppTheme.sageGreen.withValues(alpha: 0.18),
                  ),
                ),
                child: Icon(
                  slide.icon,
                  color: AppTheme.sageGreen,
                  size: isCompact ? 30 : 36,
                ),
              ),
              SizedBox(height: isCompact ? 22 : 34),
              Text(
                slide.eyebrow.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppTheme.warmGray,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                slide.title,
                key: Key('onboarding-slide-title-${slide.eyebrow}'),
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  height: 1.18,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                slide.body,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.deepCharcoal.withValues(alpha: 0.78),
                ),
              ),
              if (quote != null) ...[
                SizedBox(height: isCompact ? 22 : 32),
                _QuotePanel(quote: quote!),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _QuotePanel extends StatelessWidget {
  final AsyncValue<String> quote;

  const _QuotePanel({required this.quote});

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const Key('onboarding-quote-panel'),
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.warmGray.withValues(alpha: 0.12)),
      ),
      child: quote.when(
        data: (value) => Text(
          '"$value"',
          key: const Key('onboarding-quote-text'),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppTheme.deepCharcoal,
            fontStyle: FontStyle.italic,
            height: 1.45,
          ),
        ),
        loading: () => const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HableSkeletonBlock(width: 220, height: 14),
            SizedBox(height: 10),
            HableSkeletonBlock(width: 160, height: 14),
          ],
        ),
        error: (_, _) => Text(
          '"Every day is day one."',
          key: const Key('onboarding-quote-text'),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppTheme.deepCharcoal,
            fontStyle: FontStyle.italic,
            height: 1.45,
          ),
        ),
      ),
    );
  }
}

class _ProgressDots extends StatelessWidget {
  final int count;
  final int currentIndex;

  const _ProgressDots({required this.count, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Row(
      key: const Key('onboarding-progress-dots'),
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: isActive ? 24 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.sageGreen
                : AppTheme.warmGray.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}
