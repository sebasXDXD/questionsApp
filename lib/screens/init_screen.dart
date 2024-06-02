import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/screens/admin_check_questions/admin_check_questions_screen.dart';
import 'package:shop_app/screens/profile/profile_screen.dart';
import 'package:shop_app/screens/questionnaire/questionaire_screen.dart';
import 'package:shop_app/auth/secureStorage.dart'; // Asegúrate de importar tu clase SecureStorage

import 'admin_form_questionnaire/form_quesntionnaire_screen.dart';

const Color inActiveIconColor = Color(0xFFB6B6B6);

class InitScreen extends StatefulWidget {
  const InitScreen({super.key});

  static String routeName = "/";

  @override
  State<InitScreen> createState() => _InitScreenState();
}

class _InitScreenState extends State<InitScreen> {
  int currentSelectedIndex = 0; // Set the initial index to 0 for the default screen
  bool isAdmin = false; // Estado para determinar si es admin
  final SecureStorage secureStorage = SecureStorage(); // Instancia de SecureStorage

  @override
  void initState() {
    super.initState();
    _checkAdminStatus(); // Verificar el estado de admin al inicializar
  }

  Future<void> _checkAdminStatus() async {
    final data = await secureStorage.getAccessTokenAndIsAdmin();
    setState(() {
      isAdmin = data['isAdmin'] ?? false;
    });
  }

  void updateCurrentIndex(int index) {
    setState(() {
      currentSelectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = isAdmin
        ? const [
      AdminCheckQuestionsScreen(),
      FormQuestionnaireScreen(),
    ]
        : const [
      QuestionnaireScreen(),
      ProfileScreen(),
    ];

    final items = isAdmin
        ? [
      BottomNavigationBarItem(
        icon: SvgPicture.asset(
          "assets/icons/Check mark rounde.svg", // Icono de admin check
          colorFilter: const ColorFilter.mode(
            inActiveIconColor,
            BlendMode.srcIn,
          ),
        ),
        activeIcon: SvgPicture.asset(
          "assets/icons/Check mark rounde.svg", // Icono de admin check
          colorFilter: const ColorFilter.mode(
            kPrimaryColor,
            BlendMode.srcIn,
          ),
        ),
        label: "Admin Check",
      ),
      BottomNavigationBarItem(
        icon: SvgPicture.asset(
          "assets/icons/Plus Icon.svg", // Icono para el formulario
          colorFilter: const ColorFilter.mode(
            inActiveIconColor,
            BlendMode.srcIn,
          ),
        ),
        activeIcon: SvgPicture.asset(
          "assets/icons/Plus Icon.svg", // Icono para el formulario
          colorFilter: const ColorFilter.mode(
            kPrimaryColor,
            BlendMode.srcIn,
          ),
        ),
        label: "Form",
      ),
    ]
        : [
      BottomNavigationBarItem(
        icon: SvgPicture.asset(
          "assets/icons/Question mark.svg", // Icono de preguntas
          colorFilter: const ColorFilter.mode(
            inActiveIconColor,
            BlendMode.srcIn,
          ),
        ),
        activeIcon: SvgPicture.asset(
          "assets/icons/Question mark.svg", // Icono de preguntas
          colorFilter: const ColorFilter.mode(
            kPrimaryColor,
            BlendMode.srcIn,
          ),
        ),
        label: "Questions",
      ),
      BottomNavigationBarItem(
        icon: SvgPicture.asset(
          "assets/icons/User Icon.svg", // Icono de perfil
          colorFilter: const ColorFilter.mode(
            inActiveIconColor,
            BlendMode.srcIn,
          ),
        ),
        activeIcon: SvgPicture.asset(
          "assets/icons/User Icon.svg", // Icono de perfil
          colorFilter: const ColorFilter.mode(
            kPrimaryColor,
            BlendMode.srcIn,
          ),
        ),
        label: "Profile",
      ),
    ];

    return Scaffold(
      body: pages[currentSelectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: updateCurrentIndex,
        currentIndex: currentSelectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        items: items,
      ),
    );
  }
}
