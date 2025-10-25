class GroceryItem {
  String id;
  String name;
  String category;
  int quantity;
  String notes;
  bool purchased;
  bool needToday;
  double? unitPrice;

  GroceryItem({
    required this.id,
    required this.name,
    required this.category,
    this.quantity = 1,
    this.notes = '',
    this.purchased = false,
    this.needToday = false,
    this.unitPrice,
  });

  GroceryItem copyWith({
    String? id,
    String? name,
    String? category,
    int? quantity,
    String? notes,
    bool? purchased,
    bool? needToday,
    double? unitPrice,
  }) {
    return GroceryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
      purchased: purchased ?? this.purchased,
      needToday: needToday ?? this.needToday,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'quantity': quantity,
    'notes': notes,
    'purchased': purchased,
    'needToday': needToday,
    'unitPrice': unitPrice,
  };

  factory GroceryItem.fromJson(Map<String, dynamic> j) => GroceryItem(
    id: j['id'] as String,
    name: j['name'] as String,
    category: j['category'] as String,
    quantity: (j['quantity'] ?? 1) as int,
    notes: (j['notes'] ?? '') as String,
    purchased: (j['purchased'] ?? false) as bool,
    needToday: (j['needToday'] ?? false) as bool,
    unitPrice: (j['unitPrice'] as num?)?.toDouble(),
  );
}