import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/RecipeSteps.dart';

class Recipe {
  final String name;
  final String image;

  Recipe({required this.name, required this.image});
}

class RecipeCards extends StatelessWidget {
  final String label;

  const RecipeCards({Key? key, required this.label}) : super(key: key);

  Future<List<Recipe>> getRecipes() async {
    await Future.delayed(Duration(seconds: 2));
    return [
      Recipe(name: 'Pollo con Salsa de limón', image: 'https://picsum.photos/200'),
      Recipe(name: 'Salteado de Repollo con Huevo Frito', image: 'https://picsum.photos/200'),
      Recipe(name: 'Lasaña de Berenjenas con Pollo', image: 'https://picsum.photos/200'),
      Recipe(name: 'Pavo con Pasta y ensalada de Tomate y Aguacate', image: 'https://picsum.photos/200'),
      Recipe(name: 'Albóndigas con Brócoli y Patatas', image: 'https://picsum.photos/200'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder<List<Recipe>>(
      future: getRecipes(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(
            constraints: BoxConstraints(maxWidth: screenWidth * 0.4),
            height: screenHeight * 0.2,
            child: Center(child: CupertinoActivityIndicator()),
          );
        }

        final List<Recipe> recipes = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navegamos a la pantalla que despliega todas las recetas
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllRecipesScreen(),
                        ),
                      );
                    },
                    child: const Text('Ver todas'),
                  )
                ],
              ),
            ),
            SizedBox(
              width: screenWidth,
              height: screenHeight * 0.30,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  return _RecipeCard(
                    recipe: recipe,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  );
                },
              ),
            )
          ],
        );
      },
    );
  }
}

class _RecipeCard extends StatelessWidget {
  final Recipe recipe;
  final double screenWidth;
  final double screenHeight;

  const _RecipeCard({
    Key? key,
    required this.recipe,
    required this.screenWidth,
    required this.screenHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cardWidth = screenWidth * 0.7;
    final cardHeight = screenHeight * 0.23;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            // Navega a la pantalla RecipeSteps sin pasar parámetros
            builder: (context) => const RecipeSteps(),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
        width: cardWidth,
        height: cardHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FadeInImage(
                placeholder: const AssetImage('assets/no-image.png'),
                image: NetworkImage(recipe.image),
                height: cardHeight,
                width: cardWidth,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            Text(
              recipe.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Pantalla que muestra todas las recetas
class AllRecipesScreen extends StatelessWidget {
  const AllRecipesScreen({Key? key}) : super(key: key);

  Future<List<Recipe>> getRecipes() async {
    await Future.delayed(Duration(seconds: 2));
    return [
      Recipe(name: 'Pollo con Salsa de limón', image: 'https://picsum.photos/200'),
      Recipe(name: 'Salteado de Repollo con Huevo Frito', image: 'https://picsum.photos/200'),
      Recipe(name: 'Lasaña de Berenjenas con Pollo', image: 'https://picsum.photos/200'),
      Recipe(name: 'Pavo con Pasta y ensalada de Tomate y Aguacate', image: 'https://picsum.photos/200'),
      Recipe(name: 'Albóndigas con Brócoli y Patatas', image: 'https://picsum.photos/200'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todas las Recetas')),
      body: FutureBuilder<List<Recipe>>(
        future: getRecipes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final recipes = snapshot.data!;
          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              final recipe = recipes[index];
              return ListTile(
                leading: Image.network(
                  recipe.image,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(recipe.name),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      // Navega a RecipeSteps cuando se selecciona una receta
                      builder: (context) => const RecipeSteps()
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}