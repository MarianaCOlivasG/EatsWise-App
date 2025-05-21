import 'package:flutter/material.dart';
import 'package:myapp/providers/auth_provider.dart';
import 'package:myapp/screens/AIGeneratedRecipesScreen.dart';
import 'package:myapp/screens/ProfileScreen.dart';
import 'package:myapp/screens/StoreUnionScreen.dart';
import 'package:provider/provider.dart';
import 'package:myapp/providers/ai_provider.dart';
import 'package:myapp/widgets/widgets.dart';
import 'package:myapp/models/ai_recipe.dart';
import 'package:myapp/screens/ComunityScreen.dart';
import 'package:myapp/theme/my_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;
  List<IaRecipe> _recipes = [];

  Future<void> _getRecipes(String prompt) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final userName = Provider.of<AuthProvider>(context, listen: false).user.profile?.name ?? 'Usuario';
      final userId = Provider.of<AuthProvider>(context, listen: false).user.uid;
      final recipes = await IaService.getRecipesFromPrompt(prompt, userName);
      setState(() {
        _recipes = recipes;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userName = authProvider.user.profile?.name ?? 'Usuario';
    final userId = authProvider.user.uid;

    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          '¡Hola $userName!',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: CustomInputSearch(),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context) => const StoreUnionScreen(),
                            ),
                          );
                          },
                          style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.primary,
                          ),
                          child: const Text(
                          'Comprar ingredientes',
                          style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const RecipeCards(label: 'Nuevas recetas'),
                        const RecipeCards(label: 'Recomendadas para ti'),
                      ],
                    ),
                  ),
                ),
                // Botones de navegación inferior
                Row(
  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => CommunityScreen(),
                            ));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.group, color: Colors.white, size: 24),
                            SizedBox(height: 4),
                            Text(
                              'Comunidad',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => ProfileScreen(userId: userId),
                            ));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.person, color: Colors.white, size: 24),
                            SizedBox(height: 4),
                            Text(
                              'Perfil',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Botón flotante para abrir búsqueda IA
          Positioned(
            bottom: 80,
            left: 20,
            child: FloatingActionButton(
              heroTag: 'chat',
              onPressed: () {
                if (_isLoading) return;

                showDialog(
                  context: context,
                  builder: (context) {
                    final TextEditingController _controller = TextEditingController();

                    return AlertDialog(
                      title: const Text("¿Qué receta buscas?"),
                      content: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(hintText: "Ingresa tu búsqueda"),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            final prompt = _controller.text;
                            if (prompt.isNotEmpty) {
                              _getRecipes(prompt);
                              Navigator.pop(context);
                            }
                          },
                          child: const Text('Buscar'),
                        ),
                      ],
                    );
                  },
                );
              },
              backgroundColor: Colors.blueAccent,
              child: const Icon(Icons.chat),
            ),
          ),

          // Indicador de carga
          if (_isLoading)
            const Positioned(
              bottom: 160,
              left: 20,
              child: CircularProgressIndicator(),
            ),
        ],
      ),
      // Botón flotante para ir a pantalla de recetas generadas
      floatingActionButton: _recipes.isNotEmpty
          ? FloatingActionButton(
              heroTag: 'recipes',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AIGeneratedRecipesScreen(recipes: _recipes),
                  ),
                );
              },
              backgroundColor: Colors.green,
              child: const Icon(Icons.check),
            )
          : null,
    );
  }
}
