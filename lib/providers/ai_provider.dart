import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ai_recipe.dart';
import 'package:myapp/global/environments.dart';

class IaService {
  static Future<List<IaRecipe>> getRecipesFromPrompt(String prompt, String userName) async {
  final url = Uri.parse('${Environments.apiUrl}/ia');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'content': prompt, 'name': userName}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    if (data['history'] == null || data['history'].isEmpty) {
      throw Exception('La historia está vacía o no existe');
    }

    final assistantContent = data['history'].last['content'];
    if (assistantContent == null) {
      throw Exception('El contenido del asistente es nulo');
    }

    try {
      final List<dynamic> decoded = jsonDecode(assistantContent);
      return decoded.map((e) => IaRecipe.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Error al decodificar el contenido de recetas: $e');
    }
  } else {
    throw Exception('Error al obtener recetas IA: ${response.statusCode}');
  }
}
}