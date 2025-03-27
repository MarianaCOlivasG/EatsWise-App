import 'package:flutter/material.dart';
import 'package:myapp/providers/stepper_provider.dart';
import 'package:provider/provider.dart';

class Step3 extends StatelessWidget {
  final List<Map<String, String>> _skillLevels = [
    {'label': 'Bajo', 'description': '¿El cereal con leche cuenta como cocinar?', 'value': 'low'},
    {'label': 'Medio', 'description': 'Me defiendo con recetas sencillas', 'value': 'medium'},
    {'label': 'Alto', 'description': 'Es mi pasatiempo favorito', 'value': 'high'},
  ];

  @override
  Widget build(BuildContext context) {
    final stepperProvider = Provider.of<StepperProvider>(context);
    final selectedSkill = stepperProvider.getStepData(2, 'cookingSkill') as String?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('¿Cuál es tu nivel de habilidad en cocina?', style: TextStyle(fontSize: 20)),
        SizedBox(height: 20),
        Column(
          children: _skillLevels.map((skill) {
            return RadioListTile<String>(
              title: Text(skill['label']!),
              subtitle: Text(skill['description']!),
              value: skill['value']!, // Usamos 'value' para el valor de la habilidad
              groupValue: selectedSkill,
              onChanged: (String? value) {
                stepperProvider.setStepData(2, 'cookingSkill', value, value != null);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
