import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/state/admin/admin_dashboard_controller.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(adminDashboardControllerProvider);
    final controller = ref.read(adminDashboardControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin workspace'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.hydrate,
          ),
        ],
      ),
      body: dashboardState.isLoading && dashboardState.metrics == null
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: controller.hydrate,
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  if (dashboardState.metrics != null)
                    _MetricsGrid(metrics: dashboardState.metrics!),
                  const SizedBox(height: 24),
                  Text('Low stock alerts', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  ...dashboardState.products
                      .where((product) => product.inventory < 20)
                      .map(
                        (product) => Card(
                          child: ListTile(
                            leading: const Icon(Icons.inventory_2_outlined),
                            title: Text(product.name),
                            subtitle: Text('Inventory: ${product.inventory}'),
                          ),
                        ),
                      ),
                  const SizedBox(height: 24),
                  Text('Recent orders', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  ...dashboardState.orders.take(5).map(
                        (order) => Card(
                          child: ListTile(
                            leading: const Icon(Icons.receipt_long_outlined),
                            title: Text(order.number),
                            subtitle: Text('Status: ${order.status.name}'),
                            trailing: Text(order.cart.total.toStringAsFixed(2)),
                          ),
                        ),
                      ),
                  const SizedBox(height: 24),
                  Text('Support tickets', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  ...dashboardState.tickets.take(5).map(
                        (ticket) => Card(
                          child: ListTile(
                            leading: const Icon(Icons.support_agent_outlined),
                            title: Text(ticket.subject),
                            subtitle: Text('${ticket.reference} · ${ticket.status.name}'),
                          ),
                        ),
                      ),
                ],
              ),
            ),
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.metrics});

  final DashboardMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 960
            ? 4
            : constraints.maxWidth > 600
                ? 2
                : 1;
        final cards = [
          _MetricCard(label: 'Revenue', value: metrics.totalRevenue.toStringAsFixed(2)),
          _MetricCard(label: 'Active customers', value: metrics.activeCustomers.toString()),
          _MetricCard(label: 'Pending orders', value: metrics.pendingOrders.toString()),
          _MetricCard(label: 'Low stock products', value: metrics.lowStockCount.toString()),
        ];
        return GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 3,
          children: cards,
        );
      },
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
          ],
        ),
      ),
    );
  }
}
