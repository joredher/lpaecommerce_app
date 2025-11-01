import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routing/app_router.dart';
import '../../../app/state/cart/cart_controller.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  int _currentStep = 0;
  final _formKeys = [GlobalKey<FormState>(), GlobalKey<FormState>()];
  String? _fullName;
  String? _address;
  String? _city;
  String? _postcode;

  @override
  Widget build(BuildContext context) {
    final cartState = ref.watch(cartControllerProvider);
    final notifier = ref.read(cartControllerProvider.notifier);

    if (cartState.cart.isEmpty) {
      return const Center(child: Text('Add items to your cart before checking out.'));
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Stepper(
        currentStep: _currentStep,
        onStepCancel: _currentStep == 0
            ? null
            : () => setState(() {
                  _currentStep -= 1;
                }),
        onStepContinue: () {
          if (_currentStep == 0) {
            final form = _formKeys[0].currentState;
            if (form?.validate() ?? false) {
              form!.save();
              setState(() => _currentStep += 1);
            }
          } else if (_currentStep == 1) {
            final form = _formKeys[1].currentState;
            if (form?.validate() ?? false) {
              form!.save();
              setState(() => _currentStep += 1);
            }
          } else {
            notifier.clearCart();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Order placed successfully!')),
            );
            if (context.mounted) {
              context.goNamed(AppRouteNames.orders);
            }
          }
        },
        controlsBuilder: (context, details) {
          final isLastStep = _currentStep == 2;
          return Row(
            children: [
              ElevatedButton(
                onPressed: details.onStepContinue,
                child: Text(isLastStep ? 'Place order' : 'Next'),
              ),
              const SizedBox(width: 12),
              if (_currentStep > 0)
                TextButton(
                  onPressed: details.onStepCancel,
                  child: const Text('Back'),
                ),
            ],
          );
        },
        steps: [
          Step(
            title: const Text('Contact'),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            content: Form(
              key: _formKeys[0],
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Full name'),
                    onSaved: (value) => _fullName = value,
                    validator: (value) => value == null || value.isEmpty ? 'Enter your name' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) =>
                        value != null && value.contains('@') ? null : 'Enter a valid email address',
                  ),
                ],
              ),
            ),
          ),
          Step(
            title: const Text('Delivery'),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            content: Form(
              key: _formKeys[1],
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Street address'),
                    onSaved: (value) => _address = value,
                    validator: (value) => value == null || value.isEmpty ? 'Enter an address' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'City'),
                    onSaved: (value) => _city = value,
                    validator: (value) => value == null || value.isEmpty ? 'Enter a city' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Postcode'),
                    onSaved: (value) => _postcode = value,
                    validator: (value) => value == null || value.length < 4 ? 'Enter a postcode' : null,
                  ),
                ],
              ),
            ),
          ),
          Step(
            title: const Text('Review'),
            isActive: _currentStep >= 2,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Name: $_fullName'),
                Text('Address: $_address, $_city $_postcode'),
                const SizedBox(height: 16),
                Text('Items: ${cartState.cart.items.length}'),
                Text('Total due: ${cartState.cart.total.toStringAsFixed(2)}'),
                if (cartState.appliedCoupon != null)
                  Text('Coupon applied: ${cartState.appliedCoupon}'),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}
