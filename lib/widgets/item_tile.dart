import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/grocery_item.dart';
import '../state/app_state.dart';
import '../screens/add_edit_screen.dart';
import '../theme/app_theme.dart';

class ItemTile extends StatelessWidget {
  final GroceryItem item;
  const ItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    return ListTile(
      leading: Checkbox(
        value: item.purchased,
        onChanged: (_) => app.togglePurchased(item.id),
      ),
      title: Row(
        children: [
          if (item.needToday)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Icon(Icons.priority_high,
                  size: 18, color: AppTheme.priorityColor(context)),
            ),
          Expanded(
            child: Text(
              item.name,
              style: TextStyle(
                decoration: item.purchased ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ],
      ),
      subtitle: Text(
        '${item.category} • qty ${item.quantity}'
        '${item.notes.isNotEmpty ? " • ${item.notes}" : ""}',
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          switch (value) {
            case 'edit':
              Navigator.pushNamed(
                context,
                AddEditScreen.route,
                arguments: item,
              );
              break;
            case 'delete':
              app.deleteItem(item.id);
              break;
          }
        },
        itemBuilder: (context) => const [
          PopupMenuItem(value: 'edit', child: Text('Edit')),
          PopupMenuItem(value: 'delete', child: Text('Delete')),
        ],
      ),
      onTap: () => app.togglePurchased(item.id),
    );
  }
}