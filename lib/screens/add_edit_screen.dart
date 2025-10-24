
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/grocery_item.dart';
import '../state/app_state.dart';

class AddEditScreen extends StatefulWidget {
  static const route = '/add';
  const AddEditScreen({super.key});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _category = 'Produce';
  int _quantity = 1;
  String _notes = '';
  bool _needToday = false;
  double? _unitPrice;
  GroceryItem? editing;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)!.settings.arguments;
    if (arg is GroceryItem && editing == null) {
      editing = arg;
      _name = arg.name;
      _category = arg.category;
      _quantity = arg.quantity;
      _notes = arg.notes;
      _needToday = arg.needToday;
      _unitPrice = arg.unitPrice;
    }
  }

  @override
  Widget build(BuildContext context) {
    final app = context.read<AppState>();
    final isEditing = editing != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Item' : 'Add Item')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              initialValue: _name,
              decoration: const InputDecoration(labelText: 'Name *'),
              validator: (v) => (v==null || v.trim().isEmpty) ? 'Name required' : null,
              onSaved: (v) => _name = v!.trim(),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _category,
                    items: app.categories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => _category = v!),
                    decoration: const InputDecoration(labelText: 'Category'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    initialValue: _quantity.toString(),
                    decoration: const InputDecoration(labelText: 'Qty'),
                    keyboardType: TextInputType.number,
                    onSaved: (v) => _quantity = int.tryParse(v ?? '1') ?? 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: _notes,
              decoration: const InputDecoration(labelText: 'Notes'),
              onSaved: (v) => _notes = v ?? '',
            ),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: _unitPrice?.toString() ?? '',
              decoration: const InputDecoration(labelText: 'Unit Price (optional)'),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onSaved: (v) => _unitPrice = (v==null || v.isEmpty) ? null : double.tryParse(v),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              value: _needToday,
              onChanged: (v) => setState(()=> _needToday = v),
              title: const Text('Need Today (priority)'),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  if (isEditing) {
                    app.updateItem(editing!.copyWith(
                      name: _name,
                      category: _category,
                      quantity: _quantity,
                      notes: _notes,
                      needToday: _needToday,
                      unitPrice: _unitPrice,
                    ));
                  } else {
                    app.addItem(
                      name: _name,
                      category: _category,
                      quantity: _quantity,
                      notes: _notes,
                      needToday: _needToday,
                      unitPrice: _unitPrice,
                    );
                  }
                  Navigator.pop(context);
                }
              },
              icon: const Icon(Icons.save),
              label: Text(isEditing ? 'Save Changes' : 'Save Item'),
            )
          ],
        ),
      ),
    );
  }
}
