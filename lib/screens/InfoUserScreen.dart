import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myapp/helpers/show_alert.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/providers/stepper_provider.dart';
import 'package:myapp/screens/steps/index.dart';
import 'package:myapp/theme/my_colors.dart';
import 'package:myapp/widgets/widgets.dart';
import 'package:provider/provider.dart';

class InfoUser extends StatelessWidget {
  const InfoUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: StepperExample()),
    );
  }
}

class StepperExample extends StatelessWidget {
  const StepperExample({super.key});

  @override
  Widget build(BuildContext context) {
    double stepWidth = MediaQuery.of(context).size.width / 6; 

    final stepperProvider = Provider.of<StepperProvider>(context); 
    final authProvider = Provider.of<AuthProvider>(context); 

    return Column(
      children: [
        SizedBox(
          height: 50, 
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(6, (i) => _buildStepIndicator(i, stepWidth)),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _getStepContent(stepperProvider.index), 

                Spacer(),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Usamos esta información para que nuestra IA calcule tus necesidades nutricionales y podamos hacerte recomendaciones personalizadas.',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Row(
                  children: [
                    Flexible(
                      child: CustomButton(
                        text: 'Anterior',
                        color: MyColors.primary,
                        onPressed: stepperProvider.index > 0
                            ? () {
                                stepperProvider.previousStep();
                              }
                            : null,
                      ),
                    ),
                    SizedBox(width: 10),
                    Flexible(
                      child: CustomButton(
                        text: stepperProvider.index == 5 ? 'Empezar' : 'Siguiente',
                        color: MyColors.primary,
                        onPressed: (stepperProvider.index == 5 || stepperProvider.isValid)
                            ? () async {

                                  final Map<String, dynamic> formattedData = {
                                    "uid": authProvider.user.uid
                                  };

                                  if (stepperProvider.index == 5) {
                                    stepperProvider.formData.forEach((key, value) {
                                      formattedData.addAll(value);
                                  });

                                  final completeProfileResponse = await authProvider.completeProfile(formattedData);

                                  if ( !completeProfileResponse.status ) {
                                    showAlert(context, 'Oops!', 'Ocurrio un error. Intentalo de nuevo.' );
                                    return;
                                  }
                  
                                  Navigator.pushReplacementNamed(context, 'home');

                                } else {
                                  stepperProvider.nextStep();
                                }
                              }
                            : null, 
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStepIndicator(int step, double width) {
    return Consumer<StepperProvider>(
      builder: (context, stepperProvider, child) {
        return SizedBox(
          width: width,
          child: Container(
            height: 5,
            color: step <= stepperProvider.index
                ? MyColors.primary
                : MyColors.inputbg,
          ),
        );
      },
    );
  }

  // Método para obtener el contenido de cada paso
  Widget _getStepContent(int step) {
    switch (step) {
      case 0:
        return Step1();
      case 1:
        return Step2();
      case 2:
        return Step3();
      case 3:
        return Step4();
      case 4:
        return Step5();
      case 5:
        return Step6();
      default:
        return Container();
    }
  }
}
