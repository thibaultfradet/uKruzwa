/* CRUD ET AUTRE  */

/* PARTIE PERSONNE */

/* fonction isTelephoneAlreadyUse qui prende un paramètre un numéro de téléphone et retourne si il est deja affilier à un utilisateur dans la base de données */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ukruzwa/data/dataSource/remote/ville_firebase.dart';
import 'package:ukruzwa/domain/models/personnne.dart';
import 'package:ukruzwa/domain/models/ville.dart';

Future<bool> isTelephoneAlreadyUse(String numeroTelephone) async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  // On récupère le contenu de la collection groupe
  QuerySnapshot<Map<String, dynamic>> querySnapshot = await db
      .collection("Personnes")
      .where("NumeroTelephone", isEqualTo: numeroTelephone)
      .get();
  return querySnapshot.docs.isNotEmpty ? true : false;
}

/* Fonction createUserInFirestore qui prend touts les paramètre requis pour créer un utilisateur et retourne le statut du résultat */
Future<bool> createUserInFirestore(String emailAddress, String nom,
    String prenom, String numTel, String codePostal, String ville) async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  bool isSuccess = false;

  Ville villeTemp = Ville(codePostal: codePostal, nomVille: ville);
  Personne personneTemp = Personne(
      numeroTelephone: numTel,
      nom: nom,
      prenom: prenom,
      mail: emailAddress,
      villeHabiter: villeTemp);

  try {
    // On ajoute la ville et l'utilisateur en base
    final docVille = db.collection("Villes").doc();
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
      await db.collection("Personnes").get();

  Personne? personneRetrieve;
  // Pour chaque groupe dans la collection
  for (var item in querySnapshot.docs) {
    // Récupération des données
    Map<String, dynamic>? data = item.data();
    // Email égal donc on set l'utilisateur aux données
    if (data["Mail"] == email) {
      Ville villeHabiter = await retrieveVille(data["idVille"]);
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

/* PARTIE CONTACT */
/* CRUD ET AUTRE */

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
      villeTemp = await retrieveVille(data["idVille"]);
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



/* PARTIE CANDIDAT */