import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shop_app/auth/secureStorage.dart';
import '../model/questionnaire_model.dart';
import '../service/QuestionRoute.dart';

class QuestionController {
  final SecureStorage secureStorage;

  QuestionController() : secureStorage = SecureStorage();

  Future<void> printQuestionnaire(Questionnaire questionnaire) async {
    final Map<String, dynamic> tokenData = await secureStorage.getAccessTokenAndIsAdmin();
    final String? _token = tokenData['token'];
    if (_token == null) {
      print('Token no disponible');
      return;
    }

    final jsonString = json.encode(questionnaire.toJson());


    final QuestionService questionService = QuestionService(secureStorage: FlutterSecureStorage());

    try {
      await questionService.createQuestionnaire(questionnaire);
      final retrievedQuestionnaire = await questionService.getQuestionnaire('some_id');
      print('Cuestionario recuperado:');
      print(retrievedQuestionnaire);
    } catch (e) {
      print('Error: $e');
    }
  }
}
