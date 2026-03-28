import 'package:flutter/material.dart';
import 'package:universis/classes/info/registrationHistory/RegistrationHistoryItem.dart';
import 'package:universis/widgets/RegistrationCourseItemDesign.dart';

class RegistrationHistoryPage extends StatelessWidget {
  final List<RegistrationHistoryItem> registrationHistoryItem;
  const RegistrationHistoryPage({super.key, required this.registrationHistoryItem});

  @override Widget build(BuildContext context) {
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
          child: registrationHistoryItem.length == 0 ?  
              const Text(
                "Δεν βρέθηκε ιστορικό δηλώσεων.",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF151b1e),
                ),
              )
          :
              Column(
                 crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text(
                        "Ιστορικό Δηλώσεων",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF3e515b)
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Η παρακάτω λίστα εμφανίζει το ιστορικό των δηλώσεών σας ανά ακαδημαϊκό έτος.",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF151b1e),
                        ),
                      ),

                      const SizedBox(height: 16),
                      Expanded(child: ListView.builder(
                        itemCount: registrationHistoryItem.length,
                        itemBuilder: (context, indx) {
                          final registrationTabItem = registrationHistoryItem[indx];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(registrationTabItem.period),
                                const SizedBox(height: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: List.generate(
                                    registrationTabItem.courses.length,
                                    (index) {
                                      final course = registrationTabItem.courses[index];

                                      return RegistrationCourseItemDesign(
                                        course: course,
                                        index: index,
                                        total: registrationTabItem.courses.length,
                                      );
                                    },
                                  ),
                                )
                                

                              ],
                            ),
                          );
                        },
                      ))
                    ],
            )),
          ),
        );
  }
}