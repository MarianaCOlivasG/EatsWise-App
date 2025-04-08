import 'package:flutter/material.dart';
import 'package:myapp/theme/my_colors.dart';
import 'package:myapp/widgets/widgets.dart';

class RecipeDetailsScreen extends StatelessWidget {
  const RecipeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            _CustomAppBar(),
            SliverList(
              delegate: SliverChildListDelegate([
                RecipeCards(),
                SizedBox(
                  height: 20,
                ),
                RecipeCards(),
                SizedBox(
                  height: 20,
                ),
                RecipeCards(),
              ]),
            )
          ]
        ),
      )
    );
  }
}


class _CustomAppBar extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
        backgroundColor: MyColors.primary,
        expandedHeight: 200,
        floating: false,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          titlePadding: EdgeInsets.all(0),
          centerTitle: true,
          title: Container(
              width: double.infinity,
              color: Colors.transparent,
              padding: EdgeInsets.only(bottom: 10, right: 10, left: 10),
              alignment: Alignment.bottomCenter,
              child: Text('Prueba titulo 1', 
                style: TextStyle(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,
              )),
          background: FadeInImage(
              placeholder: AssetImage('assets/loading.gif'),
              image: NetworkImage('https://picsum.photos/200'),
              fit: BoxFit.cover),
        ));
  }
}
