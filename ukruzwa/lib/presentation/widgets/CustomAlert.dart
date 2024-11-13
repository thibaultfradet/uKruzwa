import 'package:flutter/material.dart';

class CustomAlert extends StatefulWidget {
  final VoidCallback onpressed;
  final String texte;
  const CustomAlert({super.key, required this.onpressed, required this.texte});

  @override
  State<CustomAlert> createState() => _CustomAlertState();
}

class _CustomAlertState extends State<CustomAlert> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("My title"),
      content: Text("This is my message."),
      actions: [
        TextButton(
          onPressed: () {
            widget.onpressed();
          },
          child: Text(
            widget.texte,
          ),
        ),
      ],
    );
  }
}
