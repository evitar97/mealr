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

  Map<String, Object?> toJson() {
    return {'name': name, 'checked': checked};
  }

  static ShoppingListItem? fromJson(Object? value) {
    if (value is! Map) return null;
    final name = value['name'];
    if (name is! String) return null;
    return ShoppingListItem(name: name, checked: value['checked'] == true);
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

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'items': [for (final item in items) item.toJson()],
    };
  }

  static ShoppingList? fromJson(Object? value) {
    if (value is! Map) return null;
    final id = value['id'];
    final name = value['name'];
    final createdAtRaw = value['createdAt'];
    if (id is! String || name is! String || createdAtRaw is! String) {
      return null;
    }
    final createdAt = DateTime.tryParse(createdAtRaw);
    if (createdAt == null) return null;
    final rawItems = value['items'];
    final items = rawItems is List
        ? [
            for (final item in rawItems)
              if (ShoppingListItem.fromJson(item) != null)
                ShoppingListItem.fromJson(item)!,
          ]
        : <ShoppingListItem>[];
    return ShoppingList(id: id, name: name, createdAt: createdAt, items: items);
  }
}
