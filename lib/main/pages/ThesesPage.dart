import 'package:flutter/material.dart';
import 'package:universis/classes/info/Theses.dart';

class ThesesPage extends StatelessWidget {
  final List<Theses> theses;
  const ThesesPage({super.key, required this.theses});

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
          child: theses.length == 0 ?  
              const Text(
                "Δεν βρέθηκαν καταχωρημένες εργασίες.",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF151b1e),
                ),
              )
          :
          ListView.builder(
                  itemCount: theses.length,
                  itemBuilder: (context, indx) {
                    final thesis = theses[indx];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [

                          Row(children: [
                            Expanded(child:
                            Text(
                              thesis.thesesName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            )),

                            Container(
                              alignment: Alignment.center,
                              width: 60,
                              child: Text(
                                thesis.grade,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: thesis.isPassed ? Colors.green : Colors.red,
                                ),
                              ),
                            ),
                          ]),
                          Divider(color: const Color(0xFF536c79),thickness: 1,height: 25),

                          ...thesis.thesesInstructors.map((graded) {
                            return  Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Left side
                                  Expanded(
                                    child: Text(graded.name, style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight(300),
                                    ))
                                  ),

                                  // Right side (grade)
                                  Container(
                                    alignment: Alignment.center,
                                    width: 60,
                                    child: Text(
                                      graded.grade,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: thesis.isPassed ? Colors.green : Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                            );
                          }).toList(),

                        ],
                      ),
                    );
                  },
                ),
              ),
          ),
        );
  }
}