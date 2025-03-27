import 'package:flutter/material.dart';

class IngredientButton extends StatelessWidget {
  final String assetImage;
  final VoidCallback? onPressed;

  const IngredientButton({
    required this.assetImage,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: ClipOval(
          child: Image.asset(
            assetImage,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}