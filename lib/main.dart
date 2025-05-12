import 'package:flutter/material.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/providers/ingredient_provider.dart';
import 'package:myapp/providers/recipe_provider.dart';
import 'package:myapp/providers/stepper_provider.dart';
import 'package:myapp/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Importar esto

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider( create: (_) => AuthProvider() ),
        ChangeNotifierProvider( create: (_) => StepperProvider() ),
        ChangeNotifierProvider( create: (_) => IngredientProvider() ),
        ChangeNotifierProvider( create: (_) => RecipeProvider() ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: Locale('es', 'ES'), // Establece el idioma español
        supportedLocales: [
          Locale('en', 'US'),
          Locale('es', 'ES'),
        ],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        title: 'Chat',
        routes: routes,
        initialRoute: 'splash',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white, 
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.white
          )
        ),
      ),
    );
  }
}