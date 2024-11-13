import 'package:ukruzwa/domain/models/Ville.dart';

class Personne {
  final String numeroTelephone;
  final String nom;
  final String prenom;
  final String mail;
  final Ville villeHabiter;

  Personne(this.numeroTelephone, this.nom, this.prenom, this.mail,
      this.villeHabiter);
}

//Héritage de personne => contact
class Contact extends Personne {
  Contact(String numeroTelephone, String nom, String prenom, String mail,
      Ville villeHabiter)
      : super(numeroTelephone, nom, prenom, mail, villeHabiter);
}

//Héritage de personne => candidat
class Candidat extends Personne {
  Candidat(String numeroTelephone, String nom, String prenom, String mail,
      Ville villeHabiter)
      : super(numeroTelephone, nom, prenom, mail, villeHabiter);
}
