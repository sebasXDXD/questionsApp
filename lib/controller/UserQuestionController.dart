import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shop_app/auth/secureStorage.dart';
import '../model/questionnaire_model.dart';
import '../model/quiestionnaire_result_model.dart';
import '../routes/QuestionRoute.dart';

class UserQuestionController {
  final SecureStorage secureStorage;

  UserQuestionController() : secureStorage = SecureStorage();

  Future<void> printQuestionnaire(Questionnaire questionnaire) async {
    final Map<String, dynamic> tokenData =
        await secureStorage.getAccessTokenAndIsAdmin();
    final String? _token = tokenData['token'];
    if (_token == null) {
      print('Token no disponible');
      return;
    }

    final jsonString = json.encode(questionnaire.toJson());

    final QuestionService questionService =
        QuestionService(secureStorage: FlutterSecureStorage());

    try {
      await questionService.createQuestionnaire(questionnaire);
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<List<QuestionnaireResult>> getQuestionnaires() async {
    try {
      final Map<String, dynamic> tokenData =
          await secureStorage.getAccessTokenAndIsAdmin();
      final String? _token = tokenData['token'];
      if (_token == null) {
        throw Exception('Token no disponible');
      }

      final QuestionService questionService =
          QuestionService(secureStorage: FlutterSecureStorage());
      final List<QuestionnaireResult> retrievedQuestionnaires =
          await questionService.getQuestionnaires();

      // Imprimir el resultado obtenido del servicio
      print('Retrieved Questionnaires: $retrievedQuestionnaires');

      return retrievedQuestionnaires;
    } catch (e) {
      print('Error en getQuestionnairesC: $e');
      rethrow; // Rethrow para que la excepción sea manejada en el FutureBuilder
    }
  }
}
