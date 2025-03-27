import 'package:flutter/material.dart';
import 'package:myapp/providers/stepper_provider.dart';
import 'package:provider/provider.dart';

class Step5 extends StatelessWidget {
  final List<Map<String, String>> _allergyOptions = [
    {'label': 'Huevo', 'value': 'huevo'},
    {'label': 'Marisco', 'value': 'marisco'},
    {'label': 'Lactosa', 'value': 'lactosa'},
    {'label': 'Gluten', 'value': 'gluten'},
    {'label': 'Frutos secos', 'value': 'frutos_secos'},
  ];

  @override
  Widget build(BuildContext context) {
    final stepperProvider = Provider.of<StepperProvider>(context);
    final List<String> selectedAllergies = stepperProvider.getStepData(4, 'allergies') as List<String>? ?? [];

    // Usamos addPostFrameCallback para asegurarnos de que el setStepData se ejecute después del build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Asegurarnos de que el paso sea válido al iniciar, incluso si no hay alergias seleccionadas
      if (selectedAllergies.isEmpty) {
        stepperProvider.setStepData(4, 'allergies', selectedAllergies, true); // Siempre válido
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('¿Tienes alguna alergia o intolerancia alimentaria?', style: TextStyle(fontSize: 20)),
        SizedBox(height: 20),
        Wrap(
          spacing: 10.0, // Espacio entre las opciones
          children: _allergyOptions.map((option) {
            return ChoiceChip(
              label: Text(option['label']!),
              selected: selectedAllergies.contains(option['value']!), // Comparar con el valor
              selectedColor: Colors.green.shade100,
              onSelected: (isSelected) {
                List<String> updatedAllergies = List.from(selectedAllergies);
                if (isSelected) {
                  updatedAllergies.add(option['value']!);  // Agregar opción si está seleccionada
                } else {
                  updatedAllergies.remove(option['value']!);  // Eliminar opción si se deselecciona
                }
                // Actualizamos el paso con las alergias seleccionadas
                stepperProvider.setStepData(4, 'allergies', updatedAllergies, true); // Siempre válido
              },
            );
          }).toList(),
        ),
        SizedBox(height: 20),
        Text('Aviso Importante', style: TextStyle(fontSize: 18)),
        Text(
          'Si no estás seguro o tienes dudas, consulta con un médico.',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
