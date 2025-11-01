import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routing/app_router.dart';
import '../../../app/state/accessibility/accessibility_controller.dart';
import '../../../app/state/auth/auth_controller.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final prefs = ref.watch(accessibilityControllerProvider).valueOrNull ??
        const AccessibilityPreferences();

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 680),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'LPA eComms',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Match the familiar PHP experience with a Flutter-first storefront that respects your preferences.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 32),
                  Wrap(
                    alignment: WrapAlignment.center,
                    runSpacing: 16,
                    spacing: 16,
                    children: [
                      SizedBox(
                        width: 240,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.login),
                          onPressed: authState.isLoading
                              ? null
                              : () => context.goNamed(AppRouteNames.login),
                          label: const Text('Log on'),
                        ),
                      ),
                      SizedBox(
                        width: 240,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.shopping_bag_outlined),
                          onPressed: authState.isLoading
                              ? null
                              : () async {
                                  await ref
                                      .read(authControllerProvider.notifier)
                                      .useGuestProfile();
                                  if (context.mounted) {
                                    context.goNamed(AppRouteNames.storefrontHome);
                                  }
                                },
                          label: const Text('Go ahead'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text(
                    'Accessibility preferences',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 16,
                    runSpacing: 12,
                    children: [
                      FilterChip(
                        label: const Text('Dark mode'),
                        selected: prefs.darkMode,
                        onSelected: (_) => ref
                            .read(accessibilityControllerProvider.notifier)
                            .toggleDarkMode(),
                      ),
                      FilterChip(
                        label: const Text('High contrast'),
                        selected: prefs.highContrast,
                        onSelected: (_) => ref
                            .read(accessibilityControllerProvider.notifier)
                            .toggleHighContrast(),
                      ),
                      FilterChip(
                        label: const Text('Underline links'),
                        selected: prefs.underlineLinks,
                        onSelected: (_) => ref
                            .read(accessibilityControllerProvider.notifier)
                            .toggleUnderlineLinks(),
                      ),
                      FilterChip(
                        label: const Text('Reduce motion'),
                        selected: prefs.reduceMotion,
                        onSelected: (_) => ref
                            .read(accessibilityControllerProvider.notifier)
                            .toggleReduceMotion(),
                      ),
                      FilterChip(
                        label: const Text('Focus outline'),
                        selected: prefs.focusHighlight,
                        onSelected: (_) => ref
                            .read(accessibilityControllerProvider.notifier)
                            .toggleFocusHighlight(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Text('Text size'),
                      Expanded(
                        child: Slider(
                          value: prefs.textScale,
                          min: 0.8,
                          max: 1.6,
                          divisions: 4,
                          label: prefs.textScale.toStringAsFixed(1),
                          onChanged: (value) => ref
                              .read(accessibilityControllerProvider.notifier)
                              .updateTextScale(value),
                        ),
                      ),
                    ],
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
