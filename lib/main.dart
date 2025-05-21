import 'package:flutter/material.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/providers/ingredient_provider.dart';
import 'package:myapp/providers/stepper_provider.dart';
import 'package:myapp/routes/routes.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:myapp/screens/RecipeSteps.dart';
import 'package:myapp/providers/recipe_provider.dart';
import 'package:myapp/screens/RecipeDetailsScreen.dart';  // Importa la pantalla detalle
import 'package:myapp/screens/SearchScreen.dart'; // Importa la pantalla de búsqueda

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => StepperProvider()),
        ChangeNotifierProvider(create: (_) => IngredientProvider()),
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: const Locale('es', 'ES'),
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('es', 'ES'),
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        title: 'Chat',
        routes: {
          ...routes, // Aquí tus rutas normales sin 'recipe-details'
        },
        initialRoute: 'splash',
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
          ),
        ),
        onGenerateRoute: (settings) {
          if (settings.name == 'recipe-steps') {
            final args = settings.arguments;
            if (args is Map<String, String> && args.containsKey('recipeName')) {
              final recipeName = args['recipeName']!;
              return MaterialPageRoute(
                builder: (_) => RecipeSteps(recipeName: recipeName),
              );
            }
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                appBar: AppBar(title: const Text('Error')),
                body: const Center(child: Text('No se proporcionó el nombre de la receta.')),
              ),
            );
          }
          if (settings.name == 'recipe-details') {
            final args = settings.arguments;
            if (args is int) {
              return MaterialPageRoute(
                builder: (_) => RecipeDetailsScreen(recipeIndex: args),
              );
            }
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                appBar: AppBar(title: const Text('Error')),
                body: const Center(child: Text('No se proporcionó el índice de la receta.')),
              ),
            );
          }
          if (settings.name == 'search') {
            return MaterialPageRoute(
              builder: (_) => const SearchScreen(),
            );
          }

          return null; // Otras rutas serán manejadas por `routes`
        },
      ),
    );
  }
}
