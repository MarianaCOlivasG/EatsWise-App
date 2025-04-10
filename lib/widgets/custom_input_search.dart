

import 'package:flutter/material.dart';
import 'package:myapp/providers/ingredient_provider.dart';
import 'package:myapp/widgets/widgets.dart';
import 'package:provider/provider.dart';


class CustomInputSearch extends StatelessWidget {
  const CustomInputSearch({super.key});

  @override
  Widget build(BuildContext context) {

    final ingredientProvider = Provider.of<IngredientProvider>(context);

    return GestureDetector(
      onTap: () {
        showSearch(
          context: context,
          delegate: InputSearch(ingredients: ingredientProvider.ingredients),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 10),
            Text(
              '¿Qué hay en tu nevera?',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}