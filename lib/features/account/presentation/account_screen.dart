import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lpaecomms/app/state/app_state_provider.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authSession = ref.watch(appStateProvider).authSession;

    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              authSession == null
                  ? 'You are browsing anonymously.'
                  : 'Signed in as ${authSession.email}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text(
              'Use these controls to simulate authentication while wiring UI.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ref.read(appStateProvider.notifier).signIn(
                      const AuthSession(userId: 'demo-user', email: 'shopper@example.com'),
                    );
              },
              child: const Text('Mock sign-in'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => ref.read(appStateProvider.notifier).signOut(),
              child: const Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}
