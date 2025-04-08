import 'package:flutter/material.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:myapp/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          
             GestureDetector(
              onTap: () {
                showSearch(
                  context: context,
                  delegate: InputSearch(
                    ingredients: [
                      {'value': 'pig', 'image': 'assets/icons/cerdo.png', 'label': 'Cerdo'},
                      {'value': 'chicken', 'image': 'assets/icons/cerdo.png', 'label': 'Pollo'},
                      {'value': 'option1', 'image': 'assets/icons/cerdo.png', 'label': 'Option1'},
                      {'value': 'option2', 'image': 'assets/icons/cerdo.png', 'label': 'Option2'},
                      {'value': 'option3', 'image': 'assets/icons/cerdo.png', 'label': 'Option3'},
                      {'value': 'option4', 'image': 'assets/icons/cerdo.png', 'label': 'Option4'},
                    ],
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 10),
                    Text(
                      '¿Qué hay en tu nevera?',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),


          
              
          
              // ElevatedButton(
              //   onPressed: () {
              //      Navigator.pushReplacementNamed(context, 'login');
              //      AuthProvider.removeToken();
              //   }, 
              //   child: Text('SALIR')
              // ),
          
              RecipeCards(),
          
          
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