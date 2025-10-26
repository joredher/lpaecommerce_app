import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lpaecomms/app/routing/app_router.dart';
import 'package:lpaecomms/app/state/app_state_provider.dart';
import 'package:lpaecomms/features/account/data/auth_providers.dart';
import 'package:lpaecomms/features/account/data/auth_repository.dart';

const _gradientTop = Color(0xFF50B48F);
const _gradientBottom = Color(0xFF1C6F83);
const _accentCircleColor = Color(0xFFE85B66);
const _glassBackground = Color(0x33FFFFFF);
const _glassBorder = Color(0x40FFFFFF);
const _avatarBackground = Color(0xFF0F3E46);
const _primaryButtonColor = Color(0xFFB6E67B);
const _secondaryButtonColor = Color(0xFF9ED96D);

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);
    final authSession = appState.authSession;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [_gradientTop, _gradientBottom],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        authSession == null ? 'Login Get Code' : 'Your profile',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.4,
                            ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _GlassCard(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        child: authSession == null
                            ? _LoggedOutContent(
                                key: const ValueKey('logged-out'),
                                onContinue: () {
                                  final navigator = Navigator.of(context);
                                  if (navigator.canPop()) {
                                    navigator.pop();
                                  } else {
                                    context.goNamed(AppRouteNames.home);
                                  }
                                },
                              )
                            : _LoggedInContent(
                                key: const ValueKey('logged-in'),
                                email: authSession.email,
                                onViewOrders: () => context.pushNamed(AppRouteNames.orders),
                                onSignOut: () => ref.read(appStateProvider.notifier).signOut(),
                              ),
                      ),
                    ),
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

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
      decoration: BoxDecoration(
        color: _glassBackground,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: _glassBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _LoggedOutContent extends ConsumerStatefulWidget {
  const _LoggedOutContent({
    super.key,
    required this.onContinue,
  });

  final VoidCallback onContinue;

  @override
  ConsumerState<_LoggedOutContent> createState() => _LoggedOutContentState();
}

class _LoggedOutContentState extends ConsumerState<_LoggedOutContent> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _onFieldChanged(String _) {
    ref.read(signInControllerProvider.notifier).clearError();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();
    await ref.read(signInControllerProvider.notifier).signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  InputDecoration _buildInputDecoration(BuildContext context, String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: Colors.white.withOpacity(0.85),
        letterSpacing: 0.6,
      ),
      filled: true,
      fillColor: Colors.white.withOpacity(0.08),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: Colors.white, width: 1.6),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide(color: Colors.white.withOpacity(0.4)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.6),
      ),
    );
  }

  String? _validateEmail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return 'Email is required.';
    }
    final emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailPattern.hasMatch(text)) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final text = value ?? '';
    if (text.isEmpty) {
      return 'Password is required.';
    }
    if (text.length < 6) {
      return 'Password must be at least 6 characters.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final buttonTextStyle = textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: 0.9,
    );

    final signInState = ref.watch(signInControllerProvider);
    final isLoading = signInState.isLoading;
    final String? errorText = signInState.whenOrNull(
      error: (error, _) =>
          error is AuthException ? error.message : 'Unable to sign in. Please try again.',
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _LoginAvatar(),
        const SizedBox(height: 24),
        Text(
          'LOGIC PERIPHERALS AU',
          textAlign: TextAlign.center,
          style: textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Smarter Tech, Better Connections.',
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.white.withOpacity(0.75),
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 32),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                decoration: _buildInputDecoration(context, 'Email address'),
                validator: _validateEmail,
                onChanged: _onFieldChanged,
                onFieldSubmitted: (_) => _passwordFocusNode.requestFocus(),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                focusNode: _passwordFocusNode,
                textInputAction: TextInputAction.done,
                obscureText: true,
                decoration: _buildInputDecoration(context, 'Password'),
                validator: _validatePassword,
                onChanged: _onFieldChanged,
                onFieldSubmitted: (_) => _submit(),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isLoading ? null : _submit,
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryButtonColor,
              foregroundColor: _gradientBottom,
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: buttonTextStyle,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.2),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.4),
                  )
                : const Text('LOG ON'),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 16),
          Text(
            errorText,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
        const SizedBox(height: 18),
        TextButton(
          onPressed: widget.onContinue,
          child: Text(
            'GO AHEAD',
            style: textTheme.labelLarge?.copyWith(
              color: Colors.white,
              letterSpacing: 0.8,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextButton(
          onPressed: widget.onContinue,
          child: Text(
            'SIGN UP',
            style: textTheme.labelLarge?.copyWith(
              color: Colors.white.withOpacity(0.85),
              letterSpacing: 0.8,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}


class _LoggedInContent extends StatelessWidget {
  const _LoggedInContent({
    super.key,
    required this.email,
    required this.onViewOrders,
    required this.onSignOut,
  });

  final String email;
  final VoidCallback onViewOrders;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final labelStyle = textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: 0.9,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const _LoginAvatar(),
        const SizedBox(height: 24),
        Text(
          'Welcome back!',
          textAlign: TextAlign.center,
          style: textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          email,
          textAlign: TextAlign.center,
          style: textTheme.bodyMedium?.copyWith(
            color: Colors.white.withOpacity(0.8),
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onViewOrders,
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryButtonColor,
              foregroundColor: _gradientBottom,
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: labelStyle,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.2),
            ),
            child: const Text('VIEW ORDERS'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: onSignOut,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
              side: BorderSide(color: Colors.white.withOpacity(0.7)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: const Text('SIGN OUT'),
          ),
        ),
      ],
    );
  }
}

class _LoginAvatar extends StatelessWidget {
  const _LoginAvatar();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 108,
          height: 108,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _avatarBackground,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 24,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.memory,
              color: Colors.white,
              size: 48,
            ),
          ),
        ),
        Positioned(
          left: -14,
          top: -14,
          child: Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _accentCircleColor,
              border: Border.all(
                color: Colors.white.withOpacity(0.85),
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
