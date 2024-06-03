class QuestionnaireResult {
  final int userId;
  final List<QuestionResult> questions;

  QuestionnaireResult({
    required this.userId,
    required this.questions,
  });

  factory QuestionnaireResult.fromJson(Map<String, dynamic> json) {
    List<QuestionResult> questionsList = [];
    if (json['questions'] != null) {
      questionsList = List<QuestionResult>.from(
        json['questions'].map((question) => QuestionResult.fromJson(question)),
      );
    }
    return QuestionnaireResult(
      userId: TypesHelper.toInt(json['userId']),
      questions: questionsList,
    );
  }
}

class QuestionResult {
  final String question;
  final List<String> answers;
  final int selected;
  final String? theme; // Hacemos que theme sea opcional
  final int correctAnswer;

  QuestionResult({
    required this.question,
    required this.answers,
    required this.selected,
    this.theme,
    required this.correctAnswer,
  });

  factory QuestionResult.fromJson(Map<String, dynamic> json) {
    return QuestionResult(
      question: json['question'] ?? '',
      answers: List<String>.from(json['answers'] ?? []),
      selected: json['selected'] ?? 0,
      theme: json['theme'],
      correctAnswer: json['correct_answer'] ?? 0,
    );
  }
}

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
