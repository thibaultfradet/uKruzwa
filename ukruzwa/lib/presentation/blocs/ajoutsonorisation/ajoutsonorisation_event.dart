import 'package:ukruzwa/domain/models/groupe.dart';

class AjoutsonorisationEvent {
  const AjoutsonorisationEvent();
}

class ASEventCreate extends AjoutsonorisationEvent {
  final Groupe groupeConcerner;
  final String descriptionSono;
  final bool ingeAccompagne;
  final bool?
      ingeEstPro; // nullable => uniquement actif si ingeAccompagne => true
  final String modeleSono;
  final String puissanceSono;
  final String prixLocationSono;
  final int?
      prixServiceInge; // nullable => uniquement actif si ingeAccompagne => true
  ASEventCreate({
    required this.groupeConcerner,
    required this.descriptionSono,
    required this.ingeAccompagne,
    this.ingeEstPro,
    this.prixServiceInge,
    required this.modeleSono,
    required this.puissanceSono,
    required this.prixLocationSono,
  });
}

class ASEventEdit extends AjoutsonorisationEvent {
  final String idSonorisation;
  final Groupe groupeConcerner;
  final String descriptionSono;
  final bool ingeAccompagne;
  final bool?
      ingeEstPro; // nullable => uniquement actif si ingeAccompagne => true
  final String modeleSono;
  final String puissanceSono;
  final String prixLocationSono;
  final int?
      prixServiceInge; // nullable => uniquement actif si ingeAccompagne => true
  ASEventEdit({
    required this.idSonorisation,
    required this.groupeConcerner,
    required this.descriptionSono,
    required this.ingeAccompagne,
    this.ingeEstPro,
    this.prixServiceInge,
    required this.modeleSono,
    required this.puissanceSono,
    required this.prixLocationSono,
  });
}

class ASEventRemove extends AjoutsonorisationEvent {
  final String idSonorisation;
  final Groupe groupeConcerner;

  ASEventRemove({required this.idSonorisation, required this.groupeConcerner});
}
