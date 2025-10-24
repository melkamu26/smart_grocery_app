
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/grocery_item.dart';

const _categories = <String>[
  'Produce', 'Dairy', 'Bakery', 'Meat', 'Pantry', 'Snacks', 'Drinks', 'Other'
];

class AppState extends ChangeNotifier {
  final _uuid = const Uuid();
  final List<GroceryItem> _items = [];
  String _search = '';
  String? _filterCategory;
  bool _sortByName = true;

  List<GroceryItem> get items {
    Iterable<GroceryItem> list = _items;
    if (_search.isNotEmpty) {
      list = list.where((e) => e.name.toLowerCase().contains(_search.toLowerCase()));
    }
    if (_filterCategory != null) {
      list = list.where((e) => e.category == _filterCategory);
    }
    final out = list.toList();
    out.sort((a,b){
      if (_sortByName) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      }
      return a.category.compareTo(b.category);
    });
    return out;
  }

  List<GroceryItem> get checklist => _items;
  List<String> get categories => _categories;
  String? get filterCategory => _filterCategory;
  bool get sortByName => _sortByName;
  String get search => _search;

  void setSearch(String v) { _search = v; notifyListeners(); }
  void setFilterCategory(String? v) { _filterCategory = v; notifyListeners(); }
  void toggleSort() { _sortByName = !_sortByName; notifyListeners(); }

  void addItem({
    required String name,
    required String category,
    int quantity = 1,
    String notes = '',
    bool needToday = false,
    double? unitPrice,
  }) {
    _items.add(GroceryItem(
      id: _uuid.v4(),
      name: name,
      category: category,
      quantity: quantity,
      notes: notes,
      needToday: needToday,
      unitPrice: unitPrice,
    ));
    notifyListeners();
  }

  void updateItem(GroceryItem item) {
    final idx = _items.indexWhere((e) => e.id == item.id);
    if (idx != -1) {
      _items[idx] = item;
      notifyListeners();
    }
  }

  void deleteItem(String id) {
    _items.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void togglePurchased(String id) {
    final idx = _items.indexWhere((e) => e.id == id);
    if (idx != -1) {
      _items[idx] = _items[idx].copyWith(purchased: !_items[idx].purchased);
      notifyListeners();
    }
  }

  double estimatedTotal() {
    return _items.fold(0.0, (sum, e) {
      if (e.unitPrice != null) {
        return sum + (e.unitPrice! * (e.quantity));
      }
      return sum;
    });
  }

  // Demo weekly generator
  void generateWeekly() {
    final template = [
      {'name':'Milk','cat':'Dairy'},
      {'name':'Eggs','cat':'Dairy'},
      {'name':'Bread','cat':'Bakery'},
      {'name':'Apples','cat':'Produce'},
    ];
    for (final t in template) {
      addItem(name: t['name']!, category: t['cat']!);
    }
  }
}
