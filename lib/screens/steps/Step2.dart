import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/providers/stepper_provider.dart';
import 'package:myapp/theme/my_colors.dart';
import 'package:provider/provider.dart';

class Step2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stepperProvider = Provider.of<StepperProvider>(context);
    final String? selectedDate = stepperProvider.getStepData(1, 'birthdate') as String?;

    return Column(
      children: [
        Text('¿Cuál es tu fecha de nacimiento?', style: TextStyle(fontSize: 20)),
        SizedBox(height: 20),
        TextField(
          controller: TextEditingController(text: selectedDate),
          readOnly: true,
          decoration: InputDecoration(
            hintText: 'Selecciona tu fecha de nacimiento',
            hintStyle: TextStyle(color: MyColors.primary),
            suffixIcon: Icon(Icons.calendar_today, color: MyColors.primary),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: MyColors.primary),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyColors.primary),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: MyColors.primary, width: 2.0),
            ),
          ),
          style: TextStyle(color: MyColors.primary),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime(2000, 1, 1),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
              locale: Locale('es', 'ES'), // Español
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: MyColors.primary, // Color principal
                      onPrimary: Colors.white, // Texto en botones
                      onSurface: MyColors.primary, // Texto en calendario
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: MyColors.primary, // Botones de navegación
                      ),
                    ),
                  ),
                  child: child!,
                );
              },
            );

            if (pickedDate != null) {
              String formattedDate =
                  DateFormat('dd/MM/yyyy', 'es').format(pickedDate);
              stepperProvider.setStepData(1, 'birthdate', formattedDate, true);
            }
          },
        ),
      ],
    );
  }
}