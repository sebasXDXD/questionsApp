import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LoginRoute {
  final String username;
  final String password;
  final BuildContext context;
  LoginRoute(
      {required this.username, required this.password, required this.context});

  Future<Map<String, dynamic>?> fetchAuthToken() async {
    await dotenv.load(fileName: '.env');
    final apiHost = dotenv.env['QUESTION_BACKEND'];

    final String apiUrl = '$apiHost/login';
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final int? isAdmin = data['isAdmin'];
        final String? accessToken = data['token'];
        final Map<String, dynamic> authToken = {
          'isAdmin': isAdmin,
          'token': accessToken,
        }; // Token de autenticación
        return authToken;
      } else {
        // Maneja el error según corresponda
        print('Error al iniciar sesión. Código de estado: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Maneja errores de conexión u otros errores
      print('Error de conexión: $e');
      return null;
    }
  }
}
