import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/state/auth/auth_controller.dart';

class SupportCenterScreen extends ConsumerWidget {
  const SupportCenterScreen({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Support centre',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Reach out via email, phone or live chat. Our admin workspace mirrors PHP ticket routing.',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 16),
        ListTile(
          leading: const Icon(Icons.mail_outline),
          title: const Text('Email'),
          subtitle: const Text('support@lpa.test'),
          trailing: IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Email copied to clipboard')),
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.phone_outlined),
          title: const Text('Phone'),
          subtitle: const Text('+61 2 1234 5678'),
        ),
        ListTile(
          leading: const Icon(Icons.confirmation_number_outlined),
          title: const Text('Open a ticket'),
          subtitle: Text(authState.isAuthenticated
              ? 'Submit and track responses from the admin console.'
              : 'Log on for tailored follow-up and SLA tracking.'),
        ),
      ],
    );

    if (compact) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: content,
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: content,
    );
  }
}
