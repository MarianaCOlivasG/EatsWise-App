import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Recipe {
  final String name;
  final String image;

  Recipe({required this.name, required this.image});
}

class RecipeCards extends StatelessWidget {

  final String label;

  const RecipeCards({super.key, required this.label});

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

    return FutureBuilder(
      future: getRecipes(),
      builder: (_, AsyncSnapshot<List<Recipe>> snapshot) {
        if (!snapshot.hasData) {
          return Container(
            constraints: BoxConstraints(maxWidth: screenWidth * 0.4),
            height: screenHeight * 0.2,
            child: Center(child: CupertinoActivityIndicator()),
          );
        }

        final List<Recipe> cast = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text( label ,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      
                    }, 
                    child: Text('Ver todas')
                  )
                ],
              ),
            ),
            
            SizedBox(
              width: screenWidth,
              height: screenHeight * 0.30,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: cast.length,
                itemBuilder: (_, int index) => _RecipeCard(cast[index], screenWidth, screenHeight),
              ),
            ),
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

  const _RecipeCard(this.recipe, this.screenWidth, this.screenHeight);

  @override
  Widget build(BuildContext context) {
    final cardWidth = screenWidth * 0.7; // 80% of the screen width
    final cardHeight = screenHeight * 0.23; // 20% of the screen height

    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.02), // Margin for overlap
      width: cardWidth,
      height: cardHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: FadeInImage(
              placeholder: AssetImage('assets/no-image.png'),
              image: NetworkImage(recipe.image),
              height: cardHeight, // 85% of the card height for the image
              width: cardWidth, // Full width of the card
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          Text(
            recipe.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.left, // Align text to the left
            style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
