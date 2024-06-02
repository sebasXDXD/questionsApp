import 'package:flutter/material.dart';
import 'package:shop_app/screens/login_success/login_success_screen.dart';
import 'package:shop_app/components/custom_surfix_icon.dart';
import 'package:shop_app/components/form_error.dart';
import 'package:shop_app/constants.dart';
import 'package:shop_app/helper/keyboard.dart';

import '../../../auth/secureStorage.dart'; // Asegúrate de importar tu clase SecureStorage
import '../../../controller/LoginController.dart';

class SignForm extends StatefulWidget {
  const SignForm({super.key});

  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String? username;
  String? password;
  bool? remember = false;
  final List<String?> errores = [];

  void addError({String? error}) {
    if (!errores.contains(error)) {
      setState(() {
        errores.add(error);
      });
    }
  }

  void removeError({String? error}) {
    if (errores.contains(error)) {
      setState(() {
        errores.remove(error);
      });
    }
  }

  final SecureStorage secureStorage = SecureStorage(); // Instancia de SecureStorage

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.text,
            onSaved: (newValue) => username = newValue,
            onChanged: (value) {
              if (value.isNotEmpty && !value.contains(' ')) {
                removeError(error: kUsernameNullError);
                removeError(error: kUsernameInvalidError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kUsernameNullError);
                return "";
              } else if (value.contains(' ')) {
                addError(error: kUsernameInvalidError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Nombre de usuario",
              hintText: "Introduce tu nombre de usuario",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            obscureText: true,
            onSaved: (newValue) => password = newValue,
            onChanged: (value) {
              if (value.isNotEmpty) {
                removeError(error: kPassNullError);
              } else if (value.length >= 8) {
                removeError(error: kShortPassError);
              }
              return;
            },
            validator: (value) {
              if (value!.isEmpty) {
                addError(error: kPassNullError);
                return "";
              } else if (value.length < 8) {
                addError(error: kShortPassError);
                return "";
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: "Contraseña",
              hintText: "Introduce tu contraseña",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              const Text("Recuérdame"),
              const Spacer(),
            ],
          ),
          FormError(errors: errores),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                KeyboardUtil.hideKeyboard(context);

                // Instancia de LoginController
                LoginController loginController = LoginController(
                  username: username!,
                  password: password!,
                  context: context,
                );

                // Autenticación
                bool isAuthenticated = await loginController.authenticate();

                if (isAuthenticated) {
                  Navigator.pushNamed(context, LoginSuccessScreen.routeName);
                }
              }
            },
            child: const Text("Continuar"),
          ),
        ],
      ),
    );
  }
}

// Define los nuevos errores en constants.dart
const String kUsernameNullError = "Por favor introduce tu nombre de usuario";
const String kUsernameInvalidError = "El nombre de usuario no debe contener espacios";
