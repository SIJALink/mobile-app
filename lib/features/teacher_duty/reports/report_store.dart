
class ReportStore {
  static final List<Map<String, dynamic>> reports = [];

  static void addReport({
    required DateTime date,
    required String teacher,
    required String activity,
    required String obstacle,
    required String followUp,
  }) {
    reports.insert(0, {
      'date': date,
      'teacher': teacher,
      'activity': activity,
      'obstacle': obstacle,
      'followUp': followUp,
      'createdAt': DateTime.now(),
    });
  }
}
