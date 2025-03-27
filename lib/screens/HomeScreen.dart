
import 'package:flutter/material.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/widgets/ingredient_button.dart';
import 'package:provider/provider.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final authProvider = Provider.of<AuthProvider>(context);


    return Scaffold(
        body: SafeArea(
          child: Center(
            child: Column(
              children: [
                Text('¡Hola ${authProvider.user.profile?.name}!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500
                  ),
                ),

                IngredientButton(
                  onPressed: (){

                  },
                  assetImage: 'assets/icons/cerdo.png',
                ),


                ElevatedButton(
                  onPressed: () {
                     Navigator.pushReplacementNamed(context, 'login');
                     AuthProvider.removeToken();
                  }, 
                  child: Text('SALIR')
                )
              ],
            )
          ),
        )
    );
  }
}