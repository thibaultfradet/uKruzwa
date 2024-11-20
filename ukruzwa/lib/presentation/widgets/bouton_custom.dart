import 'package:flutter/material.dart';

class BoutonCustom extends StatelessWidget {
  final VoidCallback onpressed;
  final String texteValeur;
  final bool? isDeleteButton;
  const BoutonCustom(
      {super.key,
      required this.onpressed,
      required this.texteValeur,
      this.isDeleteButton});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onpressed();
      },
      style: TextButton.styleFrom(
        backgroundColor: isDeleteButton == null ? Colors.black : Colors.red,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text(
        texteValeur,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
