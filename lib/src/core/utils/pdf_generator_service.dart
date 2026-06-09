import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../features/wedding/domain/wedding_model.dart';
import '../constants/api_constants.dart';

class PdfGeneratorService {
  static Future<void> generateAndPrintWeddingInvitation(Wedding wedding) async {
    final pdf = pw.Document();

    // Load fonts (using standard fonts for simplicity, or we could load custom ttf)
    final font = await PdfGoogleFonts.playfairDisplayRegular();
    final fontBold = await PdfGoogleFonts.playfairDisplayBold();

    // Generate QR Code data
    final url = '${ApiConstants.defaultBaseUrl}/${wedding.slug}';

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.amber800, width: 2),
            ),
            padding: const pw.EdgeInsets.all(32),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.SizedBox(height: 40),
                pw.Text(
                  'Together with their families',
                  style: pw.TextStyle(font: font, fontSize: 18, color: PdfColors.grey700),
                ),
                pw.SizedBox(height: 40),
                pw.Text(
                  '${wedding.groomName} & ${wedding.brideName}',
                  style: pw.TextStyle(font: fontBold, fontSize: 48, color: PdfColors.amber900),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 40),
                pw.Text(
                  'Invite you to celebrate their wedding',
                  style: pw.TextStyle(font: font, fontSize: 18, color: PdfColors.grey700),
                ),
                pw.SizedBox(height: 40),
                pw.Text(
                  wedding.weddingDate.toIso8601String().split('T')[0],
                  style: pw.TextStyle(font: fontBold, fontSize: 24),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  wedding.weddingTime ?? '',
                  style: pw.TextStyle(font: font, fontSize: 18),
                ),
                pw.SizedBox(height: 40),
                pw.Text(
                  wedding.venue?.name ?? '',
                  style: pw.TextStyle(font: fontBold, fontSize: 20),
                  textAlign: pw.TextAlign.center,
                ),
                pw.Text(
                  wedding.venue?.address ?? '',
                  style: pw.TextStyle(font: font, fontSize: 16),
                  textAlign: pw.TextAlign.center,
                ),
                pw.Spacer(),
                pw.Container(
                  width: 100,
                  height: 100,
                  child: pw.BarcodeWidget(
                    barcode: pw.Barcode.qrCode(),
                    data: url,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Scan for details & RSVP',
                  style: pw.TextStyle(font: font, fontSize: 12, color: PdfColors.grey600),
                ),
                pw.SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );

    await Printing.sharePdf(
      bytes: await pdf.save(),
      filename: 'wedding_invitation_${wedding.slug}.pdf',
    );
  }
}
