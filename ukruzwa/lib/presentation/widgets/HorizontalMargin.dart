import 'package:flutter/material.dart';

class Horizontalmargin extends StatelessWidget {
  final double ratio;
  const Horizontalmargin({super.key, required this.ratio});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * ratio,
    );
  }
}
