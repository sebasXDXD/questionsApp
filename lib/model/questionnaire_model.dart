class Question {
  String question;
  String answer1;
  String answer2;
  String answer3;
  String answer4;
  String correctAnswer;

  Question({
    required this.question,
    required this.answer1,
    required this.answer2,
    required this.answer3,
    required this.answer4,
    required this.correctAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'],
      answer1: json['answer1'],
      answer2: json['answer2'],
      answer3: json['answer3'],
      answer4: json['answer4'],
      correctAnswer: json['correct_answer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer1': answer1,
      'answer2': answer2,
      'answer3': answer3,
      'answer4': answer4,
      'correct_answer': correctAnswer,
    };
  }
}

class Questionnaire {
  String theme;
  List<Question> questions;

  Questionnaire({
    required this.theme,
    required this.questions,
  });

  factory Questionnaire.fromJson(Map<String, dynamic> json) {
    var questionsJson = json['questions'] as List;
    List<Question> questionsList = questionsJson.map((questionJson) => Question.fromJson(questionJson)).toList();

    return Questionnaire(
      theme: json['theme'],
      questions: questionsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'theme': theme,
      'questions': questions.map((question) => question.toJson()).toList(),
    };
  }
}
