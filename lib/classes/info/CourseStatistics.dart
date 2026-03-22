class CourseStatistics {
  final double examGrade;
  final bool isPassed;
  final int total;

  CourseStatistics({
    required this.examGrade,
    required this.isPassed,
    required this.total,
  });

  factory CourseStatistics.fromJson(Map<String, dynamic> json) {
    return CourseStatistics(
      examGrade: (json['examGrade'] as num).toDouble(),
      isPassed: json['isPassed'] == 1,
      total: json['total'] as int,
    );
  }
}