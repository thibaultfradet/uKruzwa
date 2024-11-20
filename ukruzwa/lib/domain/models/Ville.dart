class Ville {
  final int? idVille;
  final String nomVille;
  final String codePostal;

  /* Constructeur vide */
  Ville.empty()
      : idVille = 0,
        nomVille = '',
        codePostal = '';
  /* Constructeur surcharger */
  Ville({
    this.idVille,
    required this.nomVille,
    required this.codePostal,
  });

  /* FONCTION DE CONVERSION */
  Map<String, dynamic> toFirestore() {
    return {
      'CodePostal': codePostal,
      'NomVille': nomVille,
    };
  }

  factory Ville.fromJSON(Map<String, dynamic> json) {
    return Ville(
      codePostal: json["CodePostal"],
      nomVille: json["NomVille"],
    );
  }
}
