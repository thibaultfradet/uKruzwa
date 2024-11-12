import 'package:flutter/widgets.dart';

class Horizontalmargin extends StatefulWidget {
  final double ratio;
  const Horizontalmargin({super.key, required this.ratio});

  @override
  State<Horizontalmargin> createState() => _HorizontalmarginState();
}

class _HorizontalmarginState extends State<Horizontalmargin> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * widget.ratio,
    );
  }
}
