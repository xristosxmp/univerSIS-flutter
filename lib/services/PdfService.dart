import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:universis/classes/Student.dart';
import 'package:universis/classes/info/Semester.dart';
import 'package:open_filex/open_filex.dart';

class PdfService {
  static Future<File> generateGradesPdf(final List<Semester> semesters, final Student student) async {
    final pdf = pw.Document();
    final plainFont = await rootBundle.load("assets/fonts/ARIAL.TTF");
    final ttf = pw.Font.ttf(plainFont);
    final boldFont = await rootBundle.load("assets/fonts/ARIALBD.TTF");
    final boldTtf = pw.Font.ttf(boldFont);
    final theme = pw.ThemeData.withFont(base: ttf, bold: boldTtf);

    final imageData = await rootBundle.load('assets/pdf/logo-uop.png');
    final image = pw.MemoryImage(imageData.buffer.asUint8List());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: theme,
        margin: const pw.EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
        build: (context) => [

          pw.Center(child: pw.Image(image,width: 200,fit: pw.BoxFit.contain)),
          pw.SizedBox(height: 8),
          pw.Center(child: pw.Text(student.department.school,style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold))),
          pw.Center(child: pw.Text(student.department.departmentName,style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold))),



          pw.SizedBox(height: 24),
          pw.Center(child:pw.Text(student.name,style: pw.TextStyle(fontSize: 12,fontWeight: pw.FontWeight.normal))),
          pw.Center(child:pw.Text(student.studentIdentifier,style: pw.TextStyle(fontSize: 9,fontWeight: pw.FontWeight.normal))),

          pw.SizedBox(height: 24),
          pw.Center(child:pw.Text('ΑΝΑΛΥΤΙΚΗ ΒΑΘΜΟΛΟΓΙΑ',style: pw.TextStyle(fontSize: 14,fontWeight: pw.FontWeight.bold))),
          pw.SizedBox(height: 24),
          ...semesters.map((semester) => _buildSemester(semester)),


        
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final pdfDir = Directory('${dir.path}/pdfs');
    if (!await pdfDir.exists()) await pdfDir.create(recursive: true);
    final file = File('${pdfDir.path}/grades.pdf');
    await file.writeAsBytes(await pdf.save(), flush: true);
    return file;
  }


  static pw.Widget _buildSemester(final Semester semester) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 12),

        // Semester header
        pw.Text('${semester.name} ${semester.averageGrade.isEmpty || semester.averageGrade.trim().contains("-") ? '' : '(Μέσος Όρος: ${semester.averageGrade})'}',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 12)),
        pw.SizedBox(height: 8),

        // Table
        pw.Table.fromTextArray(
          border: null,
          headers: const [
            'Τίτλος Μαθήματος',
            'Κωδικός',
            'Εξάμηνο',
            'ECTS',
            'Βαθμός',
            'Εξεταστική'
          ],
          headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 9),
          cellStyle: const pw.TextStyle(fontSize: 9),
          headerAlignment: pw.Alignment.centerLeft,
          cellAlignment: pw.Alignment.centerLeft,
          columnWidths: const {
            0: pw.FractionColumnWidth(0.3), 
            1: pw.FractionColumnWidth(0.14), 
            2: pw.FractionColumnWidth(0.14), 
            3: pw.FractionColumnWidth(0.14),  
            4: pw.FractionColumnWidth(0.14),  
            5: pw.FractionColumnWidth(0.14), 
          },
          cellPadding: const pw.EdgeInsets.symmetric(vertical: 1,horizontal: 1),
          data: semester.courses.map((course) {
            return [
              pw.Text(course.title.toUpperCase(),style: const pw.TextStyle(fontSize: 7), softWrap: true),
              pw.Text(course.code, style: const pw.TextStyle(fontSize: 7)),
              pw.Text(semester.name, style: const pw.TextStyle(fontSize: 7)),
              pw.Text(course.ects.toString(), style: const pw.TextStyle(fontSize: 7)),
              pw.Text(course.grade.toString(), style: const pw.TextStyle(fontSize: 7)),
              pw.Text(course.gradePeriod, style: const pw.TextStyle(fontSize: 7)),
            ];
          }).toList(),
        ),
      ],
    );
  }

  static Future<void> openFile(final File file) async {
    await OpenFilex.open(file.path);
  }
}