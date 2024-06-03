import 'package:flutter/material.dart';
import 'package:shop_app/controller/UserQuestionController.dart';
import 'package:shop_app/model/userquestionnaire_model.dart';
import 'package:shop_app/screens/questionnaire/components/questions.dart';

class QuestionnaireScreen extends StatefulWidget {
  static String routeName = "/questionnaire";
  const QuestionnaireScreen({Key? key}) : super(key: key);

  @override
  _QuestionnaireScreenState createState() => _QuestionnaireScreenState();
}

class _QuestionnaireScreenState extends State<QuestionnaireScreen> {
  late UserQuestionController _controller;
  late Future<List<Questionnaire>> questionnairesFuture;
  List<Map<String, dynamic>> questionnaires = [];

  @override
  void initState() {
    super.initState();
    _controller = UserQuestionController();
    questionnairesFuture = _controller.getQuestionnaires();

    // Llamar a la función para imprimir los cuestionarios por consola
    _printQuestionnaires();
  }

  Future<void> _printQuestionnaires() async {
    try {
      final List<Questionnaire> questionnairesData = await _controller.getQuestionnaires();

      questionnairesData.forEach((questionnaire) {
        List<Map<String, dynamic>> questionsList = [];
        questionnaire.questions.forEach((question) {
          questionsList.add({
            'id': question.id,
            'question': question.question,
            'answers': [
              question.answer1,
              question.answer2,
              question.answer3,
              question.answer4,
            ],
            'correct_answer': question.correctAnswer,
          });
        });

        questionnaires.add({
          'id': questionnaire.id,
          'theme': questionnaire.theme,
          'questions': questionsList,
        });
      });

      print('Retrieved Questionnaires:');
      questionnaires.forEach((questionnaire) {
        print('Id: ${questionnaire['id']}');
        print('Theme: ${questionnaire['theme']}');
        print('Questions:');
        questionnaire['questions'].forEach((question) {
          print('  - Question: ${question['question']}');
          print('    Answers: ${question['answers']}');
        });
        print('');
      });

      setState(() {}); // Actualiza el estado para reflejar los cuestionarios obtenidos
    } catch (e) {
      print('Error al obtener cuestionarios: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cuestionario"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Cuestionarios",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<Questionnaire>>(
                  future: questionnairesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No hay cuestionarios disponibles.');
                    }

                    return ListView.builder(
                      itemCount: questionnaires.length,
                      itemBuilder: (context, index) {
                        final theme = questionnaires[index]['theme'];
                        final questionnaireId = questionnaires[index]['id'];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QuestionsScreen(
                                    questions: questionnaires[index]['questions'],
                                    questionnaireId: questionnaireId,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(16.0),
                              textStyle: const TextStyle(fontSize: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(theme),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
