import 'package:flutter/material.dart';

class InputCustomPL extends StatelessWidget {
  final TextEditingController controllerPL;
  final String placeholder;
  final bool? isObscure;
  final bool? enable;
  const InputCustomPL({
    super.key,
    required this.controllerPL,
    required this.placeholder,
    this.isObscure,
    this.enable,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.06,
      child: TextFormField(
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
