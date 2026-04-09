class ServiceCategoryModel {
  final String id;

  final String name;
  final String? description;

  final String color; // hex color string, e.g. "#8A4FFF"
  final int sortOrder;

  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceCategoryModel({
    required this.id,
    required this.name,
    this.description,
    required this.color,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });

  ServiceCategoryModel copyWith({
    String? name,
    String? description,
    String? color,
    int? sortOrder,
    DateTime? updatedAt,
  }) {
    return ServiceCategoryModel(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      color: color ?? this.color,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory ServiceCategoryModel.fromMap(Map<String, dynamic> map) {
    return ServiceCategoryModel(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      color: map['color'],
      sortOrder: map['sortOrder'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'color': color,
      'sortOrder': sortOrder,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
