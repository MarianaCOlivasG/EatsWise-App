import 'package:flutter/material.dart';

// Modelo para recetas
class Recipe {
  final String name;
  final List<String> requiredIngredients;

  Recipe({required this.name, required this.requiredIngredients});
}

class DoNotThrowItAway extends StatefulWidget {
  const DoNotThrowItAway({Key? key}) : super(key: key);

  @override
  _DoNotThrowItAwayState createState() => _DoNotThrowItAwayState();
}

class _DoNotThrowItAwayState extends State<DoNotThrowItAway> {
  // Lista de ingredientes sobrantes (simulados)
  List<String> leftovers = [
    'Tomate',
    'Queso',
    'Lechuga',
    'Cebolla',
    'Pollo'
  ];

  // Lista de recetas disponibles
  List<Recipe> allRecipes = [
    Recipe(name: 'Ensalada de Pollo', requiredIngredients: ['Pollo', 'Lechuga', 'Tomate']),
    Recipe(name: 'Quesadilla', requiredIngredients: ['Queso', 'Cebolla']),
    Recipe(name: 'Sopa de Verduras', requiredIngredients: ['Cebolla', 'Zanahoria', 'Papa']),
    Recipe(name: 'Tacos', requiredIngredients: ['Pollo', 'Cebolla', 'Tomate', 'Lechuga']),
  ];

  // Filtrar recetas que se pueden realizar con los ingredientes sobrantes
  List<Recipe> get possibleRecipes {
    return allRecipes.where((recipe) {
      // Verificar que cada ingrediente requerido se encuentre en los leftovers
      return recipe.requiredIngredients.every((ingredient) =>
          leftovers.map((ing) => ing.toLowerCase()).contains(ingredient.toLowerCase()));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('No Desperdicies Ingredientes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Sección de ingredientes sobrantes
            Text(
              'Ingredientes Sobrantes:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: leftovers.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.kitchen),
                    title: Text(leftovers[index]),
                  );
                },
              ),
            ),
            Divider(),
            // Sección de recetas posibles con los ingredientes
            Text(
              'Platillos Posibles:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Expanded(
              flex: 2,
              child: possibleRecipes.isEmpty
                  ? Center(child: Text('No hay recetas disponibles con los ingredientes actuales.'))
                  : ListView.builder(
                      itemCount: possibleRecipes.length,
                      itemBuilder: (context, index) {
                        final recipe = possibleRecipes[index];
                        return Card(
                          elevation: 2,
                          margin: EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            title: Text(recipe.name),
                            subtitle: Text('Ingredientes: ${recipe.requiredIngredients.join(', ')}'),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}