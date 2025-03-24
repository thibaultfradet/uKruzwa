import 'package:flutter/material.dart';

class BoutonCustom extends StatelessWidget {
  final VoidCallback onpressed;
  final String texteValeur;
  final Color? buttonColor;
  final double? largeur;
  final double? hauteur;
  const BoutonCustom({
    super.key,
    required this.onpressed,
    required this.texteValeur,
    this.buttonColor,
    this.hauteur,
    this.largeur,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: largeur == null
          ? MediaQuery.of(context).size.width * 0.45
          : MediaQuery.of(context).size.width * largeur!,
      height: hauteur == null
          ? MediaQuery.of(context).size.height * 0.07
          : MediaQuery.of(context).size.height * hauteur!,
      child: TextButton(
        onPressed: () {
          onpressed();
        },
        style: TextButton.styleFrom(
          backgroundColor: buttonColor ?? Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          texteValeur,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
