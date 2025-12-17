import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:printing/printing.dart';

/// Service for generating and handling PDF documents
class PdfService {
  PdfService._();

  static pw.Font? _cachedFont;
  static pw.Font? _cachedFontBold;

  /// Load a font that supports Polish characters
  static Future<pw.Font> _getFont() async {
    if (_cachedFont != null) return _cachedFont!;
    // Use Roboto from Google Fonts - it supports Polish characters
    _cachedFont = await PdfGoogleFonts.robotoRegular();
    return _cachedFont!;
  }

  static Future<pw.Font> _getFontBold() async {
    if (_cachedFontBold != null) return _cachedFontBold!;
    _cachedFontBold = await PdfGoogleFonts.robotoBold();
    return _cachedFontBold!;
  }

  /// Generate quiz result PDF
  static Future<Uint8List> generateQuizResultPdf({
    required String quizTitle,
    required double scorePercent,
    required int correctAnswers,
    required int totalQuestions,
    required DateTime completedAt,
    String? userName,
  }) async {
    // Load fonts that support Polish characters
    final font = await _getFont();
    final fontBold = await _getFontBold();

    final pdf = pw.Document();

    // Brand colors
    final primaryColor = PdfColor.fromHex('#6C5CE7');
    final secondaryColor = PdfColor.fromHex('#FF6B9D');
    final successColor = PdfColor.fromHex('#00B894');
    final textPrimary = PdfColor.fromHex('#2D3436');
    final textSecondary = PdfColor.fromHex('#636E72');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        theme: pw.ThemeData.withFont(
          base: font,
          bold: fontBold,
        ),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header with gradient-like banner
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(24),
                decoration: pw.BoxDecoration(
                  color: primaryColor,
                  borderRadius: pw.BorderRadius.circular(16),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text(
                      'QUESTEST',
                      style: pw.TextStyle(
                        font: fontBold,
                        color: PdfColors.white,
                        fontSize: 32,
                        letterSpacing: 3,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      'Certyfikat ukonczenia',
                      style: pw.TextStyle(
                        font: font,
                        color: PdfColors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              pw.SizedBox(height: 32),

              // Quiz Title
              pw.Center(
                child: pw.Text(
                  quizTitle,
                  style: pw.TextStyle(
                    font: fontBold,
                    color: textPrimary,
                    fontSize: 24,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),

              pw.SizedBox(height: 40),

              // Score Circle
              pw.Center(
                child: pw.Container(
                  width: 160,
                  height: 160,
                  decoration: pw.BoxDecoration(
                    shape: pw.BoxShape.circle,
                    border: pw.Border.all(
                      color: _getScoreColor(scorePercent),
                      width: 8,
                    ),
                  ),
                  child: pw.Center(
                    child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Text(
                          '${scorePercent.toStringAsFixed(0)}%',
                          style: pw.TextStyle(
                            font: fontBold,
                            color: _getScoreColor(scorePercent),
                            fontSize: 48,
                          ),
                        ),
                        pw.Text(
                          '$correctAnswers / $totalQuestions',
                          style: pw.TextStyle(
                            font: font,
                            color: textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              pw.SizedBox(height: 32),

              // Score message
              pw.Center(
                child: pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey100,
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: pw.Text(
                    _getScoreMessage(scorePercent),
                    style: pw.TextStyle(
                      font: font,
                      color: textPrimary,
                      fontSize: 14,
                    ),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
              ),

              pw.SizedBox(height: 40),

              // Details Section
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(20),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(12),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Szczegoly',
                      style: pw.TextStyle(
                        font: fontBold,
                        color: textPrimary,
                        fontSize: 16,
                      ),
                    ),
                    pw.SizedBox(height: 16),
                    _buildDetailRow('Poprawne odpowiedzi', '$correctAnswers', successColor, font, fontBold),
                    pw.SizedBox(height: 8),
                    _buildDetailRow('Niepoprawne odpowiedzi', '${totalQuestions - correctAnswers}', secondaryColor, font, fontBold),
                    pw.SizedBox(height: 8),
                    _buildDetailRow('Laczna liczba pytan', '$totalQuestions', primaryColor, font, fontBold),
                    pw.SizedBox(height: 8),
                    _buildDetailRow('Data ukonczenia', _formatDate(completedAt), textSecondary, font, fontBold),
                    if (userName != null) ...[
                      pw.SizedBox(height: 8),
                      _buildDetailRow('Uzytkownik', userName, textSecondary, font, fontBold),
                    ],
                  ],
                ),
              ),

              pw.Spacer(),

              // Footer
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.only(top: 16),
                decoration: const pw.BoxDecoration(
                  border: pw.Border(
                    top: pw.BorderSide(color: PdfColors.grey300, width: 1),
                  ),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Wygenerowano przez Questest',
                      style: pw.TextStyle(
                        font: font,
                        color: textSecondary,
                        fontSize: 10,
                      ),
                    ),
                    pw.Text(
                      _formatDate(DateTime.now()),
                      style: pw.TextStyle(
                        font: font,
                        color: textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  /// Share PDF file
  static Future<void> sharePdf(Uint8List pdfBytes, String fileName) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsBytes(pdfBytes);
    
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Wynik quizu - Questest',
    );
  }

  /// Preview and print PDF - with error handling
  static Future<void> printPdf(Uint8List pdfBytes, String fileName) async {
    try {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfBytes,
        name: fileName,
      );
    } catch (e) {
      // If printing fails, fallback to share
      await sharePdf(pdfBytes, fileName);
      rethrow;
    }
  }

  static pw.Widget _buildDetailRow(String label, String value, PdfColor valueColor, pw.Font font, pw.Font fontBold) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            font: font,
            color: PdfColor.fromHex('#636E72'),
            fontSize: 12,
          ),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            font: fontBold,
            color: valueColor,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  static PdfColor _getScoreColor(double score) {
    if (score >= 80) return PdfColor.fromHex('#00B894');
    if (score >= 60) return PdfColor.fromHex('#FDCB6E');
    if (score >= 40) return PdfColor.fromHex('#E17055');
    return PdfColor.fromHex('#D63031');
  }

  static String _getScoreMessage(double score) {
    if (score >= 90) {
      return 'Doskonaly wynik! Gratulacje!';
    } else if (score >= 75) {
      return 'Bardzo dobry wynik! Tak trzymaj!';
    } else if (score >= 60) {
      return 'Dobry wynik! Jest jeszcze miejsce na poprawe.';
    } else if (score >= 40) {
      return 'Niezly start! Sprobuj ponownie.';
    }
    return 'Nie poddawaj sie! Kazdy poczatek jest trudny.';
  }

  static String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
