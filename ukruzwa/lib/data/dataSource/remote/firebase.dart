import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ukruzwa/domain/models/Style.dart';
import 'package:ukruzwa/domain/models/Instrument.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ukruzwa/domain/models/Ville.dart';
import 'package:ukruzwa/domain/models/Groupe.dart';
import 'package:ukruzwa/domain/models/Personne.dart';

/* -------- AUTHENTIFICATION A FIREBASE -------- */

Future<bool> connectUser(String emailAddress, String password) async {
  try {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: emailAddress, password: password);
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      return false;
    } else if (e.code == 'wrong-password') {
      return false;
    }
    return false;
  }
}

Future<bool> createUser(String emailAddress, String password) async {
  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      return false;
    } else if (e.code == 'email-already-in-use') {
      return false;
    }
    return false;
  } catch (e) {
    return false;
  }
}

Future<bool> createUserInFirestore(String emailAddress, String nom,
    String prenom, String numTel, String codePostal, String ville) async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  bool isSuccess = false;

  int maxIdVille = await getMaxIdVille();
  Ville villeTemp =
      Ville(idVille: maxIdVille + 1, codePostal: codePostal, nomVille: ville);
  Personne personneTemp =
      Personne(numTel, nom, prenom, emailAddress, villeTemp);

  try {
    //On ajoute la ville et l'utilisateur en base
    final docVille = db.collection("Villes").doc((maxIdVille + 1).toString());
    await docVille.set(
        {"CodePostal": villeTemp.nomVille, "NomVille": villeTemp.codePostal});
    final docName = db
        .collection("Personnes")
        .doc(numTel); // identifiant unique => numéro telephone
    await docName.set({
      "Mail": personneTemp.mail,
      "Nom": personneTemp.nom,
      "Prenom": personneTemp.prenom,
      "NumeroTelephone": personneTemp.numeroTelephone,
      "idVille": personneTemp.villeHabiter.idVille
    });
    isSuccess = true;
  } catch (e) {
    isSuccess = false;
  }
  return isSuccess;
}

/* -------- PARTIE BASE DE DONNEES -------- */

/* Fonction FindAllGroupe qui ne prend pas de paramètre et retourne une liste de groupe */
Future<List<Groupe>> findAllGroupe() async {
  List<Groupe> collectionGroupe = [];

  FirebaseFirestore db = FirebaseFirestore.instance;
  //On récupère le contenu de la collection groupe
  QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await db.collection("Groupes").get();

  //pour chaque groupe dans la collection
  for (var item in querySnapshot.docs) {
    //Récupération des données
    Map<String, dynamic>? data = item.data();

    //item pour la boucle
    Ville villeRepetition = await retrieveVille(data["idVille"]);
    Contact personneAContacter = await retrieveContact(data["NumeroTelephone"]);

    //objets externe
    List<Instrument> instrumentsDuGroupe = [];
    List<Style> stylesDuGroupe = [];
    List<Ville> endroitsJouesDuGroupe = [];

    //Récupérations obj externe
    //styles
    QuerySnapshot<Map<String, dynamic>> snapShotJouer = await db
        .collection("Jouer")
        .where("GroupeId", isEqualTo: item.id)
        .get();
    for (var jouer in snapShotJouer.docs) {
      Map<String, dynamic>? dataJouer = jouer.data();
      Style styleTemp =
          Style(idStyle: int.parse(jouer.id), nomStyle: dataJouer["NomStyle"]);
      stylesDuGroupe.add(styleTemp);
    }

    //instruments
    QuerySnapshot<Map<String, dynamic>> snapshotUtiliser = await db
        .collection("Utiliser")
        .where("GroupeId", isEqualTo: item.id)
        .get();
    for (var utiliser in snapshotUtiliser.docs) {
      Map<String, dynamic>? dataUtiliser = utiliser.data();
      Instrument instrumentTemp = Instrument(
          idInstrument: int.parse(utiliser.id),
          nomInstrument: dataUtiliser["NomInstrument"]);
      instrumentsDuGroupe.add(instrumentTemp);
    }

    //endroits deja joues
    QuerySnapshot<Map<String, dynamic>> snapshotVille = await db
        .collection("DejaJouer")
        .where("GroupeId", isEqualTo: item.id)
        .get();
    for (var dejajouer in snapShotJouer.docs) {
      Map<String, dynamic>? dataDejaJouer = dejajouer.data();
      Ville villeTemp = Ville(
          codePostal: dataDejaJouer["CodePostal"],
          idVille: int.parse(dejajouer.id),
          nomVille: dataDejaJouer["NomVille"]);
      endroitsJouesDuGroupe.add(villeTemp);
    }

    //Création obj groupe
    Groupe groupeTemp = Groupe(
      idGroupe: int.parse(item.id),
      nomGroupe: data["NomGroupe"],
      numeroRemplacementContact: data["NumeroRemplacementContact"],
      ingeSon: data["IngeSon"],
      possederSonorisation: data["PossederSonorisation"],
      modeleSono: data["ModeleSono"],
      descriptionSono: data["DescriptionSono"],
      prixLocationSono: data["PrixLocaSono"],
      ingePro: data["IngePro"],
      prixInge: data["PrixInge"],
      villeRepetition: villeRepetition,
      personneAContacter: personneAContacter,
      endroitsDejaJoues: endroitsJouesDuGroupe,
      instrumentDuGroupe: instrumentsDuGroupe,
      stylDuGroupe: stylesDuGroupe,
    );

    //Ajout item i dans la boucle
    collectionGroupe.add(groupeTemp);
  }

  return collectionGroupe;
}

/* ---- PARTIE FindAll ---- */
Future<List<Groupe>> findAllGroupeRecherche(
    String libelle, String option) async {
  List<Groupe> collectionGroupe = [];
  return collectionGroupe;
}

/* FindAllVille => permet de recuperer toutes les villes*/
Future<List<Ville>> findAllVille() async {
  List<Ville> listeVille = [];

  FirebaseFirestore db = FirebaseFirestore.instance;
  //On récupère le contenu de la collection groupe
  QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await db.collection("Villes").get();

  //pour chaque groupe dans la collection
  for (var item in querySnapshot.docs) {
    //Récupération des données
    Map<String, dynamic>? data = item.data();
    Ville villeTemp = Ville(
        idVille: int.parse(item.id),
        codePostal: data["CodePostal"],
        nomVille: data["NomVille"]);
    listeVille.add(villeTemp);
  }
  return listeVille;
}

Future<List<Instrument>> findAllInstrument() async {
  List<Instrument> listeInstrument = [];
  FirebaseFirestore db = FirebaseFirestore.instance;
  //On récupère le contenu de la collection groupe
  QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await db.collection("Instruments").get();

  //pour chaque groupe dans la collection
  for (var item in querySnapshot.docs) {
    //Récupération des données
    Map<String, dynamic>? data = item.data();
    Instrument instrumentTemp = Instrument(
        idInstrument: int.parse(item.id), nomInstrument: data["NomInstrument"]);
    listeInstrument.add(instrumentTemp);
  }

  return listeInstrument;
}

Future<List<Style>> findAllStyle() async {
  List<Style> listeStyle = [];
  FirebaseFirestore db = FirebaseFirestore.instance;
  //On récupère le contenu de la collection groupe
  QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await db.collection("Styles").get();

  //pour chaque groupe dans la collection
  for (var item in querySnapshot.docs) {
    //Récupération des données
    Map<String, dynamic>? data = item.data();
    Style styleTemp =
        Style(idStyle: int.parse(item.id), nomStyle: data["NomStyle"]);
    listeStyle.add(styleTemp);
  }
  return listeStyle;
}

Future<List<Contact>> findAllContact() async {
  List<Contact> listeContact = [];
  return listeContact;
}

/* ---- PARTIE AjoutGroupe et sonorisation ---- */

/* fonction maxIdGroupe => permet de récupérer l'id maximum du groupe */
Future<int> maxIdGroupe() async {
  int maxId = 0;

  return maxId;
}

Future<int> getMaxIdVille() async {
  return 0;
}

Future<int> getMaxIdStyle() async {
  return 0;
}

Future<int> getMaxIdInstrument() async {
  return 0;
}

Future<bool> createGroupe(Groupe groupeCreate) async {
  bool isSuccess = false;
  return isSuccess;
}

Future<bool> createVille(Ville villeCreate) async {
  bool isSuccess = true;
  return isSuccess;
}

Future<bool> createStyle(Style styleCreate) async {
  bool isSuccess = true;
  return isSuccess;
}

Future<bool> createInstrument(Instrument instrumentCreate) async {
  bool isSuccess = true;
  return isSuccess;
}

Future<Contact> retrieveContact(String numeroTelephone) async {
  FirebaseFirestore db = FirebaseFirestore.instance;

//On récupére le contact associer au numéro de téléphone

  QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await db.collection("Contact").get();
  Contact? contactRetrieve;
  //pour chaque groupe dans la collection
  for (var item in querySnapshot.docs) {
    //Récupération des données
    Map<String, dynamic>? data = item.data();
    //NumeroTel egal donc bon numero
    if (data["NumeroTelephone"] == numeroTelephone) {
      Ville villeTemp;
      villeTemp = await retrieveVille(int.parse(data["idVille"]));
      contactRetrieve = Contact(numeroTelephone, data["Nom"], data["Prenom"],
          data["Mail"], villeTemp);
    }
  }

  return contactRetrieve!;
}

Future<Ville> retrieveVille(int idVille) async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  //On récupère le contenu de la collection groupe
  QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await db.collection("Villes").get();

  Ville? villeHabiter;
  //pour chaque groupe dans la collection
  for (var item in querySnapshot.docs) {
    //Récupération des données
    Map<String, dynamic>? data = item.data();
    //id égale donc bonne ville
    if (item.id == idVille.toString()) {
      villeHabiter = Ville(
          idVille: int.parse(item.id),
          codePostal: data["CodePostal"],
          nomVille: data["NomVille"]);
    }
  }
  return villeHabiter!;
}

Future<Personne> retrievePersonne(String email) async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  //On récupère le contenu de la collection groupe
  QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await db.collection("Utilisateurs").get();

  Personne? personneRetrieve;
  //pour chaque groupe dans la collection
  for (var item in querySnapshot.docs) {
    //Récupération des données
    Map<String, dynamic>? data = item.data();
    //Email egal donc on set l'utilisateur aux donées
    if (data["Mail"] == email) {
      Ville villeHabiter = await retrieveVille(data["idVille"]);
      personneRetrieve = Personne(
        data["NumeroTelephone"],
        data["Nom"],
        data["Prenom"],
        data["Mail"],
        villeHabiter,
      );
    }
  }
  return personneRetrieve!;
}

/* PARTIE POSTULAT */
/* Fonction create candidat asynchrone qui essaye de créer un candidat dans la base de données et retourne le statut de la tentative de création
Paramètre : id du groupe postuler ; objet candidat pour le candidat concerner ; instrument du candidat => liste instrument ; style du candidat => liste de style

*/
Future<bool> createPostulat(int idGroupe, Personne candidat,
    List<int> styleCandidat, List<int> instrumentCandidat) async {
  FirebaseFirestore db = FirebaseFirestore.instance;

  return false;
}

Future<List<Groupe>> findAllGroupeCompte(String email) async {
  List<Groupe> groupeDuCompte = [];
  FirebaseFirestore db = FirebaseFirestore.instance;
  //On récupère le contenu de la collection groupe
  QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await db.collection("Groupes").get();

  //pour chaque groupe dans la collection
  for (var item in querySnapshot.docs) {
    //Récupération des données
    Map<String, dynamic>? data = item.data();

    //item pour la boucle
    Groupe groupeTemp = Groupe(
        idGroupe: int.parse(item.id),
        nomGroupe: data["NomGroupe"],
        numeroRemplacementContact: data["NumeroRemplacementContact"],
        ingeSon: data["IngeSon"],
        possederSonorisation: data["PossederSonorisation"],
        modeleSono: data["ModeleSono"],
        descriptionSono: data["DescriptionSono"],
        prixLocationSono: data["PrixLocaSono"],
        ingePro: data["IngePro"],
        prixInge: data["PrixInge"],
        villeRepetition:
            Ville(idVille: 1, nomVille: "Aubusson", codePostal: "23200"),
        personneAContacter: Contact(
          "",
          "jean",
          "bignon",
          "jbignon@gmail.com",
          Ville(idVille: 1, nomVille: "Aubusson", codePostal: "23200"),
        ),
        stylDuGroupe: [
          Style(idStyle: 1, nomStyle: "Jazz"),
          Style(idStyle: 2, nomStyle: "Rock")
        ],
        instrumentDuGroupe: [
          Instrument(idInstrument: 1, nomInstrument: "guitare"),
          Instrument(idInstrument: 2, nomInstrument: "batterie")
        ]);

    //Ajout item i dans la boucle
    groupeDuCompte.add(groupeTemp);
  }

  return groupeDuCompte;
}
