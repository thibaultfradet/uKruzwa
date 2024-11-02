import 'package:flutter/material.dart';

class ItemValider extends StatefulWidget {
  final String valeur;
  final double? largeur;
  final double? hauteur;

  const ItemValider(
      {super.key, required this.valeur, this.largeur, this.hauteur});

  @override
  State<ItemValider> createState() => _ItemValiderState();
}

class _ItemValiderState extends State<ItemValider> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.largeur == null
          ? MediaQuery.of(context).size.width * 0.3
          : MediaQuery.of(context).size.width * widget.largeur!,
      height: widget.hauteur == null
          ? MediaQuery.of(context).size.height * 0.05
          : MediaQuery.of(context).size.width * widget.largeur!,
      color: Colors.black,
      child: Text(
        widget.valeur,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
