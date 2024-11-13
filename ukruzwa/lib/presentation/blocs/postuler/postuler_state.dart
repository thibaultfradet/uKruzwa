import 'package:ukruzwa/domain/models/Instrument.dart';
import 'package:ukruzwa/domain/models/Style.dart';

abstract class PostulerState {
  const PostulerState();
}

class PostulerStateInitial extends PostulerState {
  final List<Style> styleDisponible;
  final List<Instrument> instrumentDisponible;
  PostulerStateInitial(this.styleDisponible, this.instrumentDisponible)
      : super();
}

class PostulerStateCreateStatut extends PostulerState {
  final bool isSuccess;
  PostulerStateCreateStatut({required this.isSuccess}) : super();
}
