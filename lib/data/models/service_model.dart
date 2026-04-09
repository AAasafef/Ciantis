class ServiceModel {
  final String id;

  final String categoryId;
  final String name;

  final double price;
  final int duration; // minutes

  final String? notes;

  final String color; // hex color string, e.g. "#8A4FFF"

  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.duration,
    this.notes,
    required this.color,
    required this.createdAt,
    required this.updatedAt,
  });

  ServiceModel copyWith({
    String? categoryId,
    String? name,
    double? price,
    int? duration,
    String? notes,
    String? color,
    DateTime? updatedAt,
  }) {
    return ServiceModel(
      id: id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      notes: notes ?? this.notes,
      color: color ?? this.color,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      id: map['id'],
      categoryId: map['categoryId'],
      name: map['name'],
      price: (map['price'] as num).toDouble(),
      duration: map['duration'],
      notes: map['notes'],
      color: map['color'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryId': categoryId,
      'name': name,
      'price': price,
      'duration': duration,
      'notes': notes,
      'color': color,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
