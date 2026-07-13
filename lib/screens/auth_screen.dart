import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/skeletons.dart';
import '../widgets/usage_tracked_screen.dart';
import 'onboarding/onboarding_slides_screen.dart';
import '../widgets/language_selector.dart';
import '../widgets/accessibility_selector.dart';
import '../l10n/app_localizations.dart';

enum AuthView { login, register, forgotPasswordRequest, forgotPasswordVerify }

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _pinController = TextEditingController();

  AuthView _currentView = AuthView.login;
  bool _isAutoLoggingIn = false;
  bool _showIntroSlides = true;

  @override
  void initState() {
    super.initState();
    const seedUserId = String.fromEnvironment('SEED_USER_ID');
    final allowSeedLogin = defaultTargetPlatform != TargetPlatform.macOS;
    if (seedUserId.isNotEmpty && allowSeedLogin) {
      _isAutoLoggingIn = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final success = await ref
            .read(authProvider.notifier)
            .testLogin(seedUserId);
        if (!success && mounted) {
          if (mounted) setState(() => _isAutoLoggingIn = false);
        }
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final notifier = ref.read(authProvider.notifier);
    final loc = AppLocalizations.of(context)!;

    if (_currentView == AuthView.login) {
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();
      if (username.isEmpty || password.isEmpty) return;

      final success = await notifier.login(username, password);
      if (!success && mounted) {
        setState(() {});
      }
    } else if (_currentView == AuthView.register) {
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();
      if (username.isEmpty || password.isEmpty) return;

      final success = await notifier.register(username, password);
      if (!success && mounted) {
        setState(() {});
      }
    } else if (_currentView == AuthView.forgotPasswordRequest) {
      final email = _emailController.text.trim();
      if (email.isEmpty) return;

      final success = await notifier.requestPin(email);
      if (success && mounted) {
        setState(() => _currentView = AuthView.forgotPasswordVerify);
      }
    } else if (_currentView == AuthView.forgotPasswordVerify) {
      final email = _emailController.text.trim();
      final pin = _pinController.text.trim();
      final newPassword = _passwordController.text.trim();
      if (email.isEmpty || pin.isEmpty || newPassword.isEmpty) return;

      final success = await notifier.resetPassword(email, pin, newPassword);
      if (success && mounted) {
        setState(() => _currentView = AuthView.login);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(loc.authResetSuccessMessage)));
      }
    }
  }

  void _switchView(AuthView view) {
    setState(() {
      _currentView = view;
      ref.read(authProvider.notifier).clearError();
    });
  }

  void _finishIntro(AuthView view) {
    setState(() {
      _showIntroSlides = false;
      _currentView = view;
      ref.read(authProvider.notifier).clearError();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final loc = AppLocalizations.of(context)!;

    if (_isAutoLoggingIn) {
      return const Scaffold(body: SafeArea(child: _AuthLoadingSkeleton()));
    }

    if (_showIntroSlides) {
      return OnboardingSlidesScreen(
        onGetStarted: () => _finishIntro(AuthView.register),
        onLogIn: () => _finishIntro(AuthView.login),
      );
    }

    String title;
    String subtitle;
    String buttonText;

    switch (_currentView) {
      case AuthView.login:
        title = loc.authWelcomeTitle;
        subtitle = loc.authLoginSubtitle;
        buttonText = loc.authLoginButton;
        break;
      case AuthView.register:
        title = loc.authJoinTitle;
        subtitle = loc.authJoinSubtitle;
        buttonText = loc.authSignUpButton;
        break;
      case AuthView.forgotPasswordRequest:
        title = loc.authResetTitle;
        subtitle = loc.authResetSubtitle;
        buttonText = loc.authSendPinButton;
        break;
      case AuthView.forgotPasswordVerify:
        title = loc.authVerifyTitle;
        subtitle = loc.authVerifySubtitle;
        buttonText = loc.authResetTitle;
        break;
    }

    return Scaffold(
      body: UsageTrackedScreen(
        screenName: 'auth',
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: SingleChildScrollView(
              child: SizedBox(
                height:
                    MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: const [
                        AccessibilitySelector(),
                        LanguageSelector(compact: true),
                      ],
                    ),
                    const Spacer(flex: 2),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 40),
                    if (_currentView == AuthView.login ||
                        _currentView == AuthView.register)
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: loc.authUsernameLabel,
                          prefixIcon: const Icon(Icons.person_outline_rounded),
                        ),
                        autocorrect: false,
                        enableSuggestions: false,
                        textCapitalization: TextCapitalization.none,
                        textInputAction: TextInputAction.next,
                      ),
                    if (_currentView == AuthView.forgotPasswordRequest)
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: loc.authEmailLabel,
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction:
                            _currentView == AuthView.forgotPasswordRequest
                            ? TextInputAction.done
                            : TextInputAction.next,
                        onSubmitted:
                            _currentView == AuthView.forgotPasswordRequest
                            ? (_) => _submit()
                            : null,
                      ),
                    if (_currentView == AuthView.forgotPasswordVerify)
                      TextField(
                        controller: _pinController,
                        decoration: InputDecoration(
                          labelText: loc.authPinLabel,
                          prefixIcon: const Icon(Icons.pin_outlined),
                        ),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                      ),
                    if (_currentView != AuthView.forgotPasswordRequest)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText:
                                _currentView == AuthView.forgotPasswordVerify
                                ? loc.authNewPasswordLabel
                                : loc.authPasswordLabel,
                            prefixIcon: const Icon(Icons.lock_outline_rounded),
                          ),
                          onSubmitted: (_) => _submit(),
                        ),
                      ),
                    if (_currentView == AuthView.login)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () =>
                              _switchView(AuthView.forgotPasswordRequest),
                          child: Text(
                            loc.authForgotPassword,
                            style: TextStyle(color: AppTheme.sageGreen),
                          ),
                        ),
                      )
                    else
                      const SizedBox(height: 24),
                    if (authState.error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          authState.error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ElevatedButton(
                      onPressed: authState.isLoading ? null : _submit,
                      child: Text(
                        authState.isLoading ? loc.authWorking : buttonText,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_currentView == AuthView.login ||
                        _currentView == AuthView.register)
                      TextButton(
                        onPressed: authState.isLoading
                            ? null
                            : () => _switchView(
                                _currentView == AuthView.login
                                    ? AuthView.register
                                    : AuthView.login,
                              ),
                        child: Text(
                          _currentView == AuthView.login
                              ? loc.authNeedAccount
                              : loc.authAlreadyHaveAccount,
                          style: const TextStyle(color: AppTheme.sageGreen),
                        ),
                      )
                    else
                      TextButton(
                        onPressed: authState.isLoading
                            ? null
                            : () => _switchView(AuthView.login),
                        child: Text(
                          loc.authBackToLogin,
                          style: TextStyle(color: AppTheme.sageGreen),
                        ),
                      ),
                    const SizedBox(height: 16),
                    Text(
                      loc.authGdprFooter,
                      key: const Key('auth-data-protection-footer'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.warmGray,
                        height: 1.4,
                      ),
                    ),
                    const Spacer(flex: 3),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthLoadingSkeleton extends StatelessWidget {
  const _AuthLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const [
          HableSkeletonBlock(width: 180, height: 34),
          SizedBox(height: 12),
          HableSkeletonBlock(width: 240, height: 14),
          SizedBox(height: 40),
          HableSkeletonCard(height: 58),
          HableSkeletonCard(height: 58),
          SizedBox(height: 12),
          HableSkeletonBlock(height: 48),
        ],
      ),
    );
  }
}
