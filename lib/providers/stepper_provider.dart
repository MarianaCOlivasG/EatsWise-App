import 'package:flutter/material.dart';

// class StepperProvider with ChangeNotifier {
//   int _index = 0;
//   final Map<int, dynamic> _formData = {}; // Almacena los valores de cada paso
//   final Map<int, bool> _stepValidity = {}; // Almacena la validez de cada paso

//   int get index => _index;
//   Map<int, dynamic> get formData => _formData;
//   bool get isValid => _stepValidity[_index] ?? false; // Validez del paso actual

//   void nextStep() {
//     if (_index < 5 && isValid) {
//       _index++;
//       notifyListeners();
//     }
//   }

//   void previousStep() {
//     if (_index > 0) {
//       _index--;
//       notifyListeners();
//     }
//   }

//   // Guardar el valor de un paso y su validez
//   void setStepData(int step, dynamic value, bool isValid) {
//     _formData[step] = value;
//     _stepValidity[step] = isValid;
//     notifyListeners();
//   }
// }

class StepperProvider with ChangeNotifier {
  int _index = 0;
  final Map<int, Map<String, dynamic>> _formData = {}; // Almacena los valores de cada paso de manera dinámica
  final Map<int, bool> _stepValidity = {}; // Almacena la validez de cada paso

  int get index => _index;
  Map<int, Map<String, dynamic>> get formData => _formData;
  bool get isValid => _stepValidity[_index] ?? false; // Validez del paso actual

  // Obtener el valor de una propiedad específica en el paso actual
  dynamic getStepData(int step, String property) {
    return _formData[step]?[property];
  }

  void nextStep() {
    if (_index < 5 && isValid) {
      _index++;
      notifyListeners();
    }
  }

  void previousStep() {
    if (_index > 0) {
      _index--;
      notifyListeners();
    }
  }

  // Guardar el valor de un paso y su validez
  void setStepData(int step, String property, dynamic value, bool isValid) {
    // Verifica si el mapa para este paso existe, si no lo crea
    if (_formData[step] == null) {
      _formData[step] = {};
    }
    
    _formData[step]?[property] = value; // Guarda el valor para la propiedad específica
    _stepValidity[step] = isValid;
    notifyListeners();
  }
}
