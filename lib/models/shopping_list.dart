class ShoppingListItem {
  const ShoppingListItem({required this.name, this.checked = false});

  final String name;
  final bool checked;

  ShoppingListItem copyWith({String? name, bool? checked}) {
    return ShoppingListItem(
      name: name ?? this.name,
      checked: checked ?? this.checked,
    );
  }
}

class ShoppingList {
  const ShoppingList({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.items,
  });

  final String id;
  final String name;
  final DateTime createdAt;
  final List<ShoppingListItem> items;

  ShoppingList copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    List<ShoppingListItem>? items,
  }) {
    return ShoppingList(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      items: items ?? this.items,
    );
  }
}
