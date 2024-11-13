import 'package:ukruzwa/domain/models/Groupe.dart';

class PostulerEvent {
  PostulerEvent();
}

class PostulerEventUtilisateurValider extends PostulerEvent {
  final Groupe groupeConcerner;

  final List<String> stylesJoues;
  final List<String> instrumentsJoues;

  PostulerEventUtilisateurValider({
    required this.groupeConcerner,
    required this.stylesJoues,
    required this.instrumentsJoues,
  }) : super();
}
