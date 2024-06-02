import 'package:flutter/material.dart';

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
  int _currentStep = 0;
  List<Map<String, dynamic>> questionsCreated = [];

  @override
  void initState() {
    super.initState();
    questionsCreated = List.from(widget.questions);
  }

  void _updateQuestion(int index, Map<String, dynamic> question) {
    setState(() {
      questionsCreated[index] = question;
      widget.onQuestionChanged(questionsCreated);
    });
  }

  bool _isStepValid(int step) {
    final question = questionsCreated[step];
    if (question['question'].isEmpty) {
      return false;
    }
    for (String answer in question['answers']) {
      if (answer.isEmpty) {
        return false;
      }
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.theme),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_isStepValid(_currentStep)) {
            if (_currentStep < widget.questions.length - 1) {
              setState(() {
                _currentStep += 1;
              });
            } else {
              Navigator.pop(context);
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Por favor, complete todos los campos')),
            );
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep -= 1;
            });
          }
        },
        steps: questionsCreated.asMap().entries.map((entry) {
          final index = entry.key;
          final question = entry.value;
          return Step(
            title: Text('Pregunta ${index + 1}'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  key: ValueKey('question_$index'),
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
                SizedBox(height: 10.0),
                ...question['answers'].asMap().entries.map((answerEntry) {
                  final answerIndex = answerEntry.key;
                  final answer = answerEntry.value;
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              key: ValueKey('answer_${index}_$answerIndex'),
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
                      ),
                      if (answerIndex != question['answers'].length - 1)
                        SizedBox(height: 10.0),
                    ],
                  );
                }).toList(),
                const Divider(),
                if (index != questionsCreated.length - 1) SizedBox(height: 16.0),
              ],
            ),
            isActive: _currentStep >= index,
            state: _currentStep > index ? StepState.complete : StepState.indexed,
          );
        }).toList(),
      ),
    );
  }
}
