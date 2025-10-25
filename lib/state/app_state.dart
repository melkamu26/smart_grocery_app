import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/grocery_item.dart';

const _categories = <String>[
  'Produce', 'Dairy', 'Bakery', 'Meat', 'Pantry', 'Snacks', 'Drinks', 'Other'
];

class AppState extends ChangeNotifier {
  final _uuid = const Uuid();
  final List<GroceryItem> _items = [];

  // UI state
  String _search = '';
  String? _filterCategory;
  bool _sortByName = true;

  // Load saved data on startup
  AppState() {
    _loadItems();
  }

  // Unfiltered raw list (for checklist/preview/estimates)
  List<GroceryItem> get items => List.unmodifiable(_items);

  // Filtered view (for Home)
  List<GroceryItem> get filteredItems {
    Iterable<GroceryItem> list = _items;
    if (_search.isNotEmpty) {
      final q = _search.toLowerCase();
      list = list.where((e) => e.name.toLowerCase().contains(q));
    }
    if (_filterCategory != null) {
      list = list.where((e) => e.category == _filterCategory);
    }
    final out = list.toList();
    out.sort((a, b) {
      if (_sortByName) {
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      }
      return a.category.compareTo(b.category);
    });
    return out;
  }

  // Getters
  List<GroceryItem> get checklist => _items;
  List<String> get categories => _categories;
  String? get filterCategory => _filterCategory;
  bool get sortByName => _sortByName;
  String get search => _search;

  // UI controls
  void setSearch(String v) {
    _search = v;
    notifyListeners();
  }

  void setFilterCategory(String? v) {
    _filterCategory = v;
    notifyListeners();
  }

  void clearFilters() {
    _search = '';
    _filterCategory = null;
    notifyListeners();
  }

  void toggleSort() {
    _sortByName = !_sortByName;
    notifyListeners();
  }

  // CRUD (all persisted)
  Future<void> addItem({
    required String name,
    required String category,
    int quantity = 1,
    String notes = '',
    bool needToday = false,
    double? unitPrice,
  }) async {
    _items.add(GroceryItem(
      id: _uuid.v4(),
      name: name,
      category: category,
      quantity: quantity,
      notes: notes,
      needToday: needToday,
      unitPrice: unitPrice,
    ));
    await _saveItems();
    notifyListeners();
  }

  Future<void> updateItem(GroceryItem item) async {
    final idx = _items.indexWhere((e) => e.id == item.id);
    if (idx != -1) {
      _items[idx] = item;
      await _saveItems();
      notifyListeners();
    }
  }

  Future<void> deleteItem(String id) async {
    _items.removeWhere((e) => e.id == id);
    await _saveItems();
    notifyListeners();
  }

  Future<void> togglePurchased(String id) async {
    final idx = _items.indexWhere((e) => e.id == id);
    if (idx != -1) {
      _items[idx] = _items[idx].copyWith(purchased: !_items[idx].purchased);
      await _saveItems();
      notifyListeners();
    }
  }

  double estimatedTotal() {
    return _items.fold(0.0, (sum, e) {
      if (e.unitPrice != null) return sum + e.unitPrice! * e.quantity;
      return sum;
    });
  }

  Future<void> generateWeekly() async {
    final template = [
      {'name': 'Milk', 'cat': 'Dairy'},
      {'name': 'Eggs', 'cat': 'Dairy'},
      {'name': 'Bread', 'cat': 'Bakery'},
      {'name': 'Apples', 'cat': 'Produce'},
    ];
    for (final t in template) {
      _items.add(GroceryItem(
        id: _uuid.v4(),
        name: t['name']!,
        category: t['cat']!,
      ));
    }
    await _saveItems();
    notifyListeners();
  }

  // persistence helpers
  static const _kItemsKey = 'sgl_items';

  Future<void> _saveItems() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final data = _items.map((e) => e.toJson()).toList();
      await sp.setString(_kItemsKey, jsonEncode(data));
      if (kDebugMode) {
        print('✅ Saved ${_items.length} items to local storage');
      }
    } catch (e) {
      if (kDebugMode) print('❌ Save failed: $e');
    }
  }

  Future<void> _loadItems() async {
    try {
      final sp = await SharedPreferences.getInstance();
      final raw = sp.getString(_kItemsKey);
      if (raw != null && raw.isNotEmpty) {
        final list = (jsonDecode(raw) as List)
            .cast<Map<String, dynamic>>()
            .map(GroceryItem.fromJson)
            .toList();
        _items
          ..clear()
          ..addAll(list);
        if (kDebugMode) {
          print('📦 Loaded ${_items.length} items from local storage');
        }
        notifyListeners();
      } else {
        if (kDebugMode) print('📭 No saved data found.');
      }
    } catch (e) {
      if (kDebugMode) print('⚠️ Load failed: $e');
    }
  }
}