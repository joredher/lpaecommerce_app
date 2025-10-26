import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lpaecomms/app/routing/app_router.dart';
import 'package:lpaecomms/app/state/app_state_provider.dart';

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
                                onLogOn: () => ref.read(appStateProvider.notifier).signIn(
                                      const AuthSession(
                                        userId: 'demo-user',
                                        email: 'shopper@example.com',
                                      ),
                                    ),
                                onContinue: () => context.goNamed(AppRouteNames.home),
                              )
                            : _LoggedInContent(
                                key: const ValueKey('logged-in'),
                                email: authSession.email,
                                onViewOrders: () => context.goNamed(AppRouteNames.orders),
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

class _LoggedOutContent extends StatelessWidget {
  const _LoggedOutContent({
    super.key,
    required this.onLogOn,
    required this.onContinue,
  });

  final VoidCallback onLogOn;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final buttonTextStyle = textTheme.labelLarge?.copyWith(
      fontWeight: FontWeight.w700,
      letterSpacing: 0.9,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
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
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: onLogOn,
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
                child: const Text('LOG ON'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: onContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _secondaryButtonColor,
                  foregroundColor: _gradientBottom,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  textStyle: buttonTextStyle,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 4,
                  shadowColor: Colors.black.withOpacity(0.2),
                ),
                child: const Text('GO AHEAD'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        TextButton(
          onPressed: onContinue,
          child: Text(
            'SIGN UP',
            style: textTheme.labelLarge?.copyWith(
              color: Colors.white,
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
