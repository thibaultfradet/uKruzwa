class Ville {
  final int idVille;
  final String nomVille;
  final String codePostal;
  final String? nomEvenement;
  Ville(
      {required this.idVille,
      required this.nomVille,
      required this.codePostal,
      this.nomEvenement});
}
