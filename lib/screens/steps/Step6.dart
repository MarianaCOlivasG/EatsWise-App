import 'package:flutter/material.dart';

class Step6 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Logo de la aplicación
        Image.asset(
          'assets/logo.png', // Asegúrate de tener el logo en la carpeta de assets
          height: 200.0, // Puedes ajustar el tamaño según lo necesites
        ),
        SizedBox(height: 20),
        
        // Mensaje de agradecimiento
        Text(
          '¡Gracias por proporcionarnos tus datos! \nNuestra IA trabajará para brindarte recetas saludables y económicas, adaptadas a tus preferencias y necesidades.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 20),
        
        // Puedes añadir algún botón o cualquier otro widget si es necesario.
      ],
    );
  }
}
