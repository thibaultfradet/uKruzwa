import 'package:ukruzwa/domain/models/Style.dart';
import 'package:ukruzwa/domain/models/Instrument.dart';
import 'package:ukruzwa/domain/models/Groupe.dart';

class PostulerEvent {
  PostulerEvent();
}

class PostulerEventUtilisateurValider extends PostulerEvent {
  final Groupe groupeConcerner;
  final String numTel;
  final String nom;
  final String prenom;
  final List<Style> stylesJoues;
  final List<Instrument> instrumentsJoues;
  final String codePostal;
  final String ville;
  PostulerEventUtilisateurValider(
      {required this.groupeConcerner,
      required this.numTel,
      required this.nom,
      required this.prenom,
      required this.stylesJoues,
      required this.instrumentsJoues,
      required this.codePostal,
      required this.ville})
      : super();
}
