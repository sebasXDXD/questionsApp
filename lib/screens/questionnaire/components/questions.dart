import 'package:flutter/material.dart';

class QuestionsScreen extends StatefulWidget {
  final List<Map<String, dynamic>> questions;

  const QuestionsScreen({required this.questions, super.key});

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
      _showResultsDialog();
    }
  }

  void _showResultsDialog() {
    final results = {
      "idQuestionnaire": 10,
      "answers": widget.questions.map((question) {
        return {
          "question_id": question['id'],
          "user_answer": question['selected'] ?? "No answer"
        };
      }).toList(),
    };

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Results"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(results.toString()),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
            ...currentQuestion['answers'].map<Widget>((answer) {
              return ListTile(
                title: Text(answer),
                leading: Radio(
                  value: answer,
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
              child: Text(currentQuestionIndex < widget.questions.length - 1
                  ? "Siguiente"
                  : "Finalizar"),
            ),
          ],
        ),
      ),
    );
  }
}
