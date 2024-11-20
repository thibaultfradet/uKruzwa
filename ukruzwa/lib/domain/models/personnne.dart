import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ukruzwa/domain/models/Ville.dart';
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

  Future<bool> createUserInFirestore(String emailAddress, String nom,
      String prenom, String numTel, String codePostal, String ville) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    bool isSuccess = false;

    int maxIdVille = await Ville.empty().getMaxIdVille();
    Ville villeTemp =
        Ville(idVille: maxIdVille + 1, codePostal: codePostal, nomVille: ville);
    Personne personneTemp = Personne(
        numeroTelephone: numTel,
        nom: nom,
        prenom: prenom,
        mail: emailAddress,
        villeHabiter: villeTemp);

    try {
      // On ajoute la ville et l'utilisateur en base
      final docVille = db.collection("Villes").doc((maxIdVille + 1).toString());
      await docVille.set({
        "CodePostal": villeTemp.codePostal,
        "NomVille": villeTemp.nomVille,
      });
      final docName = db
          .collection("Personnes")
          .doc(numTel); // identifiant unique => numéro téléphone
      await docName.set({
        "Mail": personneTemp.mail,
        "Nom": personneTemp.nom,
        "Prenom": personneTemp.prenom,
        "NumeroTelephone": personneTemp.numeroTelephone,
        "idVille": personneTemp.villeHabiter.idVille,
      });
      isSuccess = true;
    } catch (e) {
      isSuccess = false;
    }
    return isSuccess;
  }

  /* Fonction retrievePersonne qui prend en paramètre un mail et retourne l'objet personne associé dans la base de données */
  Future<Personne> retrievePersonne(String email) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    // On récupère le contenu de la collection groupe
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await db.collection("Utilisateurs").get();

    Personne? personneRetrieve;
    // Pour chaque groupe dans la collection
    for (var item in querySnapshot.docs) {
      // Récupération des données
      Map<String, dynamic>? data = item.data();
      // Email égal donc on set l'utilisateur aux données
      if (data["Mail"] == email) {
        Ville villeHabiter = await Ville.empty().retrieveVille(data["idVille"]);
        personneRetrieve = Personne(
          numeroTelephone: data["NumeroTelephone"],
          nom: data["Nom"],
          prenom: data["Prenom"],
          mail: data["Mail"],
          villeHabiter: villeHabiter,
        );
      }
    }
    return personneRetrieve!;
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

  /* retrieveContact qui prend en paramètre un numéro de téléphone et retourne un objet contact */
  Future<Contact> retrieveContact(String numeroTelephone) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    // On récupère le contact associé au numéro de téléphone
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await db
        .collection("Contact")
        .where("NumeroTelephone", isEqualTo: numeroTelephone)
        .get();
    Contact? contactRetrieve;
    // Pour chaque groupe dans la collection
    for (var item in querySnapshot.docs) {
      // Récupération des données
      Map<String, dynamic>? data = item.data();
      // NuméroTel égal donc bon numéro
      if (data["NumeroTelephone"] == numeroTelephone) {
        Ville villeTemp;
        villeTemp =
            await Ville.empty().retrieveVille(int.parse(data["idVille"]));
        contactRetrieve = Contact(
            numeroTelephone: numeroTelephone,
            nom: data["Nom"],
            prenom: data["Prenom"],
            mail: data["Mail"],
            villeHabiter: villeTemp);
      }
    }

    return contactRetrieve!;
  }

  /* FindAllContact qui retourne une liste d'objet contact */
  Future<List<Contact>> findAllContact() async {
    List<Contact> listeContact = [];
    return listeContact;
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

  /* 
  Fonction createPostulat qui prend en paramètre l'id du groupe associé un objet personne qui est le candidat une liste de styles et 
  d'instruments qui sont les id associés dans la base de données et retourne un booleen à true si la création s'est passée correctement 
  */
  Future<bool> createPostulat(int idGroupe, Personne candidat,
      List<int> styleCandidat, List<int> instrumentCandidat) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    return false;
  }
}
