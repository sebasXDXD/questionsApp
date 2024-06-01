import 'package:flutter/material.dart';

import 'components/profile_menu.dart';
import 'components/profile_pic.dart';

class ProfileScreen extends StatelessWidget {
  static String routeName = "/profile";

  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            const ProfilePic(),
            const SizedBox(height: 20),
            ProfileMenu(
              text: "Mi Cuenta",
              icon: "assets/icons/User Icon.svg",
              press: () {
                // Implementación de la navegación
              },
            ),
            ProfileMenu(
              text: "Cerrar Sesión",
              icon: "assets/icons/Log out.svg",
              press: () {
                // Implementación de la función de cerrar sesión
              },
            ),
          ],
        ),
      ),
    );
  }
}
