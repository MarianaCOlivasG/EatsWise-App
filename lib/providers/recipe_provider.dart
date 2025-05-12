import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:myapp/global/environments.dart';
import 'package:http/http.dart' as http;

class RecipeProvider with ChangeNotifier {
  final List<dynamic> _recipes = [];

  List<dynamic> get recipes => _recipes;

  Future<void> getRecipes(List<String> ingredients) async {
    final uri = Uri.parse('${ Environments.apiUrl }/ia/recipes');

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': 'Mariana',
          'content': 'Me gustaría cocinar con estos ingredientes principales: "${ingredients.join(',')}".'
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        _recipes.clear();
        _recipes.addAll(data);
        notifyListeners();
      } else {
        print('Error al obtener recetas: ${response.statusCode}');
      }
    } catch (e) {
      print('Excepción al obtener recetas: $e');
    }
  }
}
