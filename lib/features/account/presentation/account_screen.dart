import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/state/accessibility/accessibility_controller.dart';
import '../../../app/state/auth/auth_controller.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final prefs = ref.watch(accessibilityControllerProvider).valueOrNull ??
        const AccessibilityPreferences();

    if (!authState.isAuthenticated) {
      return const Center(child: Text('Log on to access your account.'));
    }

    final profile = authState.session!.profile;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 32,
                child: Text(profile.displayName.substring(0, 1).toUpperCase()),
              ),
              title: Text(profile.displayName, style: Theme.of(context).textTheme.titleLarge),
              subtitle: Text(profile.email),
              trailing: Chip(
                label: Text(profile.role.name.toUpperCase()),
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Accessibility preferences',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 8,
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
            const SizedBox(height: 24),
            if (!profile.isVerified)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email verification',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () => ref
                            .read(authControllerProvider.notifier)
                            .sendVerificationEmail(),
                        child: const Text('Resend verification email'),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Enter 6-digit code',
                          hintText: '123456',
                        ),
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                        onSubmitted: (code) => ref
                            .read(authControllerProvider.notifier)
                            .verifyEmail(code: code),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => ref.read(authControllerProvider.notifier).logout(),
              icon: const Icon(Icons.logout),
              label: const Text('Sign out'),
            ),
          ],
        ),
    );
  }
}
