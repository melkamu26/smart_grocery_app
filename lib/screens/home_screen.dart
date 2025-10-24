
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../widgets/item_tile.dart';
import 'add_edit_screen.dart';
import 'checklist_screen.dart';
import 'weekly_generator_screen.dart';
import '../state/theme_provider.dart'; 

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    final items = app.items;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Grocery List'),
        actions: [
          IconButton(
            tooltip: app.sortByName ? 'Sort by Category' : 'Sort by Name',
            onPressed: app.toggleSort,
            icon: const Icon(Icons.sort),
          ),
          IconButton(
            tooltip: 'Checklist',
            onPressed: () => Navigator.pushNamed(context, ChecklistScreen.route),
            icon: const Icon(Icons.checklist),
          ),
          IconButton(
            tooltip: 'Weekly Generator',
            onPressed: () => Navigator.pushNamed(context, WeeklyGeneratorScreen.route),
            icon: const Icon(Icons.calendar_month),
          ),
          IconButton(
  tooltip: 'Toggle Theme',
  icon: Icon(
    context.watch<ThemeProvider>().isDarkMode
        ? Icons.light_mode
        : Icons.dark_mode,
  ),
  onPressed: () {
    final themeProvider = context.read<ThemeProvider>();
    themeProvider.toggleTheme(!themeProvider.isDarkMode);
  },
),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: app.setSearch,
              decoration: InputDecoration(
                hintText: 'Search items...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                DropdownButton<String?>(
                  value: app.filterCategory,
                  hint: const Text('Filter: All'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('All')),
                    ...app.categories.map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  ],
                  onChanged: (v) => app.setFilterCategory(v),
                ),
                const Spacer(),
                Text('Total est: \$${app.estimatedTotal().toStringAsFixed(2)}'),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: items.isEmpty
              ? const Center(child: Text('Your list is empty. Tap + to add items.'))
              : ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (_, i) => ItemTile(item: items[i]),
                ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AddEditScreen.route),
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
      ),
    );
  }
}
