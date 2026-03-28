import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:universis/classes/info/CourseStatistics.dart';

class CourseStatisticsWidget extends StatefulWidget {
  final String examPeriodId;
  final String token;
  const CourseStatisticsWidget({super.key, required this.examPeriodId, required this.token});

  @override
  State<CourseStatisticsWidget> createState() => _CourseStatisticsWidgetState();
}

class _CourseStatisticsWidgetState extends State<CourseStatisticsWidget> {
  late Future<List<CourseStatistics>> _statisticsFuture;

  @override
  void initState() {
    super.initState();
    _statisticsFuture = fetchStatistics();
  }

  Future<List<CourseStatistics>> fetchStatistics() async {
    final url =
        'https://uniapi.uop.gr/api/students/me/exams/${widget.examPeriodId}/statistics?\$top=-1&\$count=false';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => CourseStatistics.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load statistics');
    }
  }

  @override Widget build(BuildContext context) {
    return FutureBuilder<List<CourseStatistics>>(
      future: _statisticsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const SizedBox.shrink();
        if (snapshot.hasError) return const SizedBox.shrink();
        final stats = snapshot.data ?? [];
        if (stats.isEmpty) return const SizedBox.shrink();
        

        // Step 1: Create 11 buckets for grades 0–10
        List<int> gradeBuckets = List.filled(11, 0);
        final int maxTotalStudent = stats.map((e) => e.total).reduce((a, b) => a > b ? a : b);
        debugPrint(maxTotalStudent.toString());
        for (var stat in stats) {
          final grade10 = (stat.examGrade * 10).floor();
          final index = grade10.clamp(0, 10); // 0–10
          gradeBuckets[index] += stat.total;
        }

        final maxTotal = gradeBuckets.reduce((a, b) => a > b ? a : b);

        return Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Στατιστικά Εξετάσεων',
                  style: TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 16),
                SizedBox(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(11, (i) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${gradeBuckets[i]}',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          SizedBox(
                              height: 150,
                              child: LinearGauge(
                                minValue: 0,
                                maxValue: maxTotalStudent.toDouble(),
                                value: (gradeBuckets[i]/maxTotal),
                                orientation: LinearGaugeOrientation.vertical,
                                thickness: 20,
                                valueColor: Colors.indigo,
                                backgroundColor: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          const SizedBox(height: 6),
                          Text(
                            i.toString(), // 0–10 labels
                            style: const TextStyle(fontSize: 12),
                          ),
        
                        ],
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}