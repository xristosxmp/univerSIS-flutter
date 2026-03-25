import 'package:flutter/material.dart';
import 'package:universis/classes/info/Semester.dart';
import 'package:universis/services/PdfService.dart';

class GeneratePdfButton extends StatelessWidget {
  final List<Semester> semesters;

  const GeneratePdfButton({super.key,required this.semesters});

  @override Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
              side: const BorderSide(
              color: Color.fromARGB(255, 204, 204, 205),
              width: 1,
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: () async {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );

          final file = await PdfService.generateGradesPdf(semesters);

          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 10),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 40),
              padding: EdgeInsets.zero,
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Center(
                          child: Text(
                            "Το PDF δημιουργήθηκε επιτυχώς",
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: TextButton(
                            onPressed: () {
                              PdfService.openFile(file);
                            },
                            child: const Text("Ανοιγμα αρχειου PDF"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      splashRadius: 20,
                      onPressed: () {
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        child: const Text(
          "Εκτύπωση Αναλυτικής",
          style: TextStyle(
            color: Color(0xFF151B1E),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}