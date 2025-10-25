import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';

class WeeklyGeneratorScreen extends StatelessWidget {
  static const route = '/weekly';
  const WeeklyGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final list = context.watch<AppState>().items;
    return Scaffold(
      appBar: AppBar(title: const Text('Weekly List Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Generate a recurring weekly list from a template.'),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => context.read<AppState>().generateWeekly(),
              icon: const Icon(Icons.bolt),
              label: const Text('Generate List'),
            ),
            
            const SizedBox(height: 16),
            const Text('Preview (current list):'),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: app.items.length,
                itemBuilder: (_, i) {
                  final it = app.items[i];
                  return ListTile(
                    title: Text(it.name),
                    subtitle: Text('${it.category} • qty ${it.quantity}'),
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Estimated Total: \$${app.estimatedTotal().toStringAsFixed(2)}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}