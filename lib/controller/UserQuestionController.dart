import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shop_app/auth/secureStorage.dart';
import 'package:shop_app/model/userquestionnaire_model.dart';
import '../routes/UserQuestionRoute.dart';

class UserQuestionController {
  final SecureStorage secureStorage;
  final UserQuestionRoute userQuestionRoute;

  UserQuestionController()
      : secureStorage = SecureStorage(),
        userQuestionRoute = UserQuestionRoute(secureStorage: FlutterSecureStorage());

  Future<void> solveQuestion(int questionnaireId, Map<String, dynamic> results) async {
    final Map<String, dynamic> tokenData = await secureStorage.getAccessTokenAndIsAdmin();
    final String? _token = tokenData['token'];
    if (_token == null) {
      print('Token no disponible');
      return;
    }

    final Map<String, dynamic> formattedResults = {
      'idQuestionnaire': questionnaireId,
      'answers': (results['answers'] as List).map((answer) {
        return {
          'question_id': answer['id'],
          'user_answer': answer['selected'],
        };
      }).toList(),
    };

    await userQuestionRoute.sendQuestionnaireResults(formattedResults);
  }

  Future<List<Questionnaire>> getQuestionnaires() async {
    try {
      final Map<String, dynamic> tokenData =
      await secureStorage.getAccessTokenAndIsAdmin();
      final String? _token = tokenData['token'];
      if (_token == null) {
        throw Exception('Token no disponible');
      }

      final List<Questionnaire> retrievedQuestionnaires =
      await userQuestionRoute.getQuestionnaires();

      return retrievedQuestionnaires;
    } catch (e) {
      print('Error en getQuestionnairesC: $e');
      rethrow; // Rethrow para que la excepción sea manejada en el FutureBuilder
    }
  }
}
