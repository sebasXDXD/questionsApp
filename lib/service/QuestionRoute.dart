import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../model/questionnaire_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class QuestionService {
  final FlutterSecureStorage secureStorage;

  QuestionService({required this.secureStorage});

  Future<String?> _getToken() async {
    return await secureStorage.read(key: 'token');
  }

  Future<void> createQuestionnaire(Questionnaire questionnaire) async {
    await dotenv.load(fileName: '.env');
    final apiHost = dotenv.env['QUESTION_BACKEND'];

    final String apiUrl = '$apiHost/questions';
    final token = await _getToken();
    final url = Uri.parse(apiUrl);

    // Prepare the data to send
    final List<Map<String, dynamic>> questionsData = questionnaire.questions.map((question) {
      return {
        'question': question.question,
        'answer1': question.answer1,
        'answer2': question.answer2,
        'answer3': question.answer3,
        'answer4': question.answer4,
        'correct_answer': question.correctAnswer,
      };
    }).toList();

    final body = json.encode({
      'theme': questionnaire.theme,
      'questions': questionsData,
    });

    // Make the POST request
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: body,
    );
print(response);
    if (response.statusCode != 200) {
      throw Exception('Failed to create questionnaire');
    }
  }

  Future<Questionnaire> getQuestionnaire(String id) async {
    final token = await _getToken();
    final url = Uri.parse('http://localhost:3000/api/questions/$id');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Questionnaire.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load questionnaire');
    }
  }
}
