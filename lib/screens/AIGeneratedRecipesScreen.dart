import 'package:flutter/material.dart';
import 'package:myapp/models/ai_recipe.dart';
import 'package:myapp/screens/RecipeSteps.dart';

class AIGeneratedRecipesScreen extends StatelessWidget {
  final List<IaRecipe> recipes;

  const AIGeneratedRecipesScreen({Key? key, required this.recipes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recetas Generadas por IA")),
      body: recipes.isEmpty
          ? const Center(child: CircularProgressIndicator())  // Indicador de carga
          : ListView.builder(
              itemCount: recipes.length,
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: Image.network(recipe.image),
                    title: Text(recipe.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(recipe.description),
                        const SizedBox(height: 8),
                        // Mostrar información nutricional
                        Text("Calorías: ${recipe.nutrition['Calorías']}"),
                        Text("Proteínas: ${recipe.nutrition['Proteínas']}"),
                        Text("Grasas: ${recipe.nutrition['Grasas']}"),
                        Text("Carbohidratos: ${recipe.nutrition['Carbohidratos']}"),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeSteps(recipeName: recipe.title),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
