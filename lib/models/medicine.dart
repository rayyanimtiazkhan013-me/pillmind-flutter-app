class Medicine {
  final int? id;
  final String name;
  final String dosage;
  final String time;
  final int totalPills;
  final int threshold;

  Medicine({
    this.id,
    required this.name,
    required this.dosage,
    required this.time,
    required this.totalPills,
    required this.threshold,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'time': time,
      'totalPills': totalPills,
      'threshold': threshold,
    };
  }

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'],
      name: map['name'],
      dosage: map['dosage'],
      time: map['time'],
      totalPills: map['totalPills'],
      threshold: map['threshold'],
    );
  }
}
