import 'package:flutter/material.dart';
import 'package:myapp/providers/stepper_provider.dart';
import 'package:provider/provider.dart';

class Step4 extends StatelessWidget {
  final List<Map<String, String>> _dietOptions = [
    {'label': 'Omnívoro', 'description': 'Como carne', 'value': 'omnivoro'},
    {'label': 'Flexitariano', 'description': 'Intento reducir el consumo de carne', 'value': 'flexitariano'},
    {'label': 'Pescetariano', 'description': 'No como carne pero sí pescado', 'value': 'pescetariano'},
    {'label': 'Vegetariano', 'description': 'No como carne ni pescado', 'value': 'vegetariano'},
    {'label': 'Vegano', 'description': 'Solo como alimentos de origen vegetal', 'value': 'vegano'},
    {'label': 'Otra', 'description': 'Ninguna de la lista', 'value': 'otra'},
  ];

  @override
  Widget build(BuildContext context) {
    final stepperProvider = Provider.of<StepperProvider>(context);
    final selectedDiet = stepperProvider.getStepData(3, 'dietType') as String?;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Selecciona el tipo de dieta que mejor te describe:', style: TextStyle(fontSize: 20)),
        SizedBox(height: 20),
        Column(
          children: _dietOptions.map((diet) {
            return RadioListTile<String>(
              title: Text(diet['label']!),
              subtitle: Text(diet['description']!),
              value: diet['value']!, // Aquí usas el 'value' en minúsculas
              groupValue: selectedDiet,
              onChanged: (String? value) {
                stepperProvider.setStepData(3, 'dietType', value, value != null);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
