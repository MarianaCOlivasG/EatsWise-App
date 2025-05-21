import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:myapp/global/environments.dart';
import 'package:http/http.dart' as http;

class RecipeProvider with ChangeNotifier {
  final List<dynamic> _recipes = [];

  List<dynamic> get recipes => _recipes;


  Future<void> getRecipes(List<String> ingredients) async {
  final uri = Uri.parse('${Environments.apiUrl}/ia/recipes');

  try {
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': 'Saúl Espinosa',
        'content': 'Me gustaría cocinar con estos ingredientes principales: "${ingredients.join(',')}".',
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Validación y extracción segura
      if (data['ok'] == true &&
          data['history'] != null &&
          data['history'] is List &&
          data['history'].isNotEmpty) {

        final lastMessage = data['history'].lastWhere((e) => e['role'] == 'assistant');

        // content es un String, así que hay que decodificarlo
        final content = lastMessage['content'];
        final parsedContent = content is String ? jsonDecode(content) : content;

        if (parsedContent is Map && parsedContent['recetas'] is List) {
          final recetas = parsedContent['recetas'];

          _recipes.clear();
          _recipes.addAll(recetas);
          notifyListeners();
        } else {
          print('Contenido del assistant mal formateado o sin recetas');
        }
      } else {
        print('Respuesta inesperada: formato incorrecto');
      }
    } else {
      print('Error al obtener recetas: ${response.statusCode}');
    }
  } catch (e) {
    print('Excepción al obtener recetas: $e');
  }
}
}