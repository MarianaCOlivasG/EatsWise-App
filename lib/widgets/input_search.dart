import 'package:flutter/material.dart';
import 'package:myapp/providers/ingredient_provider.dart';
import 'package:provider/provider.dart';

class InputSearch extends SearchDelegate<String> {
  final List<Map<String, String>> ingredients;

  InputSearch({required this.ingredients});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = '';  // Limpiar el texto de búsqueda
          },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return BackButton();
  }

  @override
  Widget buildResults(BuildContext context) {
    return Column(
      children: [
        // Mostrar los ingredientes seleccionados
        if (query.isNotEmpty) _buildSelectedIngredients(context),

        // Mostrar la lista de ingredientes disponibles
        Expanded(child: _buildIngredientList(context)),
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = ingredients
        .where((ingredient) =>
            ingredient['label']!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final ingredient = suggestions[index];
        return ListTile(
          leading: Image.asset(ingredient['image']!),
          title: Text(ingredient['label']!),
          trailing: Icon(
            Icons.check,
            color: Provider.of<IngredientProvider>(context)
                    .selectedIngredients
                    .contains(ingredient['value'])
                ? Colors.green
                : Colors.transparent,
          ),
          onTap: () {
            // Actualizar la selección usando el Provider
            Provider.of<IngredientProvider>(context, listen: false)
                .toggleIngredient(ingredient['value']!);
          },
        );
      },
    );
  }

  // Construir los ingredientes seleccionados
  Widget _buildSelectedIngredients(BuildContext context) {
    final selectedIngredients =
        Provider.of<IngredientProvider>(context).selectedIngredients;

    return Container(
      padding: EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Ingredientes seleccionados:',
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: selectedIngredients.map((ingredient) {
              return Chip(
                label: Text(ingredient),
                onDeleted: () => Provider.of<IngredientProvider>(context,
                        listen: false)
                    .toggleIngredient(ingredient),
                deleteIcon: Icon(Icons.close),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Construir la lista de ingredientes filtrados por query
  Widget _buildIngredientList(BuildContext context) {
    // Filtrar los ingredientes según el query de búsqueda
    final filteredIngredients = ingredients
        .where((ingredient) =>
            ingredient['label']!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: filteredIngredients.length,
      itemBuilder: (context, index) {
        final ingredient = filteredIngredients[index];
        return ListTile(
          leading: Image.asset(ingredient['image']!),
          title: Text(ingredient['label']!),
          trailing: Icon(
            Icons.check,
            color: Provider.of<IngredientProvider>(context)
                    .selectedIngredients
                    .contains(ingredient['value'])
                ? Colors.green
                : Colors.transparent,
          ),
          onTap: () {
            // Actualizar la selección usando el Provider
            Provider.of<IngredientProvider>(context, listen: false)
                .toggleIngredient(ingredient['value']!);
          },
        );
      },
    );
  }
}
