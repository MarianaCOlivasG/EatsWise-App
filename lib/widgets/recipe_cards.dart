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
      Recipe(name: 'Pollo con Salsa de limón', image: 'assets/RecipesIcons/pollo-al-limon.jpg'),
      Recipe(name: 'Salteado de Repollo con Huevo Frito', image: 'assets/RecipesIcons/repollo-salteado-huevo.jpg'),
      Recipe(name: 'Lasaña de Berenjenas con Pollo', image: 'assets/RecipesIcons/Lasaña-de-pollo-y-berenjena.jpg'),
      Recipe(name: 'Pavo con Pasta y ensalada de Tomate y Aguacate', image: 'assets/RecipesIcons/ensalada-de-pasta-y-pavo.jpg'),
      Recipe(name: 'Albóndigas con Brócoli y Patatas', image: 'assets/RecipesIcons/albondigas-de-brocoli-patata.jpg'),
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
            child: const Center(child: CupertinoActivityIndicator()),
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
                  Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AllRecipesScreen()),
                      );
                    },
                    child: const Text('Ver todas', style: TextStyle(color: Colors.green)),
                  ),
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
          MaterialPageRoute(builder: (context) => RecipeSteps(recipeName: recipe.name)),
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
                image: AssetImage(recipe.image),
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

class AllRecipesScreen extends StatefulWidget {
  const AllRecipesScreen({Key? key}) : super(key: key);

  @override
  State<AllRecipesScreen> createState() => _AllRecipesScreenState();
}

class _AllRecipesScreenState extends State<AllRecipesScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Recipe> _allRecipes = [];
  List<Recipe> _filteredRecipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadRecipes();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredRecipes = _allRecipes.where((recipe) {
        return recipe.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> loadRecipes() async {
    await Future.delayed(Duration(seconds: 2));
    final recipes = [
      Recipe(name: 'Pollo con Salsa de limón', image: 'assets/RecipesIcons/pollo-al-limon.jpg'),
      Recipe(name: 'Salteado de Repollo con Huevo Frito', image: 'assets/RecipesIcons/repollo-salteado-huevo.jpg'),
      Recipe(name: 'Lasaña de Berenjenas con Pollo', image: 'assets/RecipesIcons/Lasaña-de-pollo-y-berenjena.jpg'),
      Recipe(name: 'Pavo con Pasta y ensalada de Tomate y Aguacate', image: 'assets/RecipesIcons/ensalada-de-pasta-y-pavo.jpg'),
      Recipe(name: 'Albóndigas con Brócoli y Patatas', image: 'assets/RecipesIcons/albondigas-de-brocoli-patata.jpg'),
    ];
    setState(() {
      _allRecipes = recipes;
      _filteredRecipes = recipes;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todas las Recetas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar receta por nombre...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          if (_isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_filteredRecipes.isEmpty)
            const Expanded(child: Center(child: Text('No se encontraron recetas')))
          else
            Expanded(
              child: ListView.builder(
                itemCount: _filteredRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = _filteredRecipes[index];
                  return ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.asset(
                        recipe.image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    title: Text(recipe.name),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => RecipeSteps(recipeName: recipe.name)),
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
