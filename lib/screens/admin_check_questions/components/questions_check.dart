import 'package:flutter/material.dart';

class QuestionsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> questions;

  const QuestionsScreen({required this.questions, Key? key}) : super(key: key);

  @override
  _QuestionsScreenState createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  int currentQuestionIndex = 0;

  void _nextQuestion() {
    if (currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      // Navegar a la pantalla de resultados o hacer algo al finalizar
      Navigator.pop(context);
    }
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
              currentQuestion['question'],
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...currentQuestion['answers'].asMap().entries.map((entry) {
              final index = entry.key;
              final answer = entry.value;
              final isSelected = currentQuestion['selected'] == index;
              final isCorrect = index == currentQuestion['correct_answer'];

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
                  groupValue: currentQuestion['selected'],
                  onChanged: (value) {
                    setState(() {
                      currentQuestion['selected'] = value;
                    });
                  },
                ),
              );
            }).toList(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _nextQuestion,
              child: Text(currentQuestionIndex < widget.questions.length - 1 ? "Siguiente" : "Finalizar"),
            ),
          ],
        ),
      ),
    );
  }
}
