import 'package:flutter/material.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/widgets/ingredient_button.dart';
import 'package:provider/provider.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final List<Map<String, String>> ingredients = [
    {'value': 'pig', 'image': 'assets/icons/cerdo.png', 'label': 'Cerdo'},
    {'value': 'chicken', 'image': 'assets/icons/cerdo.png', 'label': 'Pollo'},
    {'value': 'option1', 'image': 'assets/icons/cerdo.png', 'label': 'option1'},
    {'value': 'option2', 'image': 'assets/icons/cerdo.png', 'label': 'option2'},
    {'value': 'option3', 'image': 'assets/icons/cerdo.png', 'label': 'option3'},
    {'value': 'option4', 'image': 'assets/icons/cerdo.png', 'label': 'option4'},
  ];

  final List<Map<String, String>> selectedIngredients = [];

  void toggleSelection(Map<String, String> ingredient) {
    setState(() {
      if (selectedIngredients.contains(ingredient)) {
        selectedIngredients.remove(ingredient);
      } else {
        if (selectedIngredients.length < 3) {
          selectedIngredients.add(ingredient);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Text('¡Hola ${authProvider.user.profile?.name}!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500
                ),
              ),
              if (selectedIngredients.isNotEmpty) _buildSelectedIngredients(),
              if (selectedIngredients.length < 3) Expanded(child: _buildIngredientList()),

              if (selectedIngredients.length == 3)  ElevatedButton(
                onPressed: () {
                  print('Mostar recetas con estos ingredientes');
                }, 
                child: Text('Empezar a cocinar')
              ),

              ElevatedButton(
                onPressed: () {
                   Navigator.pushReplacementNamed(context, 'login');
                   AuthProvider.removeToken();
                }, 
                child: Text('SALIR')
              )
            ],
          ),
        )
    );
  }

  Widget _buildSelectedIngredients() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20
      ),
      child: SizedBox(
        height: selectedIngredients.isNotEmpty ? 100 : 0,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: selectedIngredients.length,
          itemBuilder: (context, index) {
            final ingredient = selectedIngredients[index];
            return Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(ingredient['image']!),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => toggleSelection(ingredient),
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.red,
                          child: Icon(Icons.close, size: 16, color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 4),
                Text(
                  ingredient['label']!,
                  style: TextStyle(fontSize: 12),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildIngredientList() {
    return ListView.builder(
      itemCount: ingredients.length,
      itemBuilder: (context, index) {
        final ingredient = ingredients[index];
        return ListTile(
          leading: Image.asset(ingredient['image']!),
          title: Text(ingredient['label']!),
          trailing: selectedIngredients.contains(ingredient)
              ? Icon(Icons.check, color: Colors.green)
              : null,
          onTap: () => toggleSelection(ingredient),
        );
      },
    );
  }
}