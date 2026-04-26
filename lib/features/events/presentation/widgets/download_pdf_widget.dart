import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;

class DownloadPdfWidget {
  static Future<Uint8List> generatePdf(List<Map<String, dynamic>> tickets) async {
    final pdf = pw.Document();

    // Load custom fonts (make sure these are in your assets folder and pubspec.yaml)
    final regularFont = await PdfGoogleFonts.robotoRegular();
    final boldFont = await PdfGoogleFonts.robotoBold();

    for (var ticket in tickets) {
      final qrCode = await _generateQrCode("TicketID: ${ticket['id']}");

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (context) => pw.Center(
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Image(pw.MemoryImage(qrCode), width: 200, height: 200),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Event Ticket',
                  style: pw.TextStyle(fontSize: 24, font: boldFont),
                ),
                pw.SizedBox(height: 10),
                pw.Text('Name: ${ticket['name']}', style: pw.TextStyle(font: regularFont)),
                pw.Text('Age: ${ticket['age']}', style: pw.TextStyle(font: regularFont)),
                pw.Text('Gender: ${ticket['gender']}', style: pw.TextStyle(font: regularFont)),
                pw.Text('Date: ${ticket['date']}', style: pw.TextStyle(font: regularFont)),
                pw.Text('Venue: ${ticket['venue']}', style: pw.TextStyle(font: regularFont)),
                pw.Text('Seat: ${ticket['seat']}', style: pw.TextStyle(font: regularFont)),
                pw.Text(
                  'Price: ₹${ticket['amount'].toStringAsFixed(2)}',
                  style: pw.TextStyle(font: regularFont),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return pdf.save();
  }

  static Future<Uint8List> _generateQrCode(String data) async {
    final qrValidationResult = QrValidator.validate(
      data: data,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.Q,
    );
    final qrCode = qrValidationResult.qrCode!;
    final painter = QrPainter.withQr(
      qr: qrCode,
      gapless: true,
      color: const ui.Color(0xFF000000),
      emptyColor: const ui.Color(0xFFFFFFFF),
    );
    final imageData = await painter.toImageData(300);
    return imageData!.buffer.asUint8List();
  }

  static Future<void> downloadPdf(List<Map<String, dynamic>> tickets) async {
    final pdfBytes = await generatePdf(tickets);
    await Printing.layoutPdf(onLayout: (_) => pdfBytes);
  }
}
