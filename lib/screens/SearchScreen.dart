import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recetas'),
      ),
      body: ListView.builder(
        itemCount: 10, // Puedes cambiar esto según la cantidad de recetas que quieras mostrar
        itemBuilder: (context, index) {
          return RecipeCard(index: index);
        },
      ),
    );
  }
}

class RecipeCard extends StatelessWidget {
  final int index;

  const RecipeCard({required this.index});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navegar a la página de detalles
        Navigator.pushNamed(context, 'details');
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1), // Sombra con transparencia
              blurRadius: 5, // Difusión de la sombra
              offset: Offset(0, 3), // Desplazamiento de la sombra
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.3, // 30% de la pantalla
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                image: DecorationImage(
                  image: NetworkImage('https://picsum.photos/200'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Receta $index',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage('assets/logo.png'),
                      ),
                      SizedBox(width: 10),
                      Text(
                        'IA EatWise',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.favorite_border,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
