import 'package:flutter/material.dart';

class CustomAlert extends StatelessWidget {
  final VoidCallback onPressed;
  final String texte;
  const CustomAlert({super.key, required this.onPressed, required this.texte});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
  }
}
