class AjoutsonorisationEvent {
  const AjoutsonorisationEvent();
}

class ASEventCreate extends AjoutsonorisationEvent {
  final String descriptionSono;
  final bool ingeAccompagne;
  final bool?
      ingeEstPro; // nullable => uniquement actif si ingeAccompagne => true
  final String modeleSono;
  final int puissanceSono;
  final int prixLocationSono;
  final int?
      prixServiceInge; // nullable => uniquement actif si ingeAccompagne => true
  ASEventCreate({
    required this.descriptionSono,
    required this.ingeAccompagne,
    this.ingeEstPro,
    required this.modeleSono,
    required this.puissanceSono,
    required this.prixLocationSono,
    this.prixServiceInge,
  });
}
