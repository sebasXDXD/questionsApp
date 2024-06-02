import 'package:flutter/material.dart';
import 'package:shop_app/auth/secureStorage.dart';
import 'dart:convert';
import 'package:shop_app/model/questionnaire_model.dart';
import 'package:shop_app/controller/QuestionController.dart';
import '../admin_check_questions/admin_check_questions_screen.dart';
import '../questionnaire/questionaire_screen.dart';
import 'component/question_card.dart';

class FormQuestionnaireScreen extends StatefulWidget {
  static String routeName = "/FormQuestionnaire";
  const FormQuestionnaireScreen({Key? key}) : super(key: key);

  @override
  _FormQuestionnaireScreenState createState() =>
      _FormQuestionnaireScreenState();
}

class _FormQuestionnaireScreenState extends State<FormQuestionnaireScreen> {
  final TextEditingController _themeController = TextEditingController();
  final TextEditingController _numQuestionsController =
  TextEditingController();
  final QuestionController questionController = QuestionController();
  List<Map<String, dynamic>> questions = [];

  String? token = '';
  final SecureStorage secureStorage = SecureStorage();
  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  void _loadToken() async {
    final tokenData = await secureStorage.getAccessTokenAndIsAdmin();
    setState(() {
      token = tokenData['token'] ?? '';
    });
  }

  @override
  void dispose() {
    _themeController.dispose();
    _numQuestionsController.dispose();
    super.dispose();
  }

  void _addQuestionnaire() {
    final theme = _themeController.text;
    final numQuestions =
        int.tryParse(_numQuestionsController.text) ?? 0;
    if (theme.isNotEmpty && numQuestions > 0) {
      final List<Map<String, dynamic>> newQuestions = [];
      for (var i = 0; i < numQuestions; i++) {
        newQuestions.add({
          'question': '',
          'answers': ['', '', '', ''],
          'correct_answer': 0,
        });
      }
      setState(() {
        questions.clear();
        questions.add({
          'theme': theme,
          'questions': newQuestions,
        });
        _themeController.clear();
        _numQuestionsController.clear();
      });
    } else {
      _showErrorDialog();
    }
  }

  void _saveQuestions() {
    // Aquí puedes guardar las preguntas en tu base de datos o hacer lo que necesites con ellas
    _showSavedQuestionsDialog();

    // Espera un momento antes de limpiar las preguntas
    Future.delayed(Duration(milliseconds: 2000), () {
      _clearQuestions();
    });
  }

  void _showSavedQuestionsDialog() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      final theme = questions[0]['theme'];
      final questionList = questions[0]['questions']
          .map<Question>((q) => Question(
        question: q['question'],
        answer1: q['answers'][0],
        answer2: q['answers'][1],
        answer3: q['answers'][2],
        answer4: q['answers'][3],
        correctAnswer: q['answers'][q['correct_answer']],
      ))
          .toList();

      final questionnaire =
      Questionnaire(theme: theme, questions: questionList);

      // Usar el token almacenado en el estado del widget
     await questionController.printQuestionnaire(questionnaire);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: EdgeInsets.zero,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text('Tema: ${questions[0]['theme']}'),
                ),
                const Divider(),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: questions[0]['questions'].length,
                  itemBuilder: (context, index) {
                    final question = questions[0]['questions'][index];
                    return ListTile(
                      title: Text('Pregunta ${index + 1}: ${question['question']}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...question['answers'].asMap().entries.map((entry) {
                            final answerIndex = entry.key;
                            final answer = entry.value;
                            return Text('Respuesta ${answerIndex + 1}: $answer');
                          }).toList(),
                          Text('Respuesta Correcta: ${question['answers'][question['correct_answer']]}'),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Aceptar'),
                ),
              ],
            ),
          );
        },
      );
    });
  }



  void _showQuestionCard(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.zero,
          child: QuestionCard(
            theme: questions[index]['theme'],
            questions: questions[index]['questions'],
            onQuestionChanged: (newQuestions) {
              setState(() {
                questions[index]['questions'] = newQuestions;
              });
            },
          ),
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: const Text(
              'Por favor, complete todos los campos correctamente.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  void _clearQuestions() {
    setState(() {
      questions.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Cuestionario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _themeController,
              decoration: const InputDecoration(
                labelText: 'Tema del Cuestionario',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _numQuestionsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Número de Preguntas',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addQuestionnaire,
              child: const Text('Agregar Cuestionario'),
            ),
            const SizedBox(height: 20),
            if (questions.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(questions[index]['theme']),
                      subtitle: Text(
                          '${questions[index]['questions'].length} preguntas'),
                      onTap: () => _showQuestionCard(index),
                    );
                  },
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: questions.isNotEmpty ? _saveQuestions : null,
              child: const Text('Guardar Cuestionario'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: questions.isNotEmpty ? _clearQuestions : null,
              child: const Text('Limpiar Cuestionarios'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: const FormQuestionnaireScreen(),
    routes: {
      AdminCheckQuestionsScreen.routeName: (context) =>
      const AdminCheckQuestionsScreen(),
      QuestionnaireScreen.routeName: (context) =>
      const QuestionnaireScreen(),
    },
  ));
}

