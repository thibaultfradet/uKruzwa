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
    //objet pour boucle
    /*Ville villeBoucle;
    Contact contactBoucle;
    Style styleBoucle;
    List<Style> listeStyleBoucle;
    Instrument instrumentBoucle;
    List<Instrument> listeInstrumentBoucle; */

    //item pour la boucle
    Groupe groupeTemp = Groupe(
        idGroupe: data["idGroupe"],
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
        personneAContacter: Contact("", "jean", "bignon", "jbignon@gmail.com"),
        stylDuGroupe: [
          Style(idStyle: 1, nomStyle: "Jazz"),
          Style(idStyle: 2, nomStyle: "Rock")
        ],
        instrumentDuGroupe: [
          Instrument(idInstrument: 1, nomInstrument: "guitare"),
          Instrument(idInstrument: 2, nomInstrument: "batterie")
        ]);

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

Future<List<Ville>> findAllVille() async {
  List<Ville> listeVille = [];
  return listeVille;
}

Future<List<Instrument>> findAllInstrument() async {
  List<Instrument> listeInstrument = [];
  return listeInstrument;
}

Future<List<Style>> findAllStyle() async {
  List<Style> listeStyle = [];
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

Future<Contact> retrieveContact(String numeroTelephone) async {
  Contact contactRetrieve = Contact(numeroTelephone, "", "", "");

  return contactRetrieve;
}
