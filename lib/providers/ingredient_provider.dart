

import 'package:flutter/material.dart';

class IngredientProvider with ChangeNotifier {
  final List<String> _selectedIngredients = [];
  final int maxSelection = 3;

  List<String> get selectedIngredients => _selectedIngredients;

  void toggleIngredient(String value) {
    if (_selectedIngredients.contains(value)) {
      _selectedIngredients.remove(value);
    } else {
      if (_selectedIngredients.length < maxSelection) {
        _selectedIngredients.add(value);
      }
    }
    notifyListeners();
  }
}