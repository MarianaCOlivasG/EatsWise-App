import 'package:flutter/material.dart';
import 'package:myapp/theme/my_colors.dart';
import 'package:myapp/widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const _Logo(),

              Text('¡Bienvenido a EatWise!\nEncuentra miles de recetas saludables y económicas para tí.',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),

              Column(
                children: [
                  CustomButton(
                    text: 'Regístrate con tu e-mail', 
                    color: MyColors.primary,
                    onPressed: () {
                      Navigator.pushNamed(context, 'register-form');
                    },
                  ),

                  SizedBox(
                    height: 15,
                  ),

                  // GoogleSignInButton()
                ],
              ),

              

             
               Labels(
                  title: "¿Ya tienes una cuenta?",
                  textButton: '¡Iniciar sesión!',
                  onTap: () => Navigator.pushReplacementNamed(context, 'login')
                ),
        
                const Text('Términos y condiciones.',
                  style: TextStyle(
                    fontWeight: FontWeight.w200
                  )
                )
            ],
          ),
        ),
      ),
    ));
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Image(
        image: AssetImage('assets/logo.png'),
        width: 200,
      ),
    );
  }
}
   