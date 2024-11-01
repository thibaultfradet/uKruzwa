class Personne {
  final String numeroTelephone;
  final String nom;
  final String prenom;
  final String mail;

  Personne(this.numeroTelephone, this.nom, this.prenom, this.mail);
}

//Héritage de personne => contact
class Contact extends Personne {
  Contact(String numeroTelephone, String nom, String prenom, String mail)
      : super(numeroTelephone, nom, prenom, mail);
}

//Héritage de personne => candidat
class Candidat extends Personne {
  Candidat(String numeroTelephone, String nom, String prenom, String mail)
      : super(numeroTelephone, nom, prenom, mail);
}
