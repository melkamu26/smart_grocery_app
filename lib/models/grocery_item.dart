class GroceryItem {
  String id;
  String name;
  String category; // Produce, Dairy, etc.
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
}