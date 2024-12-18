import 'package:ukruzwa/domain/models/instrument.dart';
import 'package:ukruzwa/domain/models/personnne.dart';
import 'package:ukruzwa/domain/models/style.dart';
import 'package:ukruzwa/domain/models/ville.dart';

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
  final String idGroupe;
  final bool isSonorisation;
  AGSuccess(this.isSonorisation, this.idGroupe) : super();
}

class AGFailure extends AjoutgroupeState {
  AGFailure() : super();
}

class AGLoading extends AjoutgroupeState {
  AGLoading() : super();
}
