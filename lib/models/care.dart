class CareCircle {
  final int? id;
  final String name;
  final String phone;
  final String relationship;

  CareCircle({
    this.id,
    required this.name,
    required this.phone,
    required this.relationship,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'relationship': relationship,
    };
  }
}
