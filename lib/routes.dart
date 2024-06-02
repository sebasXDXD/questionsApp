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

// We use name route
// All our routes will be available here
final Map<String, WidgetBuilder> routes = {
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
