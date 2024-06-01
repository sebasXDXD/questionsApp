import 'package:flutter/material.dart';
import 'package:shop_app/screens/init_screen.dart';
import '../../auth/secureStorage.dart';

class LoginSuccessScreen extends StatelessWidget {
  static String routeName = "/login_success";

  const LoginSuccessScreen({super.key});

  Future<void> _getUserInfo() async {
    final secureStorage = SecureStorage();
    final token = await secureStorage.getAccessToken();
    final isAdmin = await secureStorage.getIsAdmin();

    // Aquí puedes usar el token y el estado de isAdmin según sea necesario
    print('Token: $token');
    print('Admin: ${isAdmin == true ? "Sí" : "No"}');
  }

  @override
  Widget build(BuildContext context) {
    // Utiliza WidgetsBinding.instance.addPostFrameCallback para obtener la información del usuario después de que se construya la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) => _getUserInfo());

    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: const Text("Inicio de Sesión Exitoso"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Image.asset(
            "assets/images/success.png",
            height: MediaQuery.of(context).size.height * 0.4, // 40%
          ),
          const SizedBox(height: 16),
          const Text(
            "¡Inicio de Sesión Exitoso!",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, InitScreen.routeName);
              },
              child: const Text("¡Comencemos!"),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
