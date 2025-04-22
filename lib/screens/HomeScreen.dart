import 'package:flutter/material.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/screens/LoginScreen.dart';
import 'package:myapp/screens/RecipeSteps.dart';
import 'package:myapp/screens/StoreUnionScreen.dart';
import 'package:provider/provider.dart';
import 'package:myapp/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [

            SizedBox(
              height: 20,
            ),

            Text(
              '¡Hola ${authProvider.user.profile?.name}!',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            
            SizedBox(
              height: 20,
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20
              ),
              child: CustomInputSearch(),
            ),

            SizedBox(
              height: 20,
            ),

            ElevatedButton(
              onPressed: () => {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const StoreUnionScreen(),
                ))
              },
              child: Text('Comprar ingredientes'),
            ),

            RecipeCards(
              label: 'Nuevas recetas',
            ),

            RecipeCards(
              label: 'Recomendadas para ti',
            ),
          ],
        ),
      ),
    );
  }
}