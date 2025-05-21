import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'DoNotThrowItAway.dart';
import '../models/ai_recipe.dart'; // Asegúrate de importar tu modelo aquí

class RecipeSteps extends StatefulWidget {
  final String? recipeName;
  final List<Ingredient>? dynamicIngredients;
  final List<StepDetail>? dynamicSteps;
  final Map<String, String>? dynamicNutrition;

  const RecipeSteps({
    Key? key,
    this.recipeName,
    this.dynamicIngredients,
    this.dynamicSteps,
    this.dynamicNutrition,
  }) : super(key: key);

  @override
  _RecipeStepsState createState() => _RecipeStepsState();
}

class _RecipeStepsState extends State<RecipeSteps> {
  late List<String> ingredients;
  late List<Map<String, dynamic>> steps;
  late Map<String, String> nutrition;

  final AudioPlayer alarmPlayer = AudioPlayer();
  Timer? timer;
  int? activeStepIndex;
  int remainingTime = 0;
  Set<int> completedSteps = {};

  @override
  void initState() {
    super.initState();

    if (widget.dynamicIngredients != null &&
        widget.dynamicSteps != null) {
      // Receta generada por IA
      ingredients = widget.dynamicIngredients!
          .map((e) => "${e.amount} ${e.name}")
          .toList();
      steps = widget.dynamicSteps!
          .map((e) => {
                'description': e.description,
                'duration': e.timer,
              })
          .toList();
      nutrition = widget.dynamicNutrition ?? {};
      setState(() {});
    } else if (widget.recipeName != null) {
      // Receta local
      loadRecipeData(widget.recipeName!);
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    alarmPlayer.dispose();
    super.dispose();
  }

  void loadRecipeData(String recipeName) {
    final Map<String, List<String>> recipeIngredients = {
      'Pollo con Salsa de limón': ['2 pechugas de pollo', '1 limón', 'Sal y pimienta', 'Aceite de oliva'],
      'Salteado de Repollo con Huevo Frito': ['1 repollo', '2 huevos', 'Aceite', 'Sal'],
      'Lasaña de Berenjenas con Pollo': ['2 berenjenas', '150g pollo', 'Queso', 'Salsa de tomate'],
      'Pavo con Pasta y ensalada de Tomate y Aguacate': ['150g pavo', 'Pasta', 'Tomate', 'Aguacate'],
      'Albóndigas con Brócoli y Patatas': ['Albóndigas', 'Brócoli', 'Patatas', 'Sal y pimienta'],
    };

    final Map<String, List<Map<String, dynamic>>> recipeSteps = {
      'Pollo con Salsa de limón': [
        {"description": "Sazonar el pollo.", "duration": 0},
        {"description": "Cocinar en sartén 7 minutos.", "duration": 7},
        {"description": "Exprimir limón sobre el pollo y servir.", "duration": 0},
      ],
      'Salteado de Repollo con Huevo Frito': [
        {"description": "Cortar el repollo.", "duration": 0},
        {"description": "Saltearlo 5 minutos.", "duration": 5},
        {"description": "Freír el huevo y servir.", "duration": 3},
      ],
      'Lasaña de Berenjenas con Pollo': [
        {"description": "Cortar las berenjenas en láminas.", "duration": 0},
        {"description": "Cocinar el pollo con salsa.", "duration": 5},
        {"description": "Hornear la lasaña 10 minutos.", "duration": 10},
      ],
      'Pavo con Pasta y ensalada de Tomate y Aguacate': [
        {"description": "Cocer la pasta.", "duration": 5},
        {"description": "Cocinar el pavo.", "duration": 7},
        {"description": "Cortar tomate y aguacate y mezclar.", "duration": 0},
      ],
      'Albóndigas con Brócoli y Patatas': [
        {"description": "Cocer las patatas.", "duration": 8},
        {"description": "Cocer el brócoli.", "duration": 5},
        {"description": "Freír las albóndigas.", "duration": 6},
      ],
    };

    final Map<String, Map<String, String>> recipeNutrition = {
      'Pollo con Salsa de limón': {
        'Calorías': '250 kcal',
        'Proteínas': '30 g',
        'Grasas': '10 g',
        'Carbohidratos': '5 g'
      },
      'Salteado de Repollo con Huevo Frito': {
        'Calorías': '180 kcal',
        'Proteínas': '12 g',
        'Grasas': '8 g',
        'Carbohidratos': '10 g'
      },
      'Lasaña de Berenjenas con Pollo': {
        'Calorías': '320 kcal',
        'Proteínas': '25 g',
        'Grasas': '15 g',
        'Carbohidratos': '18 g'
      },
      'Pavo con Pasta y ensalada de Tomate y Aguacate': {
        'Calorías': '400 kcal',
        'Proteínas': '35 g',
        'Grasas': '18 g',
        'Carbohidratos': '30 g'
      },
      'Albóndigas con Brócoli y Patatas': {
        'Calorías': '350 kcal',
        'Proteínas': '20 g',
        'Grasas': '20 g',
        'Carbohidratos': '25 g'
      },
    };

    ingredients = recipeIngredients[recipeName] ?? [];
    steps = recipeSteps[recipeName] ?? [];
    nutrition = recipeNutrition[recipeName] ?? {};
    setState(() {});
  }

  void startTimer(int index) {
    final duration = steps[index]['duration'] as int;
    if (duration > 0) {
      setState(() {
        activeStepIndex = index;
        remainingTime = duration;
      });
      timer?.cancel();
      timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        if (remainingTime > 1) {
          setState(() => remainingTime--);
        } else {
          t.cancel();
          setState(() => remainingTime = 0);
          playAlarm();
        }
      });
    }
  }

  void completeStep(int index) {
    setState(() {
      completedSteps.add(index);
      if (index == activeStepIndex) {
        timer?.cancel();
        alarmPlayer.stop();
        activeStepIndex = null;
        remainingTime = 0;
      }
    });

    if (completedSteps.length == steps.length) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('¡Felicidades!'),
          content: Row(
            children: const [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 10),
              Text('Terminaste el platillo.'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      );
    }
  }

  void playAlarm() async {
    await alarmPlayer.play(AssetSource('alarm.mp3'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.recipeName ?? 'Receta')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Ingredientes:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ...ingredients.map((i) => Text(i)),
            const SizedBox(height: 16),
            const Text("Información nutricional:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ...nutrition.entries.map((entry) => Text("${entry.key}: ${entry.value}")),
            const SizedBox(height: 24),
            const Text("Pasos:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            for (int i = 0; i < steps.length; i++) buildStepCard(i),
            const SizedBox(height: 24),
            if (completedSteps.length == steps.length)
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DoNotThrowItAway()),
                ),
                child: const Text('¿Te sobraron ingredientes?'),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildStepCard(int index) {
    final step = steps[index];
    final isActive = index == activeStepIndex;
    final isCompleted = completedSteps.contains(index);
    final isStepAvailable = completedSteps.length >= index;

    return Card(
      color: isCompleted ? Colors.green[100] : Colors.white,
      child: ListTile(
        title: Text("Paso ${index + 1}: ${step['description']}"),
        subtitle: step['duration'] > 0
            ? Text(isActive
                ? "Tiempo restante: $remainingTime s"
                : "Duración: ${step['duration']} min")
            : null,
        trailing: ElevatedButton(
          onPressed: isCompleted
              ? null
              : (isStepAvailable
                  ? () {
                      if (isActive || step['duration'] == 0) {
                        completeStep(index);
                      } else {
                        startTimer(index);
                      }
                    }
                  : null),
          child: Text(isCompleted
              ? 'Completado'
              : (isActive ? 'Listo' : (step['duration'] > 0 ? 'Iniciar' : 'Listo'))),
        ),
      ),
    );
  }
}
