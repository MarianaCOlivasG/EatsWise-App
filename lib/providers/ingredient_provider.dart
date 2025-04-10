

import 'package:flutter/material.dart';

class IngredientProvider with ChangeNotifier {

  final List<Map<String, String>> ingredients = [
    {'value': 'cerdo', 'image': 'assets/icons/cerdo.png', 'label': 'Cerdo'},
    {'value': 'arroz', 'image': 'assets/icons/arroz.png', 'label': 'Arroz'},
    {'value': 'res', 'image': 'assets/icons/carne.png', 'label': 'Res'},
    {'value': 'cebolla', 'image': 'assets/icons/cebolla.png', 'label': 'Cebolla'},
    {'value': 'fresa', 'image': 'assets/icons/fresa.png', 'label': 'Fresa'},
    {'value': 'huevo', 'image': 'assets/icons/huevo.png', 'label': 'Huevo'},
    {'value': 'leche', 'image': 'assets/icons/leche.png', 'label': 'Leche'},
    {'value': 'tomate', 'image': 'assets/icons/tomate.png', 'label': 'Tomate'},
    {'value': 'tomate2', 'image': 'assets/icons/tomate.png', 'label': 'Tomate2'},
    {'value': 'tomate3', 'image': 'assets/icons/tomate.png', 'label': 'Tomate3'},
    {'value': 'tomate4', 'image': 'assets/icons/tomate.png', 'label': 'Tomate4'},
  ];

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