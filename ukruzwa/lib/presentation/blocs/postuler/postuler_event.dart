import 'package:ukruzwa/domain/models/Style.dart';
import 'package:ukruzwa/domain/models/Instrument.dart';
import 'package:ukruzwa/domain/models/Groupe.dart';
import 'package:ukruzwa/domain/models/Ville.dart';

class PostulerEvent {
  PostulerEvent();
}

class PostulerEventUtilisateurValider extends PostulerEvent {
  final Groupe groupeConcerner;
  final String numTel;
  final List<Style> stylesJoues;
  final List<Instrument> instrumentsJoues;
  final Ville localisation;
  PostulerEventUtilisateurValider(
      {required this.groupeConcerner,
      required this.numTel,
      required this.stylesJoues,
      required this.instrumentsJoues,
      required this.localisation})
      : super();
}
