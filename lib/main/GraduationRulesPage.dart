import 'package:flutter/material.dart';
import 'package:linear_progress_bar/linear_progress_bar.dart';
import 'package:universis/classes/info/GraduationRule.dart';

class GraduationRulesPage extends StatelessWidget {
  final List<GraduationRule> graduationRules;

  const GraduationRulesPage({super.key,required this.graduationRules});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Your top texts
              const Text(
                "Πτυχίο",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF3e515b)
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "Για περισσότερες πληροφορίες σχετικά με τις προϋποθέσεις πτυχίου μπορείτε να δείτε τον οδηγό σπουδών ή να επικοινωνήσετε με την Γραμματεία.",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF151b1e),
                ),
              ),

              const SizedBox(height: 16),

              // 🔹 Your list
              Expanded(
                child: ListView.builder(
                  itemCount: graduationRules.length,
                  itemBuilder: (context, semIndex) {
                    final rule = graduationRules[semIndex];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          CircularPercentIndicator(
                            percent: 1,
                            radius: 40,
                            lineWidth: 6,
                            progressColor: rule.success == true
                                ? const Color(0xFF4dbd74)
                                : const Color(0xFFf86c6b),
                            backgroundColor: Colors.transparent,
                            circularStrokeCap: CircularStrokeCap.round,
                            startAngle: CircularStartAngle.bottom,
                            arcType: ArcType.full,
                            center: Text(
                              "${rule.result}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: rule.success == true
                                    ? const Color(0xFF4dbd74)
                                    : const Color(0xFFf86c6b),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              rule.message,
                              softWrap: true,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}