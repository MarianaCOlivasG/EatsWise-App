import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: '386351624471-1dcktrmbf0q4ucdqta620bpb0qaic8gt.apps.googleusercontent.com',
    scopes: ['email', 'profile'],
  );

  Future<void> _signInWithGoogle() async {
    try {

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser == null) {
          print("Inicio de sesión cancelado");
          return;
        }

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final String idToken = googleAuth.idToken!;

        print("ID Token: $idToken");

    } catch (error) {
      print("Error en Google Sign-In: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _signInWithGoogle,
      child: Text('Iniciar sesión con Google'),
    );
  }
}
