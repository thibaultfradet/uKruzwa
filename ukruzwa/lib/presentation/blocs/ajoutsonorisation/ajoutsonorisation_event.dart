class AjoutsonorisationEvent {
  const AjoutsonorisationEvent();
}

class ASEventCreate extends AjoutsonorisationEvent {
  final String idGroupeConcerner;
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
    required this.idGroupeConcerner,
    required this.descriptionSono,
    required this.ingeAccompagne,
    this.ingeEstPro,
    this.prixServiceInge,
    required this.modeleSono,
    required this.puissanceSono,
    required this.prixLocationSono,
  });
}
