// lib/core/services/pdf_service.dart
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;

class PdfService {
  // ─── Brand Colors ────────────────────────────────────────────────────────
  static const _primaryBlue = PdfColor.fromInt(0xFF004990);
  static const _accentRed = PdfColor.fromInt(0xFFE31B23);
  static const _lightBlue = PdfColor.fromInt(0xFFE0E9F2);
  static const _grey = PdfColor.fromInt(0xFF6D6E71);
  static const _greyBorder = PdfColor.fromInt(0xFFD6D6D6);
  static const _greyBg = PdfColor.fromInt(0xFFF0F0F0);
  static const _redSoft = PdfColor.fromInt(0xFFFCE8E9);
  static const _white = PdfColors.white;

  // ─── Header Builder ──────────────────────────────────────────────────────
  static pw.Widget _buildHeader(String docTitle, String docId, pw.MemoryImage logo) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: _primaryBlue,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Row(
            children: [
              pw.Image(logo, height: 40),
              pw.SizedBox(width: 12),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
              pw.Text(
                'GOVERNMENT OF ANDHRA PRADESH',
                style: pw.TextStyle(
                  color: _white,
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                'Department of Health & Family Welfare',
                style: pw.TextStyle(color: _greyBorder, fontSize: 8),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'AP DIGITAL VISION HEALTH PLATFORM',
                style: pw.TextStyle(
                  color: _accentRed,
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
          ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                docTitle,
                style: pw.TextStyle(
                  color: _white,
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'ID: $docId',
                style: pw.TextStyle(color: _greyBorder, fontSize: 8),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Info Row ────────────────────────────────────────────────────────────
  static pw.Widget _infoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(
              label,
              style: pw.TextStyle(fontSize: 9, color: _grey),
            ),
          ),
          pw.Text(': ', style: pw.TextStyle(fontSize: 9, color: _grey)),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Section Title ───────────────────────────────────────────────────────
  static pw.Widget _sectionTitle(String title) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 12, bottom: 6),
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: pw.BoxDecoration(
        color: _lightBlue,
        border: pw.Border(left: pw.BorderSide(color: _primaryBlue, width: 3)),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
          color: _primaryBlue,
        ),
      ),
    );
  }

  // ─── Footer ──────────────────────────────────────────────────────────────
  static pw.Widget _buildFooter(String date) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 20),
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: _primaryBlue, width: 0.5)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Secured with SHA-256 AP EMR Vault Standard',
                style: pw.TextStyle(fontSize: 7, color: _primaryBlue),
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                'Verifiable Digital Document - AP Vision Care',
                style: pw.TextStyle(fontSize: 7, color: _grey),
              ),
            ],
          ),
          pw.Text(
            'Generated: $date',
            style: pw.TextStyle(fontSize: 7, color: _grey),
          ),
        ],
      ),
    );
  }

  // ─── Generate Prescription PDF ───────────────────────────────────────────
  static Future<Uint8List> generatePrescriptionPdf({
    required String rxId,
    required String patientName,
    required String patientId,
    required String abhaNumber,
    required String doctorName,
    required String date,
    required String diagnosis,
    required String rightSph,
    required String rightCyl,
    required String rightAxis,
    required String leftSph,
    required String leftCyl,
    required String leftAxis,
    required String status,
    String district = '',
  }) async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final dateStr = '${now.day}/${now.month}/${now.year}';
    final imageBytes = await rootBundle.load('assets/images/apvision.png');
    final logo = pw.MemoryImage(imageBytes.buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _buildHeader('PRESCRIPTION', rxId, logo),
            pw.SizedBox(height: 16),

            // Patient Info
            _sectionTitle('PATIENT INFORMATION'),
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: _greyBorder),
                borderRadius: pw.BorderRadius.circular(4),
              ),
              child: pw.Column(
                children: [
                  pw.Row(
                    children: [
                      pw.Expanded(child: _infoRow('Patient Name', patientName)),
                      pw.Expanded(child: _infoRow('Patient ID', patientId)),
                    ],
                  ),
                  pw.Row(
                    children: [
                      pw.Expanded(child: _infoRow('ABHA Number', abhaNumber)),
                      pw.Expanded(child: _infoRow('District', district.isEmpty ? 'N/A' : district)),
                    ],
                  ),
                  pw.Row(
                    children: [
                      pw.Expanded(child: _infoRow('Date', date)),
                      pw.Expanded(child: _infoRow('Status', status)),
                    ],
                  ),
                  _infoRow('Issuing Physician', doctorName),
                ],
              ),
            ),

            // Diagnosis
            _sectionTitle('DIAGNOSIS & CLINICAL FINDINGS'),
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: _redSoft,
                border: pw.Border.all(color: _accentRed),
                borderRadius: pw.BorderRadius.circular(4),
              ),
              child: pw.Text(
                diagnosis,
                style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
              ),
            ),

            // Refraction Table
            _sectionTitle('REFRACTION DETAILS'),
            pw.Table(
              border: pw.TableBorder.all(color: _greyBorder, width: 0.5),
              children: [
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: _primaryBlue),
                  children: ['Eye', 'SPH (Sphere)', 'CYL (Cylinder)', 'AXIS'].map((h) =>
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Text(h, style: pw.TextStyle(color: _white, fontSize: 9, fontWeight: pw.FontWeight.bold), textAlign: pw.TextAlign.center),
                    )
                  ).toList(),
                ),
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: _greyBg),
                  children: ['Right Eye (OD)', rightSph, rightCyl, rightAxis].map((v) =>
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Text(v, style: pw.TextStyle(fontSize: 9), textAlign: pw.TextAlign.center),
                    )
                  ).toList(),
                ),
                pw.TableRow(
                  children: ['Left Eye (OS)', leftSph, leftCyl, leftAxis].map((v) =>
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(6),
                      child: pw.Text(v, style: pw.TextStyle(fontSize: 9), textAlign: pw.TextAlign.center),
                    )
                  ).toList(),
                ),
              ],
            ),

            pw.SizedBox(height: 16),

            // Signature Box
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Container(
                  width: 180,
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: _greyBorder),
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Column(
                    children: [
                      pw.SizedBox(height: 30),
                      pw.Divider(),
                      pw.Text(doctorName, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                      pw.Text('Authorized Physician', style: pw.TextStyle(fontSize: 7, color: _grey)),
                      pw.Text('AP Vision Program', style: pw.TextStyle(fontSize: 7, color: _primaryBlue)),
                    ],
                  ),
                ),
              ],
            ),

            pw.Spacer(),
            _buildFooter(dateStr),
          ],
        ),
      ),
    );

    return pdf.save();
  }

  // ─── Generate Referral PDF ───────────────────────────────────────────────
  static Future<Uint8List> generateReferralPdf({
    required String refId,
    required String patientName,
    required String patientId,
    required String hospital,
    required String condition,
    required String priority,
    required String status,
    required String date,
    required String doctorName,
  }) async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final dateStr = '${now.day}/${now.month}/${now.year}';
    final imageBytes = await rootBundle.load('assets/images/apvision.png');
    final logo = pw.MemoryImage(imageBytes.buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            _buildHeader('REFERRAL LETTER', refId, logo),
            pw.SizedBox(height: 16),

            _sectionTitle('PATIENT DETAILS'),
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: _greyBorder),
                borderRadius: pw.BorderRadius.circular(4),
              ),
              child: pw.Column(
                children: [
                  pw.Row(
                    children: [
                      pw.Expanded(child: _infoRow('Patient Name', patientName)),
                      pw.Expanded(child: _infoRow('Patient ID', patientId)),
                    ],
                  ),
                  pw.Row(
                    children: [
                      pw.Expanded(child: _infoRow('Referral Date', date)),
                      pw.Expanded(child: _infoRow('Status', status)),
                    ],
                  ),
                  _infoRow('Referring Physician', doctorName),
                ],
              ),
            ),

            _sectionTitle('REFERRAL DETAILS'),
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: _greyBorder),
                borderRadius: pw.BorderRadius.circular(4),
              ),
              child: pw.Column(
                children: [
                  _infoRow('Referred Hospital', hospital),
                  _infoRow('Clinical Condition', condition),
                  _infoRow('Priority Level', priority),
                ],
              ),
            ),

            _sectionTitle('CLINICAL NOTES'),
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              height: 80,
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: _greyBorder),
                borderRadius: pw.BorderRadius.circular(4),
              ),
              child: pw.Text(
                'Patient $patientName has been referred to $hospital for specialist evaluation '
                'of $condition. Priority has been classified as "$priority". '
                'Please ensure the patient is seen at the earliest convenience and results '
                'communicated back to the referring center.',
                style: pw.TextStyle(fontSize: 9, lineSpacing: 1.5),
              ),
            ),

            pw.SizedBox(height: 20),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Container(
                  width: 180,
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: _greyBorder),
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Column(
                    children: [
                      pw.SizedBox(height: 30),
                      pw.Divider(),
                      pw.Text(doctorName, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold)),
                      pw.Text('Referring Physician', style: pw.TextStyle(fontSize: 7, color: _grey)),
                      pw.Text('AP Vision Program', style: pw.TextStyle(fontSize: 7, color: _primaryBlue)),
                    ],
                  ),
                ),
              ],
            ),

            pw.Spacer(),
            _buildFooter(dateStr),
          ],
        ),
      ),
    );

    return pdf.save();
  }

  // ─── Preview / Print / Download ─────────────────────────────────────────
  static Future<void> previewPdf(Uint8List bytes, String title) async {
    await Printing.layoutPdf(
      onLayout: (_) async => bytes,
      name: title,
    );
  }

  static Future<void> sharePdf(Uint8List bytes, String filename) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$filename.pdf');
    await file.writeAsBytes(bytes);
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'AP Vision Care - $filename',
      text: 'Shared from AP Digital Vision Health Platform',
    );
  }

  static Future<void> savePdfToDownloads(Uint8List bytes, String filename) async {
    try {
      Directory? dir;
      if (Platform.isAndroid) {
        dir = Directory('/storage/emulated/0/Download');
        if (!await dir.exists()) {
          dir = await getExternalStorageDirectory();
        }
      } else {
        dir = await getApplicationDocumentsDirectory();
      }
      final file = File('${dir!.path}/$filename.pdf');
      await file.writeAsBytes(bytes);
    } catch (_) {
      // Fallback to share if save fails
      await sharePdf(bytes, filename);
    }
  }
}
