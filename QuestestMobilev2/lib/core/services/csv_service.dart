import 'dart:io';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../features/stats/models/survey_stats.dart';

/// Service for generating and handling CSV files
class CsvService {
  CsvService._();

  /// Generate CSV from survey statistics
  static String generateSurveyStatsCsv(SurveyStats stats) {
    final List<List<dynamic>> rows = [];

    // Header row with metadata
    rows.add(['Statystyki ankiety: ${stats.surveyTitle}']);
    rows.add(['Łączna liczba respondentów: ${stats.totalRespondents}']);
    rows.add(['Data eksportu: ${_formatDate(DateTime.now())}']);
    rows.add([]); // Empty row

    // For each question, create a section
    for (int i = 0; i < stats.questions.length; i++) {
      final question = stats.questions[i];
      
      rows.add(['Pytanie ${i + 1}: ${question.question}']);
      rows.add(['Odpowiedź', 'Liczba odpowiedzi', 'Procent']);
      
      for (final option in question.options) {
        final percentage = (option.count / question.totalResponses * 100).toStringAsFixed(1);
        rows.add([option.label, option.count, '$percentage%']);
      }
      
      rows.add(['Łącznie', question.totalResponses, '100%']);
      rows.add([]); // Empty row between questions
    }

    const converter = ListToCsvConverter();
    return converter.convert(rows);
  }

  /// Generate detailed CSV with all responses (for when we have raw data)
  static String generateDetailedSurveyStatsCsv(SurveyStats stats) {
    final List<List<dynamic>> rows = [];

    // Header row
    final headers = <String>['#'];
    for (int i = 0; i < stats.questions.length; i++) {
      headers.add('Pytanie ${i + 1}');
    }
    rows.add(headers);

    // Question text row
    final questionTexts = <String>['Treść pytania'];
    for (final question in stats.questions) {
      questionTexts.add(question.question);
    }
    rows.add(questionTexts);

    rows.add([]); // Separator

    // Summary statistics
    rows.add(['Podsumowanie statystyk']);
    rows.add([]);

    for (int qIndex = 0; qIndex < stats.questions.length; qIndex++) {
      final question = stats.questions[qIndex];
      rows.add(['Pytanie ${qIndex + 1}: ${question.question}']);
      
      for (final option in question.options) {
        final percentage = question.totalResponses > 0 
            ? (option.count / question.totalResponses * 100).toStringAsFixed(2)
            : '0.00';
        rows.add(['  ${option.label}', option.count, '$percentage%']);
      }
      rows.add([]);
    }

    const converter = ListToCsvConverter();
    return converter.convert(rows);
  }

  /// Share CSV file
  static Future<void> shareCsv(String csvContent, String fileName) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(csvContent);
    
    await Share.shareXFiles(
      [XFile(file.path, mimeType: 'text/csv')],
      subject: 'Dane ankiety - Questest',
    );
  }

  /// Save CSV to downloads
  static Future<String> saveCsvToDownloads(String csvContent, String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';
    final file = File(filePath);
    await file.writeAsString(csvContent);
    return filePath;
  }

  static String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

