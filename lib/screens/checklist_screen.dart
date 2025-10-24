import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class ChecklistScreen extends StatelessWidget {
  static const route = '/checklist';
  const ChecklistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final items = app.checklist;
    final purchasedCount = items.where((e) => e.purchased).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Checklist')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Text('Purchased: $purchasedCount / ${items.length}'),
                const Spacer(),
                Text('Est: \$${app.estimatedTotal().toStringAsFixed(2)}'),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (_, i) {
                final it = items[i];
                return CheckboxListTile(
                  title: Text(it.name),
                  subtitle: Text('${it.category} • qty ${it.quantity}'),
                  value: it.purchased,
                  onChanged: (_) => app.togglePurchased(it.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}