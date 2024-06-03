import 'dart:convert';

class TypesHelper {
  static int toInt(dynamic val) {
    if (val == null) {
      return 0;
    }
    try {
      if (val is int) {
        return val;
      } else if (val is num) {
        return val.toInt();
      } else if (val is String) {
        return int.tryParse(val) ?? 0;
      } else {
        return 0;
      }
    } catch (e) {
      print('Error converting $val to int: $e');
      return 0;
    }
  }
}

class Question {
  final int id;
  final String question;
  final String answer1;
  final String answer2;
  final String answer3;
  final String answer4;
  final String correctAnswer;
  final DateTime createdAt;
  String? selectedAnswer; // Variable para almacenar la respuesta seleccionada

  Question({
    required this.id,
    required this.question,
    required this.answer1,
    required this.answer2,
    required this.answer3,
    required this.answer4,
    required this.correctAnswer,
    required this.createdAt,
    this.selectedAnswer, // Inicializado como nulo
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: TypesHelper.toInt(json['id']),
      question: json['question'],
      answer1: json['answer1'],
      answer2: json['answer2'],
      answer3: json['answer3'],
      answer4: json['answer4'],
      correctAnswer: json['correct_answer'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'answer1': answer1,
      'answer2': answer2,
      'answer3': answer3,
      'answer4': answer4,
      'correct_answer': correctAnswer,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

class Questionnaire {
  final int id;
  final String theme;
  final int userCreatedId;
  final DateTime createdAt;
  final List<Question> questions;
  Map<int, String> answers; // Mapa para almacenar las respuestas seleccionadas

  Questionnaire({
    required this.id,
    required this.theme,
    required this.userCreatedId,
    required this.createdAt,
    required this.questions,
    Map<int, String>? answers, // Mapa opcional para las respuestas seleccionadas
  }) : this.answers = answers ?? {}; // Si no se proporciona, se inicializa como un mapa vacío

  factory Questionnaire.fromJson(Map<String, dynamic> json) {
    var questionsFromJson = json['questions'] as List;
    List<Question> questionList =
    questionsFromJson.map((i) => Question.fromJson(i)).toList();

    return Questionnaire(
      id: TypesHelper.toInt(json['id']),
      theme: json['theme'],
      userCreatedId: TypesHelper.toInt(json['user_created_id']),
      createdAt: DateTime.parse(json['created_at']),
      questions: questionList,
      answers: {}, // Inicializado como un mapa vacío
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'theme': theme,
      'user_created_id': userCreatedId,
      'created_at': createdAt.toIso8601String(),
      'questions': questions.map((question) => question.toJson()).toList(),
      'answers': answers, // Incluir las respuestas en el JSON
    };
  }
}

class QuestionnaireList {
  final List<Questionnaire> questionnaires;

  QuestionnaireList({
    required this.questionnaires,
  });

  factory QuestionnaireList.fromJson(Map<String, dynamic> json) {
    var questionnairesFromJson = json['questionnaires'] as List;
    List<Questionnaire> questionnaireList =
    questionnairesFromJson.map((i) => Questionnaire.fromJson(i)).toList();

    return QuestionnaireList(
      questionnaires: questionnaireList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'questionnaires':
      questionnaires.map((questionnaire) => questionnaire.toJson()).toList(),
    };
  }
}
