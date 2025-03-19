class Ville {
  String? idVille;
  final String nomVille;
  final String codePostal;

  /* Constructeur vide */
  Ville.empty()
      : idVille = "",
        nomVille = '',
        codePostal = '';
  /* Constructeur surcharger */
  Ville({
    this.idVille,
    required this.nomVille,
    required this.codePostal,
  });

  /* FONCTION DE CONVERSION */
  Map<String, dynamic> toFirestore(String idVille) {
    return {
      'idVille': idVille,
      'CodePostal': codePostal,
      'NomVille': nomVille,
    };
  }

  factory Ville.fromJSON(Map<String, dynamic> json) {
    return Ville(
      idVille: json["idVille"],
      codePostal: json["CodePostal"],
      nomVille: json["NomVille"],
    );
  }
}
