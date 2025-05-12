import 'package:flutter/material.dart';
import 'package:myapp/providers/ingredient_provider.dart';
import 'package:myapp/providers/recipe_provider.dart';
import 'package:myapp/theme/my_colors.dart';
import 'package:myapp/widgets/custom_button.dart';
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
            query = '';
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
    return _buildContent(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildContent(context);
  }

  Widget _buildContent(BuildContext context) {
    final provider = Provider.of<IngredientProvider>(context);
    final selected = provider.selectedIngredients;

    final filtered = ingredients
        .where((ingredient) =>
            ingredient['label']!.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Stack(
      children: [
        // Contenido desplazable
        Padding(
          padding: EdgeInsets.only(bottom: selected.isNotEmpty ? 70 : 0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildSelectedIngredients(context),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final ingredient = filtered[index];
                    final isSelected = selected.contains(ingredient['value']);
                    return ListTile(
                      leading: Image.asset(ingredient['image']!),
                      title: Text(ingredient['label']!),
                      trailing: Icon(
                        Icons.check,
                        color: isSelected ? Colors.green : Colors.transparent,
                      ),
                      onTap: () {
                        provider.toggleIngredient(ingredient['value']!);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        // Botón fijo abajo si hay seleccionados
        if (selected.isNotEmpty)
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20
                ),
                width: MediaQuery.of(context).size.width,
                child: CustomButton(
                  text: 'Empezar a cocinar', 
                  color: MyColors.primary,
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => AlertDialog(
                        content: Row(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(width: 20),
                            Expanded(child: Text("Nuestra IA está trabajando...")),
                          ],
                        ),
                      ),
                    );

                    try {
                      final ingredientProvider = Provider.of<IngredientProvider>(context, listen: false);
                      final recipeProvider = Provider.of<RecipeProvider>(context, listen: false);

                      await recipeProvider.getRecipes(ingredientProvider.selectedIngredients);
                    } finally {
                      // Cierra el diálogo después de la petición, incluso si hay error
                      Navigator.of(context).pop();
                    }

                    Navigator.pushNamed(context, 'search');
                  }

                )
                
              ),
            ),
          ),
      ],
    );
  }

  

  Widget _buildSelectedIngredients(BuildContext context) {
  final provider = Provider.of<IngredientProvider>(context);
  final selected = provider.selectedIngredients;

  final selectedData = ingredients
      .where((ingredient) => selected.contains(ingredient['value']))
      .toList();

  if (selectedData.isEmpty) return SizedBox.shrink();

  return SizedBox(
    width: MediaQuery.of(context).size.width,
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Ingredientes seleccionados:",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: selectedData.map((ingredient) {
                return Container(
                  margin: EdgeInsets.only(right: 12),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 30 * 0.7, 
                            backgroundImage: AssetImage(ingredient['image']!),
                          ),
                          SizedBox(height: 6),
                          Text(
                            ingredient['label']!,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 13),
                          ),
                        ],
                      ),
                      Positioned(
                        top: -4,
                        right: -4,
                        child: GestureDetector(
                          onTap: () {
                            provider.toggleIngredient(ingredient['value']!);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            padding: EdgeInsets.all(3),
                            child: Icon(
                              Icons.close,
                              size: 12 * 0.7, // Reducido al 70% del tamaño original (30% más pequeño)
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    ),
  );
}


}
