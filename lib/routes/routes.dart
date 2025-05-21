import 'package:flutter/material.dart';
import 'package:myapp/screens/index.dart';

final Map<String, Widget Function(BuildContext)> routes = {

  'login': (_) => const LoginScreen(),
  'register': (_) => const RegisterScreen(),
  'register-form': (_) => const RegisterFormScreen(),
  'home': (_) => const HomeScreen(),
  'splash': (_) => const SplashScreen(),
  'info-user': (_) => const InfoUser(),
  'search': (_) => const SearchScreen(),
  //'details': (_) => const RecipeDetailsScreen(),
  'do-not-throw-it-away': (_) => const DoNotThrowItAway(),
  //'recipe-steps': (_) => const RecipeSteps(),
  'store-union': (_) => const StoreUnionScreen(),
};