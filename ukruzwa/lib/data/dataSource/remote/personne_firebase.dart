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

/* PARTIE CONTACT */
/* CRUD ET AUTRE */

/* retrieveContact qui prend en paramètre un numéro de téléphone et retourne un objet contact */
Future<Contact> retrieveContact(String numeroTelephone) async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final docContact = db.collection("Contacts").doc(numeroTelephone);

  var getDataContact = await docContact.get();
  Map<String, dynamic>? dataContact = getDataContact.data();

  return Contact.empty().contactFromJSON(dataContact!);
}

/* FindAllContact qui retourne une liste d'objet contact */
Future<List<Contact>> findAllContact() async {
  List<Contact> listeContact = [];
  return listeContact;
}

/* Fonction retrieveContactByMail qui prend en paramètre un email et retourne le contact associer à cette adresse dans la base de données */
Future<Contact> retrieveContactByMail(String email) async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  QuerySnapshot<Map<String, dynamic>> snapshotContact =
      await db.collection("Contacts").where("Mail", isEqualTo: email).get();

  Contact contactTemp = Contact.empty();

  for (var itemContact in snapshotContact.docs) {
    Map<String, dynamic>? dataContact = itemContact.data();
    contactTemp = await contactTemp.contactFromJSON(dataContact);
  }
  return contactTemp;
}


/* PARTIE CANDIDAT */