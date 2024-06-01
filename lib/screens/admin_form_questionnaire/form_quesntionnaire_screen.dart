import 'package:flutter/material.dart';

class FormQuestionnaireScreen extends StatefulWidget {
  static String routeName = "/FormQuestionnaire";
  const FormQuestionnaireScreen({super.key});
  @override
  _FormQuestionnaireScreenState createState() => _FormQuestionnaireScreenState();
}

class _FormQuestionnaireScreenState extends State<FormQuestionnaireScreen> {
  final TextEditingController _themeController = TextEditingController();
  final TextEditingController _numQuestionsController = TextEditingController();
  final List<Map<String, dynamic>> questions = [];

  @override
  void dispose() {
    _themeController.dispose();
    _numQuestionsController.dispose();
    super.dispose();
  }

  void _addQuestionnaire() {
    final theme = _themeController.text;
    final numQuestions = int.tryParse(_numQuestionsController.text) ?? 0;
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
        questions.add({
          'theme': theme,
          'questions': newQuestions,
        });
        _themeController.clear();
        _numQuestionsController.clear();
      });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Por favor, complete todos los campos correctamente.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Aceptar'),
              ),
            ],
          );
        },
      );
    }
  }

  void _saveQuestions() {
    // Aquí puedes guardar las preguntas en tu base de datos o hacer lo que necesites con ellas
    Navigator.pop(context, questions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Cuestionario'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _themeController,
              decoration: InputDecoration(
                labelText: 'Tema del Cuestionario',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _numQuestionsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Número de Preguntas',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addQuestionnaire,
              child: Text('Agregar Cuestionario'),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return QuestionCard(
                    theme: questions[index]['theme'],
                    questions: questions[index]['questions'],
                    onQuestionChanged: (newQuestions) {
                      setState(() {
                        questions[index]['questions'] = newQuestions;
                      });
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: questions.isNotEmpty ? _saveQuestions : null,
              child: Text('Guardar Cuestionario'),
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionCard extends StatefulWidget {
  final String theme;
  final List<Map<String, dynamic>> questions;
  final ValueChanged<List<Map<String, dynamic>>> onQuestionChanged;

  const QuestionCard({
    required this.theme,
    required this.questions,
    required this.onQuestionChanged,
    Key? key,
  }) : super(key: key);

  @override
  _QuestionCardState createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  void _updateQuestion(int index, Map<String, dynamic> question) {
    List<Map<String, dynamic>> updatedQuestions = List.from(widget.questions);
    updatedQuestions[index] = question;
    widget.onQuestionChanged(updatedQuestions);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.theme,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(height: 20),
            ...widget.questions.asMap().entries.map((entry) {
              final index = entry.key;
              final question = entry.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    onChanged: (text) {
                      _updateQuestion(index, {
                        ...question,
                        'question': text,
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Pregunta ${index + 1}',
                    ),
                  ),
                  ...question['answers'].asMap().entries.map((answerEntry) {
                    final answerIndex = answerEntry.key;
                    final answer = answerEntry.value;
                    return Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (text) {
                              List<String> updatedAnswers = List.from(question['answers']);
                              updatedAnswers[answerIndex] = text;
                              _updateQuestion(index, {
                                ...question,
                                'answers': updatedAnswers,
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Respuesta ${answerIndex + 1}',
                            ),
                          ),
                        ),
                        Radio(
                          value: answerIndex,
                          groupValue: question['correct_answer'],
                          onChanged: (value) {
                            _updateQuestion(index, {
                              ...question,
                              'correct_answer': value,
                            });
                          },
                        ),
                      ],
                    );
                  }).toList(),
                  Divider(),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FormQuestionnaireScreen(),
  ));
}
