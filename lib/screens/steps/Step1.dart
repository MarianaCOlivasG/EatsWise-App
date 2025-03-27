import 'package:flutter/material.dart';
import 'package:myapp/providers/stepper_provider.dart';
import 'package:provider/provider.dart';


class Step1 extends StatelessWidget {
  final List<Map<String, String>> _options = [
    {'label': 'Mujer', 'value': 'F'},
    {'label': 'Hombre', 'value': 'M'},
    {'label': 'Otro', 'value': 'O'},
  ];

  @override
  Widget build(BuildContext context) {
    final stepperProvider = Provider.of<StepperProvider>(context);
    final String? selectedGender = stepperProvider.getStepData(0, 'gender') as String?;

    return Column(
      children: [
        Text('¿Cuál es tu género?', style: TextStyle(fontSize: 20)),
        SizedBox(height: 20),
        Wrap(
          spacing: 10.0,
          children: _options.map((option) {
            return ChoiceChip(
              label: Text(option['label']!),
              selected: selectedGender == option['value'],
              selectedColor: Colors.green.shade100,
              onSelected: (isSelected) {
                // Guardamos el valor de 'value' en lugar de 'label'
                stepperProvider.setStepData(0, 'gender', isSelected ? option['value'] : null, isSelected);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

