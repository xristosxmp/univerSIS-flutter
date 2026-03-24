import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:universis/classes/info/Semester.dart';
import 'package:open_filex/open_filex.dart';

class PdfService {
  static Future<File> generateGradesPdf(final List<Semester> semesters) async {
    final pdf = pw.Document();

    // 🔤 Load Arial font
    final fontData = await rootBundle.load("assets/fonts/ARIAL.TTF");
    final ttf = pw.Font.ttf(fontData);

    // (Optional but recommended for bold)
    final boldFontData = await rootBundle.load("assets/fonts/ARIAL.TTF");
    final boldTtf = pw.Font.ttf(boldFontData);

    final theme = pw.ThemeData.withFont(
      base: ttf,
      bold: boldTtf,
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: theme, // 🔥 Apply font globally

        build: (context) => [
          pw.Text(
            'Αναλυτική Βαθμολογία',
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 16),

          ...semesters.map((semester) => _buildSemester(semester)),
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();

    final pdfDir = Directory('${dir.path}/pdfs');
    if (!await pdfDir.exists()) {
      await pdfDir.create(recursive: true);
    }

    final file = File('${pdfDir.path}/grades.pdf');
    await file.writeAsBytes(await pdf.save(), flush: true);

    return file;
  }

  static pw.Widget _buildSemester(Semester semester) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 12),

        pw.Text(
          '${semester.name} (Μ.Ο: ${semester.averageGrade})',
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
          ),
        ),

        pw.SizedBox(height: 8),

        pw.Table.fromTextArray(
          headers: ['Code', 'Μάθημα', 'Βαθμός', 'ECTS'],

          headerStyle: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
          ),

          data: semester.courses.map((course) {
            return [
              course.code,
              course.title,
              course.grade,
              course.ects,
            ];
          }).toList(),
        ),
      ],
    );
  }

  static Future<void> openFile(File file) async {
    await OpenFilex.open(file.path);
  }
}