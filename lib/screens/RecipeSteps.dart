import 'package:flutter/material.dart';
import 'dart:async';
import 'package:myapp/screens/DoNotThrowItAway.dart';

class RecipeSteps extends StatefulWidget {
  const RecipeSteps({Key? key}) : super(key: key);

  @override
  _RecipeStepsState createState() => _RecipeStepsState();
}

class _RecipeStepsState extends State<RecipeSteps> {
  // Lista de ingredientes de ejemplo
  final List<String> ingredients = [
    "250g de pasta",
    "100g de salsa de tomate",
    "Sal al gusto",
  ];

  // Lista de pasos de la receta, con un campo "duration" (en segundos)
  // Si duration es 0, significa que ese paso no requiere cronómetro.
  final List<Map<String, dynamic>> steps = [
    {"description": "Hervir agua y agregar sal.", "duration": 0},
    {"description": "Cocinar la pasta.", "duration": 180},
    {"description": "Escurrir la pasta y servir con salsa.", "duration": 0},
  ];

  int? currentStepIndex;
  Timer? timer;
  int remainingTime = 0;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  // Inicia un temporizador para el paso especificado
  void startTimer(int duration) {
    timer?.cancel();
    setState(() {
      remainingTime = duration;
    });
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (remainingTime <= 0) {
        t.cancel();
      } else {
        setState(() {
          remainingTime--;
        });
      }
    });
  }

  // Construye cada elemento de paso en la lista
  Widget buildStepItem(int index, Map<String, dynamic> step) {
    bool hasTimer = step["duration"] > 0;
    bool isSelected = currentStepIndex == index;
    return Card(
      child: ListTile(
        title: Text(step["description"]),
        subtitle: hasTimer ? Text("Tiempo: ${step["duration"]} seg") : null,
        trailing: hasTimer
            ? isSelected && remainingTime > 0
                ? Text("Restante: $remainingTime seg")
                : ElevatedButton(
                    child: Text("Iniciar"),
                    onPressed: () {
                      setState(() {
                        currentStepIndex = index;
                      });
                      startTimer(step["duration"]);
                    },
                  )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalles de la Receta"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de ingredientes
            Text(
              "Ingredientes",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ...ingredients.map((ingredient) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Text("- $ingredient"),
                )),
            SizedBox(height: 20),
            // Sección de procedimientos
            Text(
              "Procedimientos",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ...steps.asMap().entries.map((entry) {
              return buildStepItem(entry.key, entry.value);
            }).toList(),
            ElevatedButton(
              onPressed: () => {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const DoNotThrowItAway(),
                ))
              },
              child: Text('Te sobraron ingredientes?'),
            ),
          ],
        ),
      ),
    );
  }
}