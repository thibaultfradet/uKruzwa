import 'package:flutter/material.dart';

class InputCustomPL extends StatefulWidget {
  final String placeholder;
  final TextEditingController controllerPL;
  final bool isObscure;
  const InputCustomPL(
      {super.key,
      required this.placeholder,
      required this.controllerPL,
      required this.isObscure});

  @override
  State<InputCustomPL> createState() => _InputCustomPLState();
}

class _InputCustomPLState extends State<InputCustomPL> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controllerPL,
      obscureText: widget.isObscure,
      decoration: InputDecoration(
          labelText: widget.placeholder,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.circular(15),
          )),
    );
  }
}
