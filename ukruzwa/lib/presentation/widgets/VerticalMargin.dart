import 'package:flutter/material.dart';

class VerticalMargin extends StatelessWidget {
  final double ratio;
  const VerticalMargin({super.key, required this.ratio});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: MediaQuery.of(context).size.height * ratio);
  }
}
