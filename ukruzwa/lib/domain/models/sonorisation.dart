class Sonorisation {
  String idSonorisation;
  String modeleSono;
  String descriptionSono;
  double prixLocaSono;
  double puissanceSono;

/* constructeur suchargé */
  Sonorisation(this.idSonorisation, this.modeleSono, this.descriptionSono,
      this.prixLocaSono, this.puissanceSono);

  /* Constructeur vide */
  Sonorisation.empty()
      : idSonorisation = "",
        modeleSono = "",
        descriptionSono = "",
        prixLocaSono = 0,
        puissanceSono = 0;

  Map<String, dynamic> toFirestore(String idSonorisation) {
    return {
      'idSonorisation': idSonorisation,
      'ModeleSono': modeleSono,
      'DescriptionSonorisation ': descriptionSono,
      'PrixLocaSono': prixLocaSono,
      'PuissanceSono': puissanceSono
    };
  }

  factory Sonorisation.fromJSON(Map<String, dynamic> json) {
    return Sonorisation(
      json["idSonorisation"],
      json["ModeleSono"],
      json["DescriptionSonorisation "],
      json["PrixLocaSono"],
      json["PuissanceSono"],
    );
  }
}
