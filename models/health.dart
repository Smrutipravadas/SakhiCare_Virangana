class HealthLog {
  final int? id;
  final int mood;
  final int sleepHours;
  final int workHours;
  final String date;

  HealthLog({
    this.id,
    required this.mood,
    required this.sleepHours,
    required this.workHours,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mood': mood,
      'sleepHours': sleepHours,
      'workHours': workHours,
      'date': date,
    };
  }
}
