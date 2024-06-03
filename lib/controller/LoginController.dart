import 'package:flutter/cupertino.dart';
import 'dart:convert';

import '../auth/secureStorage.dart';
import '../routes/LoginRoute.dart';
import '../utils/Errors.dart';

class LoginController {
  final String username;
  final String password;
  final BuildContext context;
  final SecureStorage secureStorage = SecureStorage();

  LoginController({required this.username, required this.password, required this.context});

  Future<bool> authenticate() async {
    try {
      final LoginRoute loginRoute = LoginRoute(username: username, password: password, context: context);
      final Map<String?, dynamic>? tokenData = await loginRoute.fetchAuthToken();
      if (tokenData != null && tokenData['isAdmin'] != null && tokenData['token'] != null) {
        // Convertir isAdmin a un booleano
        bool isAdmin = tokenData['isAdmin'] == 1;

        // Guarda el token de acceso y el estado de isAdmin utilizando secureStorage
        await secureStorage.saveAccessTokenAndIsAdmin(tokenData['token'], isAdmin);
        return true;
      } else {
        // Manejar el caso en el que el token o sus claves sean nulos
        errorsSnackbar.show(context, 'Error al iniciar sesión usuario o contraseña incorrectos');
        // Indica que la autenticación falló
        return false;
      }
    } catch (e) {
      errorsSnackbar.show(context, 'Error durante la autenticación del usuario');
      // Indica que la autenticación falló debido a un error
      return false;
    }
  }
}
