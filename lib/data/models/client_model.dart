class ClientModel {
  final String id;

  final String name;
  final String? phone;
  final String? email;

  final String? notes;
  final String? preferredServices;

  final DateTime? lastAppointment;
  final int totalVisits;

  final int rankingScore; // AI-generated: loyalty, frequency, recency

  final DateTime createdAt;
  final DateTime updatedAt;

  ClientModel({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.notes,
    this.preferredServices,
    this.lastAppointment,
    required this.totalVisits,
    required this.rankingScore,
    required this.createdAt,
    required this.updatedAt,
  });

  ClientModel copyWith({
    String? name,
    String? phone,
    String? email,
    String? notes,
    String? preferredServices,
    DateTime? lastAppointment,
    int? totalVisits,
    int? rankingScore,
    DateTime? updatedAt,
  }) {
    return ClientModel(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      notes: notes ?? this.notes,
      preferredServices: preferredServices ?? this.preferredServices,
      lastAppointment: lastAppointment ?? this.lastAppointment,
      totalVisits: totalVisits ?? this.totalVisits,
      rankingScore: rankingScore ?? this.rankingScore,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory ClientModel.fromMap(Map<String, dynamic> map) {
    return ClientModel(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      notes: map['notes'],
      preferredServices: map['preferredServices'],
      lastAppointment: map['lastAppointment'] != null
          ? DateTime.parse(map['lastAppointment'])
          : null,
      totalVisits: map['totalVisits'],
      rankingScore: map['rankingScore'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'notes': notes,
      'preferredServices': preferredServices,
      'lastAppointment': lastAppointment?.toIso8601String(),
      'totalVisits': totalVisits,
      'rankingScore': rankingScore,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
