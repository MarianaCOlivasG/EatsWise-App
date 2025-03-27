


import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/screens/HomeScreen.dart';
import 'package:myapp/screens/LoginScreen.dart';
import 'package:provider/provider.dart';


class SplashScreen extends StatelessWidget {

  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkAuthState(context),
        builder: (context, snapshot) {
          return Center(
            child: 
              Platform.isAndroid 
                ? const CircularProgressIndicator(
                    strokeWidth: 2,
                  )
                : const CupertinoActivityIndicator()
          );
        },
      ),
    );
  }


  Future checkAuthState( BuildContext context ) async {

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final isAuthenticated = await authProvider.isLoggedIn();
    
    if ( isAuthenticated ) {

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_,__,___) => const HomeScreen(),
          transitionDuration: const Duration(milliseconds: 0)
        )
      );

    } else {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_,__,___) => const LoginScreen(),
          transitionDuration: const Duration(milliseconds: 0)
        )
      );
    }


  }


}