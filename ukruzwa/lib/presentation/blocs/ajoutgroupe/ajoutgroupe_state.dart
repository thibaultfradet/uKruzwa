import 'package:ukruzwa/domain/models/Instrument.dart';
import 'package:ukruzwa/domain/models/Personne.dart';
import 'package:ukruzwa/domain/models/Style.dart';
import 'package:ukruzwa/domain/models/Ville.dart';

abstract class AjoutgroupeState {
  AjoutgroupeState();
}

//State initial
class AjoutgroupeStateInitial extends AjoutgroupeState {
  //Pour les recommandations de l'utilisateur
  final List<Ville> villeDisponible;
  final List<Style> styleDisponible;
  final List<Instrument> instrumentDisponible;
  final List<Contact> contactDisponible;
  AjoutgroupeStateInitial(
      {required this.villeDisponible,
      required this.styleDisponible,
      required this.instrumentDisponible,
      required this.contactDisponible})
      : super();
}

// Tentative de création => load,success,fail
class AGSuccess extends AjoutgroupeState {
  AGSuccess() : super();
}

class AGFailure extends AjoutgroupeState {
  AGFailure() : super();
}

class AGLoading extends AjoutgroupeState {
  AGLoading() : super();
}
