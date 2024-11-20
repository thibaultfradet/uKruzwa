import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ukruzwa/data/dataSource/remote/ville_firebase.dart';
import 'package:ukruzwa/domain/models/ville.dart';

class Personne {
  final String numeroTelephone;
  final String nom;
  final String prenom;
  final String mail;
  final Ville villeHabiter;

  /* Constructeur vide */
  Personne.empty()
      : numeroTelephone = '',
        nom = '',
        prenom = '',
        mail = '',
        villeHabiter = Ville.empty();

  /* Constructeur surchargé */
  Personne({
    required this.numeroTelephone,
    required this.nom,
    required this.prenom,
    required this.mail,
    required this.villeHabiter,
  });

  /* FONCTION DE CONVERSION */
  Map<String, dynamic> toFirestore() {
    return {
      'Mail': mail,
      'Nom': nom,
      'NumeroTelephone': numeroTelephone,
      'Prenom': prenom,
      'idVille': villeHabiter.idVille,
    };
  }

  Future<Personne> PersonnefromJSON(Map<String, dynamic> json) async {
    return Personne(
      mail: json['Mail'],
      nom: json['Nom'],
      numeroTelephone: json['NumeroTelephone'],
      prenom: json['Prenom'],
      villeHabiter: await retrieveVille(json['idVille']),
    );
  }
}

// Héritage de personne => contact
class Contact extends Personne {
  /* Constructeur vide */
  Contact.empty()
      : super(
          numeroTelephone: '',
          nom: '',
          prenom: '',
          mail: '',
          villeHabiter: Ville.empty(),
        );

  /* Constructeur surchargé */
  Contact({
    required String numeroTelephone,
    required String nom,
    required String prenom,
    required String mail,
    required Ville villeHabiter,
  }) : super(
          numeroTelephone: numeroTelephone,
          nom: nom,
          prenom: prenom,
          mail: mail,
          villeHabiter: villeHabiter,
        );
}

// Héritage de personne => candidat
class Candidat extends Personne {
  /* Constructeur vide */
  Candidat.empty()
      : super(
          numeroTelephone: '',
          nom: '',
          prenom: '',
          mail: '',
          villeHabiter: Ville.empty(),
        );

  /* Constructeur surchargé */
  Candidat({
    required String numeroTelephone,
    required String nom,
    required String prenom,
    required String mail,
    required Ville villeHabiter,
  }) : super(
          numeroTelephone: numeroTelephone,
          nom: nom,
          prenom: prenom,
          mail: mail,
          villeHabiter: villeHabiter,
        );
}
