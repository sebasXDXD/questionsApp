import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../model/userquestionnaire_model.dart';

class UserQuestionRoute {
  final FlutterSecureStorage secureStorage;

  UserQuestionRoute({required this.secureStorage});

  Future<String?> _getToken() async {
    return await secureStorage.read(key: 'token');
  }

  Future<void> sendQuestionnaireResults(Map<String, dynamic> results) async {
    try {
      await dotenv.load(fileName: '.env');
      final apiHost = dotenv.env['QUESTION_BACKEND'];

      final String apiUrl = '$apiHost/questionUser';
      final token = await _getToken();
      final url = Uri.parse(apiUrl);

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(results),
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to send questionnaire results');
      }
    } catch (e) {
      print('Error sending questionnaire results: $e');
      rethrow;
    }
  }

  Future<List<Questionnaire>> getQuestionnaires() async {
    try {
      final String? token = await _getToken();
      if (token == null) {
        throw Exception('Token no disponible');
      }

      await dotenv.load(fileName: '.env');
      final apiHost = dotenv.env['QUESTION_BACKEND'];
      final String apiUrl = '$apiHost/questions';
      final Uri url = Uri.parse(apiUrl);

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        final dynamic decodedData = json.decode(response.body);

        if (decodedData is List) {
          final List<Questionnaire> questionnaires = decodedData
              .map((entry) => Questionnaire.fromJson(entry))
              .toList();
          return questionnaires;
        } else if (decodedData is Map<String, dynamic>) {
          final QuestionnaireList questionnaireList =
          QuestionnaireList.fromJson(decodedData);
          return questionnaireList.questionnaires;
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        throw Exception('Failed to load questionnaires');
      }
    } catch (e) {
      print('Error fetching questionnaires: $e');
      throw e;
    }
  }

  void _printQuestionnaire(Questionnaire questionnaire) {
    print('Printing questionnaire:');
    print('ID: ${questionnaire.id}');
    print('Theme: ${questionnaire.theme}');
    questionnaire.questions.forEach((question) {
      print('Question: ${question.question}');
      print('Answers: ${question.answer1}, ${question.answer2}, ${question.answer3}, ${question.answer4}');
      print('Correct Answer: ${question.correctAnswer}');
    });
  }

  void _printQuestionnaires(List<Questionnaire> questionnaires) {
    print('Printing questionnaires:');
    questionnaires.forEach((questionnaire) {
      print('ID: ${questionnaire.id}');
      print('Theme: ${questionnaire.theme}');
      questionnaire.questions.forEach((question) {
        print('Question: ${question.question}');
        print('Answers: ${question.answer1}, ${question.answer2}, ${question.answer3}, ${question.answer4}');
        print('Correct Answer: ${question.correctAnswer}');
      });
    });
  }
}
