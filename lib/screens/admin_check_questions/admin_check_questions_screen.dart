import 'package:flutter/material.dart';
import '../../controller/QuestionController.dart';
import '../../model/quiestionnaire_result_model.dart';
import 'components/questions_check.dart';

class AdminCheckQuestionsScreen extends StatefulWidget {
  static String routeName = "/AdminQuestionnaire";

  const AdminCheckQuestionsScreen({Key? key}) : super(key: key);

  @override
  _AdminCheckQuestionsScreenState createState() =>
      _AdminCheckQuestionsScreenState();
}

class _AdminCheckQuestionsScreenState extends State<AdminCheckQuestionsScreen> {
  late QuestionController _controller;
  late Future<List<QuestionnaireResult>> questionnairesFuture;

  @override
  void initState() {
    super.initState();
    callController();
  }

  Future<void> callController() async {
    _controller = QuestionController();
    questionnairesFuture = _controller.getQuestionnaires();

    // Imprimimos el estado del future de questionnaires
    await questionnairesFuture.then((questionnaires) {
      List<Map<String, dynamic>> questionnaireList = [];
      questionnaires.forEach((questionnaire) {
        Map<String, dynamic> questionnaireMap = {
          "userId": questionnaire.userId,
          "questions": questionnaire.questions
              .map((questionResult) => {
            "question": questionResult.question,
            "answers": questionResult.answers,
            "selected": questionResult.selected,
            "theme": questionResult.question,
            "correct_answer": questionResult.correctAnswer,
          })
              .toList(),
        };
        questionnaireList.add(questionnaireMap);
      });

      print('QuestionnairesVista: $questionnaireList');
    }).catchError((error) {
      print('Error fetching questionnaires: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkear preguntas"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Cuestionarios resueltos",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: FutureBuilder<List<QuestionnaireResult>>(
                  future: questionnairesFuture,
                  builder: (context, AsyncSnapshot<List<QuestionnaireResult>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No hay cuestionarios disponibles.');
                    }

                    final questionnaires = snapshot.data!;

                    return ListView.builder(
                      itemCount: questionnaires.length,
                      itemBuilder: (context, index) {
                        final questionnaire = questionnaires[index];
                        final userId = questionnaire.userId.toString();
                        final theme = '${questionnaire.questions.first.theme ?? 'Sin tema'}'; // Usamos el tema de la primera pregunta del cuestionario

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QuestionsScreen(
                                    questions: questionnaire.questions,
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
                            child: Text('$theme - Usuario: $userId'),
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
