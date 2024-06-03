import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../model/questionnaire_model.dart';
import '../model/quiestionnaire_result_model.dart'; // Asegúrate de importar tu modelo correctamente

class QuestionService {
  final FlutterSecureStorage secureStorage;

  QuestionService({required this.secureStorage});

  Future<String?> _getToken() async {
    return await secureStorage.read(key: 'token');
  }

  Future<void> createQuestionnaire(Questionnaire questionnaire) async {
    try {
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

      if (response.statusCode != 200) {
        throw Exception('Failed to create questionnaire');
      }
    } catch (e) {
      print('Error creating questionnaire: $e');
      rethrow;
    }
  }

  Future<Questionnaire> getQuestionnaire(String id) async {
    try {
      final String? token = await _getToken();
      if (token == null) {
        throw Exception('Token no disponible');
      }

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
    } catch (e) {
      print('Error getting questionnaire: $e');
      rethrow;
    }
  }

  Future<List<QuestionnaireResult>> getQuestionnaires() async {
    try {
      final String? token = await _getToken();
      if (token == null) {
        throw Exception('Token no disponible');
      }

      // Cargar el archivo .env para obtener el host de la API
      await dotenv.load(fileName: '.env');
      final apiHost = dotenv.env['QUESTION_BACKEND'];
      final String apiUrl = '$apiHost/admin/questionsResolved';
      final Uri url = Uri.parse(apiUrl);

      // Realizar la solicitud GET a la API
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      // Verificar el estado de la respuesta
      if (response.statusCode == 200) {
        final String responseBody = response.body;
        final dynamic decodedData = json.decode(responseBody);

        // Imprimir el contenido del mapa para depuración
        if (decodedData is Map<String, dynamic>) {
          print('Decoded data as Map<String, dynamic>:');
          decodedData.forEach((key, value) {
            print('$key: $value');
          });

          // Si decodedData es un mapa, lo convertimos a una lista de un solo cuestionario
          final QuestionnaireResult questionnaire = QuestionnaireResult.fromJson(decodedData);
          return [questionnaire];
        } else if (decodedData is List) {
          // Si decodedData es una lista, asumimos que son múltiples cuestionarios
          final List<QuestionnaireResult> questionnaires = decodedData.map((entry) => QuestionnaireResult.fromJson(entry)).toList();
          return questionnaires;
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        throw Exception('Failed to load questionnaire');
      }
    } catch (e) {
      print('Error fetching questionnaires: $e');
      throw e; // Rethrow para que la excepción sea manejada en el FutureBuilder
    }
  }

  void _printQuestionnaire(QuestionnaireResult questionnaire) {
    // Implementa la lógica para imprimir un cuestionario si es necesario
    // Esto es solo para depuración, puedes eliminarlo si no es necesario
    print('Printing questionnaire:');
    print('User ID: ${questionnaire.userId}');
    print('Theme: ${questionnaire.questions}');
    questionnaire.questions.forEach((question) {
      print('Question: ${question.question}');
      print('Answers: ${question.answers}');
      print('Selected: ${question.selected}');
      print('Correct Answer Index: ${question.correctAnswer}');
    });
  }

  void _printQuestionnaires(List<QuestionnaireResult> questionnaires) {
    // Implementa la lógica para imprimir los cuestionarios si es necesario
    // Esto es solo para depuración, puedes eliminarlo si no es necesario
    print('Printing questionnaires:');
    questionnaires.forEach((questionnaire) {
      print('User ID: ${questionnaire.userId}');
      print('Theme: ${questionnaire.questions}');
      questionnaire.questions.forEach((question) {
        print('Question: ${question.question}');
        print('Answers: ${question.answers}');
        print('Selected: ${question.selected}');
        print('Correct Answer Index: ${question.correctAnswer}');
      });
    });
  }
}
