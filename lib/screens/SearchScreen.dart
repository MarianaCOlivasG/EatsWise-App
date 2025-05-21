import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/recipe_provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recipes = Provider.of<RecipeProvider>(context).recipes;

    return Scaffold(
      appBar: AppBar(title: const Text('Recetas')),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return RecipeCard(
            title: recipe['title'] ?? 'Sin título',
            description: recipe['description'] ?? '',
            imageUrl: recipe['image'],
            index: index,
          );
        },
      ),
    );
  }
}


class RecipeCard extends StatelessWidget {
  final String title;
  final String description;
  final String? imageUrl;
  final int index;

  const RecipeCard({
    super.key,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, 'recipe-details', arguments: index);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 219, 172, 172),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 3))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  image: DecorationImage(image: NetworkImage(imageUrl!), fit: BoxFit.cover),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
              child: Text(description, maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}

