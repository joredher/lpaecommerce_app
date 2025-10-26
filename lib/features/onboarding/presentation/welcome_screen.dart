import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:lpaecomms/app/data/preferences/preferences_providers.dart';
import 'package:lpaecomms/app/routing/app_router.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingStateProvider);
    final onboardingNotifier = ref.read(onboardingStateProvider.notifier);
    final isProcessing = onboardingState.isLoading;

    Future<void> completeAndNavigate(String routeName) async {
      try {
        await onboardingNotifier.completeOnboarding();
        if (context.mounted) {
          context.goNamed(routeName);
        }
      } catch (error, stackTrace) {
        FlutterError.reportError(FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'onboarding',
          context: ErrorDescription('while completing onboarding'),
        ));
        if (!context.mounted) {
          return;
        }
        const message = 'No pudimos continuar. Intenta nuevamente.';
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(message)),
        );
      }
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF4EB590),
              Color(0xFF35998F),
              Color(0xFF357C82),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _WelcomeLogo(),
                  const SizedBox(height: 32),
                  Text(
                    'LOGIC PERIPHERALS AU',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Smarter Tech, Better Connections.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  if (isProcessing) ...[
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB6E67B)),
                    ),
                    const SizedBox(height: 24),
                  ],
                  Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    alignment: WrapAlignment.center,
                    children: [
                      _WelcomeButton(
                        label: 'LOG ON',
                        onPressed: isProcessing
                            ? null
                            : () => completeAndNavigate(AppRouteNames.profile),
                      ),
                      _WelcomeButton(
                        label: 'GO AHEAD',
                        onPressed: isProcessing
                            ? null
                            : () => completeAndNavigate(AppRouteNames.catalog),
                      ),
                    ],
                  ),
                  if (onboardingState.hasError) ...[
                    const SizedBox(height: 16),
                    Text(
                      'Ocurrió un problema al guardar tu progreso.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WelcomeLogo extends StatelessWidget {
  const _WelcomeLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
      ),
      child: Center(
        child: Container(
          width: 96,
          height: 96,
          decoration: const BoxDecoration(
            color: Color(0xFF1F6A6A),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.memory,
            color: Colors.white,
            size: 48,
          ),
        ),
      ),
    );
  }
}

class _WelcomeButton extends StatelessWidget {
  const _WelcomeButton({
    required this.label,
    required this.onPressed,
    super.key,
  });

  final String label;
  final Future<void> Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFB6E67B),
          foregroundColor: const Color(0xFF003459),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 6,
        ),
        onPressed: onPressed == null
            ? null
            : () async {
                await onPressed!.call();
              },
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
