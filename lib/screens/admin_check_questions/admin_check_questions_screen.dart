import 'package:flutter/material.dart';
import 'components/questions_check.dart';

class AdminCheckQuestionsScreen extends StatelessWidget {
  static String routeName = "/AdminQuestionnaire";

  const AdminCheckQuestionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
// Lista de temas y preguntas
    final List<Map<String, dynamic>> questionnaires = [
      {
        'userId': 1,
        'questions': [
          {
            'question': '¿Cuál es tu color favorito?',
            'answers': ['Rojo', 'Verde', 'Azul', 'Amarillo'],
            'selected': 3, // Respuesta seleccionada
            'theme': "Tema 1",
            'correct_answer': 0, // Índice de la respuesta correcta
          },
          {
            'question': '¿Cuál es tu animal favorito?',
            'answers': ['Perro', 'Gato', 'Elefante', 'Tigre'],
            'selected': 1, // Respuesta seleccionada
            'theme': "Tema 1",
            'correct_answer': 1, // Índice de la respuesta correcta
          },
        ],
      },
      {
        'userId': 2,
        'questions': [
          {
            'question': '¿Cuál es tu película favorita?',
            'answers': ['Star Wars', 'Harry Potter', 'Avengers', 'El Señor de los Anillos'],
            'selected': 0, // Respuesta seleccionada
            'theme': "Tema 2",
            'correct_answer': 3, // Índice de la respuesta correcta
          },
          {
            'question': '¿Cuál es tu comida favorita?',
            'answers': ['Pizza', 'Hamburguesa', 'Sushi', 'Ensalada'],
            'selected': 2, // Respuesta seleccionada
            'theme': "Tema 2",
            'correct_answer': 2, // Índice de la respuesta correcta
          },
        ],
      },
    ];


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
                child: ListView.builder(
                  itemCount: questionnaires.length,
                  itemBuilder: (context, index) {
                    final theme = questionnaires[index]['questions'][0]['theme'];
                    final userId =  questionnaires[index]['userId'].toString();// Convertir userId a String
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
                        child: Text('$theme - Usuario: $userId'),
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
