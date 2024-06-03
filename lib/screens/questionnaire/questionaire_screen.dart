import 'package:flutter/material.dart';
import 'components/questions.dart';

class QuestionnaireScreen extends StatelessWidget {
  static String routeName = "/questionnaire";

  const QuestionnaireScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lista de temas y preguntas
    final List<Map<String, dynamic>> questionnaires = [
      {
        'id': 1,
        'theme': 'Tema 1',
        'questions': [
          {
            'id': 1,
            'question': '¿Cuál es tu color favorito?',
            'answers': ['Rojo', 'Verde', 'Azul', 'Amarillo'],
          },
          {
            'id': 2,
            'question': '¿Cuál es tu animal favorito?',
            'answers': ['Perro', 'Gato', 'Elefante', 'Tigre'],
          },
        ],
      },
      {
        'id': 2,
        'theme': 'Tema 2',
        'questions': [
          {
            'id': 1,
            'question': '¿Cuál es tu película favorita?',
            'answers': ['Star Wars', 'Harry Potter', 'Avengers', 'El Señor de los Anillos'],
          },
          {
            'id': 2,
            'question': '¿Cuál es tu comida favorita?',
            'answers': ['Pizza', 'Hamburguesa', 'Sushi', 'Ensalada'],
          },
        ],
      },
    ];
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
                "Cuestionario",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: questionnaires.length,
                  itemBuilder: (context, index) {
                    final theme = questionnaires[index]['theme'];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuestionsScreen(questions: questionnaires[index]['questions']),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
