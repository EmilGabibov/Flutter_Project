import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

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

  @override
  void initState() {
    super.initState();
    const seedUserId = String.fromEnvironment('SEED_USER_ID');
    if (seedUserId.isNotEmpty) {
      _isAutoLoggingIn = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final success = await ref.read(authProvider.notifier).testLogin(seedUserId);
        if (success && mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => HomeScreen(userId: seedUserId),
            ),
          );
        } else {
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
    
    if (_currentView == AuthView.login) {
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();
      if (username.isEmpty || password.isEmpty) return;
      
      final success = await notifier.login(username, password);
      _handleSuccess(success);
    } 
    else if (_currentView == AuthView.register) {
      final username = _usernameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      if (username.isEmpty || email.isEmpty || password.isEmpty) return;
      
      final success = await notifier.register(username, email, password);
      _handleSuccess(success);
    }
    else if (_currentView == AuthView.forgotPasswordRequest) {
      final email = _emailController.text.trim();
      if (email.isEmpty) return;
      
      final success = await notifier.requestPin(email);
      if (success && mounted) {
        setState(() => _currentView = AuthView.forgotPasswordVerify);
      }
    }
    else if (_currentView == AuthView.forgotPasswordVerify) {
      final email = _emailController.text.trim();
      final pin = _pinController.text.trim();
      final newPassword = _passwordController.text.trim();
      if (email.isEmpty || pin.isEmpty || newPassword.isEmpty) return;
      
      final success = await notifier.resetPassword(email, pin, newPassword);
      if (success && mounted) {
        setState(() => _currentView = AuthView.login);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset successful. Please log in.')),
        );
      }
    }
  }

  void _handleSuccess(bool success) {
    if (success && mounted) {
      final authState = ref.read(authProvider);
      if (authState.userId != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => HomeScreen(userId: authState.userId!),
          ),
        );
      }
    }
  }

  void _switchView(AuthView view) {
    setState(() {
      _currentView = view;
      ref.read(authProvider.notifier).clearError();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    if (_isAutoLoggingIn) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    String title;
    String subtitle;
    String buttonText;

    switch (_currentView) {
      case AuthView.login:
        title = 'Welcome to\nHable.';
        subtitle = 'Log in to continue your journey.';
        buttonText = 'Log In';
        break;
      case AuthView.register:
        title = 'Join Hable.';
        subtitle = 'Create an account to track your habits.';
        buttonText = 'Sign Up';
        break;
      case AuthView.forgotPasswordRequest:
        title = 'Reset Password';
        subtitle = 'Enter your email to receive a verification PIN.';
        buttonText = 'Send PIN';
        break;
      case AuthView.forgotPasswordVerify:
        title = 'Verify PIN';
        subtitle = 'Enter the PIN sent to your email and your new password.';
        buttonText = 'Reset Password';
        break;
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(flex: 2),
                  Text(title, style: Theme.of(context).textTheme.headlineLarge, textAlign: TextAlign.left),
                  const SizedBox(height: 12),
                  Text(subtitle, style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 40),
                  
                  if (_currentView == AuthView.login || _currentView == AuthView.register)
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(labelText: 'Username', prefixIcon: Icon(Icons.person_outline_rounded)),
                      textInputAction: TextInputAction.next,
                    ),
                  if (_currentView == AuthView.register || _currentView == AuthView.forgotPasswordRequest)
                    Padding(
                      padding: EdgeInsets.only(top: _currentView == AuthView.register ? 16 : 0),
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: _currentView == AuthView.forgotPasswordRequest ? TextInputAction.done : TextInputAction.next,
                        onSubmitted: _currentView == AuthView.forgotPasswordRequest ? (_) => _submit() : null,
                      ),
                    ),
                  if (_currentView == AuthView.forgotPasswordVerify)
                    TextField(
                      controller: _pinController,
                      decoration: const InputDecoration(labelText: '6-digit PIN', prefixIcon: Icon(Icons.pin_outlined)),
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
                          labelText: _currentView == AuthView.forgotPasswordVerify ? 'New Password' : 'Password',
                          prefixIcon: const Icon(Icons.lock_outline_rounded)
                        ),
                        onSubmitted: (_) => _submit(),
                      ),
                    ),
                  
                  if (_currentView == AuthView.login)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => _switchView(AuthView.forgotPasswordRequest),
                        child: const Text('Forgot Password?', style: TextStyle(color: AppTheme.sageGreen)),
                      ),
                    )
                  else
                    const SizedBox(height: 24),
                  
                  if (authState.error != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        authState.error!,
                        style: TextStyle(color: Theme.of(context).colorScheme.error),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  
                  ElevatedButton(
                    onPressed: authState.isLoading ? null : _submit,
                    child: authState.isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : Text(buttonText),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  if (_currentView == AuthView.login || _currentView == AuthView.register)
                    TextButton(
                      onPressed: authState.isLoading
                          ? null
                          : () => _switchView(_currentView == AuthView.login ? AuthView.register : AuthView.login),
                      child: Text(
                        _currentView == AuthView.login ? 'Need an account? Sign up' : 'Already have an account? Log in',
                        style: const TextStyle(color: AppTheme.sageGreen),
                      ),
                    )
                  else
                    TextButton(
                      onPressed: authState.isLoading ? null : () => _switchView(AuthView.login),
                      child: const Text('Back to Login', style: TextStyle(color: AppTheme.sageGreen)),
                    ),
                    
                  const Spacer(flex: 3),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
