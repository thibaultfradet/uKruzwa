class AjoutSalleSpEvent {
  const AjoutSalleSpEvent();
}

class ASPCreate extends AjoutSalleSpEvent {
  final String nomSalle;
  final String codePostalSalle;
  final String adresseSalle;
  final String villeSalle;
  final int nbPlaceMaximum;
  final bool possederSonorisation;
  final bool possederIngenieur;
  final bool estPublique;

  ASPCreate(
      this.nomSalle,
      this.codePostalSalle,
      this.adresseSalle,
      this.villeSalle,
      this.nbPlaceMaximum,
      this.possederSonorisation,
      this.possederIngenieur,
      this.estPublique);
}
