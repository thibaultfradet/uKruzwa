import 'package:flutter/material.dart';
import 'package:ukruzwa/presentation/widgets/horizontal_margin.dart';

class FloatingItem extends StatefulWidget {
  final String valeur;
  final VoidCallback onPressed;
  const FloatingItem(
      {super.key, required this.valeur, required this.onPressed});

  @override
  State<FloatingItem> createState() => _FloatingItemState();
}

class _FloatingItemState extends State<FloatingItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(20)),
      height: MediaQuery.of(context).size.height * 0.2,
      child: Row(
        children: [
          const Padding(padding: EdgeInsets.only(left: 10)),
          //valeur
          Text(widget.valeur),
          const Horizontalmargin(ratio: 0.03),
          SizedBox(
            width: 45,
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue)),
              onPressed: () {
                widget.onPressed();
              },
              child: const Text("X"),
            ),
          )
        ],
      ),
    );
  }
}
