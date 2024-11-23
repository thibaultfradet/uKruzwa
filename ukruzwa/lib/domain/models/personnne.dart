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

  Future<Personne> personnefromJSON(Map<String, dynamic> json) async {
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
    required super.numeroTelephone,
    required super.nom,
    required super.prenom,
    required super.mail,
    required super.villeHabiter,
  });

  /* FONCTION DE CONVERSION */
  @override
  Map<String, dynamic> toFirestore() {
    return {
      'Mail': mail,
      'Nom': nom,
      'NumeroTelephone': numeroTelephone,
      'Prenom': prenom,
      'idVille': villeHabiter.idVille,
    };
  }

  Future<Contact> contactFromJSON(Map<String, dynamic> json) async {
    return Contact(
        mail: json["Mail"],
        nom: json["Nom"],
        prenom: json["Prenom"],
        numeroTelephone: json["NumeroTelephone"],
        villeHabiter: await retrieveVille(json["idVille"]));
  }
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
    required super.numeroTelephone,
    required super.nom,
    required super.prenom,
    required super.mail,
    required super.villeHabiter,
  });
}
