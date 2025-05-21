import 'package:flutter/material.dart';
import 'package:myapp/providers/recipe_provider.dart';
import 'package:provider/provider.dart';

class RecipeDetailsScreen extends StatelessWidget {
  final int recipeIndex;

  const RecipeDetailsScreen({Key? key, required this.recipeIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recipes = Provider.of<RecipeProvider>(context).recipes;

    // Validar que el índice sea válido
    if (recipeIndex < 0 || recipeIndex >= recipes.length) {
      return Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Receta no encontrada')),
      );
    }

    final recipe = recipes[recipeIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe['title'] ?? 'Sin título'),
      ),
      body: SingleChildScrollView(
        child: RecipeDetailsCard(
          label: recipe['title'] ?? 'Sin título',
          imageUrl: recipe['image'],
          description: recipe['description'],
        ),
      ),
    );
  }
}

// El RecipeDetailsCard se queda igual que antes, sin cambios
class RecipeDetailsCard extends StatelessWidget {
  final String label;
  final String? imageUrl;
  final String? description;

  const RecipeDetailsCard({
    Key? key,
    required this.label,
    this.imageUrl,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.png'),
                image: NetworkImage(imageUrl!),
                width: double.infinity,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              label,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          if (description != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
              child: Text(
                description!,
                style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              ),
            ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
