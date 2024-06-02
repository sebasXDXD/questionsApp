# QuestionsApp

## Descripción

**QuestionsApp** es una aplicación de Flutter diseñada para gestionar y responder cuestionarios. La aplicación incluye una variedad de pantallas, desde la pantalla de inicio hasta pantallas de administración para gestionar preguntas y cuestionarios. La aplicación es compatible con Android e iOS.

## Características

1. **Pantallas de Autenticación:**
    - **Inicio**: La primera pantalla que se muestra al iniciar la aplicación.
    - **Pantalla de bienvenida**: Pantalla de bienvenida que se muestra al abrir la aplicación.
    - **Iniciar Sesión**: Pantalla para que los usuarios ingresen sus credenciales.
    - **Registro Exitoso**: Pantalla que se muestra después de un inicio de sesión exitoso.
    - **Registrarse**: Pantalla para que los nuevos usuarios se registren.

2. **Pantallas del Usuario:**
    - **Perfil**: Pantalla donde los usuarios pueden ver y editar su perfil.
    - **Cuestionario**: Pantalla donde los usuarios pueden ver y responder cuestionarios.

3. **Pantallas de Administración:**
    - **Ver Preguntas de Administración**: Pantalla donde los administradores pueden revisar las preguntas.
    - **Formulario de Cuestionario de Administración**: Pantalla para que los administradores creen y editen cuestionarios.

## Rutas

```dart
import 'package:flutter/widgets.dart';
import 'package:shop_app/screens/admin_check_questions/admin_check_questions_screen.dart';
import 'package:shop_app/screens/questionnaire/questionaire_screen.dart';
import 'screens/admin_form_questionnaire/form_quesntionnaire_screen.dart';
import 'screens/init_screen.dart';
import 'screens/login_success/login_success_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'screens/sign_in/sign_in_screen.dart';
import 'screens/sign_up/sign_up_screen.dart';
import 'screens/splash/splash_screen.dart';

// Usamos rutas con nombre
// Todas nuestras rutas estarán disponibles aquí
final Map<String, WidgetBuilder> rutas = {
  InitScreen.routeName: (context) => const InitScreen(),
  SplashScreen.routeName: (context) => const SplashScreen(),
  SignInScreen.routeName: (context) => const SignInScreen(),
  LoginSuccessScreen.routeName: (context) => const LoginSuccessScreen(),
  SignUpScreen.routeName: (context) => const SignUpScreen(),
  ProfileScreen.routeName: (context) => const ProfileScreen(),
  QuestionnaireScreen.routeName: (context) => const QuestionnaireScreen(),
  AdminCheckQuestionsScreen.routeName: (context) =>
      const AdminCheckQuestionsScreen(),
  FormQuestionnaireScreen.routeName: (context) =>
      const FormQuestionnaireScreen()
};
