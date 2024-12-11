class AjoutgroupeEvent {
  const AjoutgroupeEvent();
}

class AGEventCreate extends AjoutgroupeEvent {
  final String nomGroupe;
  final List<String> stylesDuGroupe;
  final String
      numeroTelContact; // permet de récupérer un objet contact dans la base de données -> dans le bloc plus tard
  final String numeroRemplacementContact;
  final String nomVilleRepetition;
  final String codePostalVilleRepetition;
  final List<String> instrumentsDuGroupe;
  final String
      nombreChanteurs; // A ajouter aux chanteurs -> dans le bloc plus tard
  final bool possederSonorisation;
  final List<List<String>>? endroitsJouesDuGroupe;

  AGEventCreate({
    required this.nomGroupe,
    required this.stylesDuGroupe,
    required this.numeroTelContact,
    required this.numeroRemplacementContact,
    required this.nomVilleRepetition,
    required this.codePostalVilleRepetition,
    required this.instrumentsDuGroupe,
    required this.nombreChanteurs,
    required this.possederSonorisation,
    this.endroitsJouesDuGroupe,
  });
}

class AGEventEdit extends AjoutgroupeEvent {
  final String nomGroupe;
  final List<String> stylesDuGroupe;
  final String
      numeroTelContact; // permet de récupérer un objet contact dans la base de données -> dans le bloc plus tard
  final String numeroRemplacementContact;
  final String villeRepetitionDuGroupe;
  final List<String> instrumentsDuGroupe;
  final int
      nombreChanteurs; // A ajouter aux chanteurs -> dans le bloc plus tard
  final bool possederSonorisation;
  final List<String>? endroitsJouesDuGroupe;

  AGEventEdit({
    required this.nomGroupe,
    required this.stylesDuGroupe,
    required this.numeroTelContact,
    required this.numeroRemplacementContact,
    required this.villeRepetitionDuGroupe,
    required this.instrumentsDuGroupe,
    required this.nombreChanteurs,
    required this.possederSonorisation,
    this.endroitsJouesDuGroupe,
  });
}
