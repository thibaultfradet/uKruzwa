import 'package:flutter/material.dart';

class VerticalMargin extends StatefulWidget {
  final double ratio;
  const VerticalMargin({super.key, required this.ratio});

  @override
  State<VerticalMargin> createState() => _VerticalMarginState();
}

class _VerticalMarginState extends State<VerticalMargin> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: MediaQuery.of(context).size.height * widget.ratio);
  }
}