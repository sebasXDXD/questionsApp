import 'package:flutter/material.dart';

import '../../../model/quiestionnaire_result_model.dart';

class QuestionsScreen extends StatefulWidget {
  final List<QuestionResult> questions;
  final int initialQuestionIndex; // Indice inicial de la pregunta

  const QuestionsScreen({
    required this.questions,
    this.initialQuestionIndex = 0,
    Key? key,
  }) : super(key: key);

  @override
  _QuestionsScreenState createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  int currentQuestionIndex = 0;

  @override
  void initState() {
    super.initState();
    currentQuestionIndex = widget.initialQuestionIndex;
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex < widget.questions.length - 1) {
        currentQuestionIndex++;
      } else {
        Navigator.pop(context); // Navegar a la pantalla anterior al finalizar
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Preguntas"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              currentQuestion.question,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...currentQuestion.answers.asMap().entries.map((entry) {
              final index = entry.key;
              final answer = entry.value;
              final isSelected = currentQuestion.selected == index;
              final isCorrect = index == currentQuestion.correctAnswer;

              Color tileColor = Colors.transparent;
              Color textColor = Colors.black;

              if (isSelected) {
                if (isCorrect) {
                  tileColor = Colors.green;
                  textColor = Colors.white;
                } else {
                  tileColor = Colors.red;
                  textColor = Colors.white;
                }
              }

              return ListTile(
                title: Text(
                  answer,
                  style: TextStyle(color: textColor),
                ),
                tileColor: tileColor,
                leading: Radio(
                  value: index,
                  groupValue: currentQuestion.selected,
                  onChanged: null, // No permite cambiar la selección
                ),
              );
            }).toList(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: nextQuestion,
              child: Text(currentQuestionIndex < widget.questions.length - 1 ? "Siguiente" : "Finalizar"),
            ),
          ],
        ),
      ),
    );
  }
}
