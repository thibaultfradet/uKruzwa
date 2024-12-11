import 'package:flutter/material.dart';

class InputCustomPL extends StatelessWidget {
  final TextEditingController controllerPL;
  final String placeholder;
  final bool? isObscure;
  final bool? enable;
  final double? largeur;
  final bool? isDouble;
  const InputCustomPL({
    super.key,
    required this.controllerPL,
    required this.placeholder,
    this.isObscure,
    this.enable,
    this.largeur,
    this.isDouble,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.06,
      width: largeur == null
          ? MediaQuery.of(context).size.width * 0.9
          : MediaQuery.of(context).size.width * largeur!,
      child: TextFormField(
        keyboardType: isDouble != null
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        enabled: enable, // Active/desactiver en fonction du paramètre
        controller: controllerPL,
        obscureText: isObscure == null ? false : isObscure!,
        decoration: InputDecoration(
          labelText: placeholder,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}
