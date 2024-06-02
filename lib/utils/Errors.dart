import 'package:flutter/material.dart';
import 'package:shop_app/constants.dart';

class errorsSnackbar {
  static void show(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: Colors.white, // Color del texto
          fontSize: 18,       // Tamaño de fuente
          fontWeight: FontWeight.bold, // Peso de la fuente
        ),
      ),
      backgroundColor: kPrimaryColor, // Color de fondo
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Bordes redondeados
      ),
      behavior: SnackBarBehavior.floating, // Comportamiento flotante
      margin: EdgeInsets.all(16), // Márgenes alrededor del SnackBar
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24), // Relleno interno
      elevation: 8, // Elevación (sombra)
      action: SnackBarAction(
        label: 'OK',
        textColor: Colors.white,
        onPressed: () {
          // Acción a realizar cuando se toca el botón
        },
      ),
      duration: Duration(seconds: 3),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
