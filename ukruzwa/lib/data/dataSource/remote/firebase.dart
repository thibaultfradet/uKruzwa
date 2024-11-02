import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ukruzwa/domain/Style.dart';
import 'package:ukruzwa/domain/Instrument.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ukruzwa/domain/Ville.dart';
import 'package:ukruzwa/domain/Groupe.dart';

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
  return collectionGroupe;
}

Future<List<Groupe>> findAllGroupeRecherche(
    String libelle, String option) async {
  List<Groupe> collectionGroupe = [];
  return collectionGroupe;
}

/* Fonction getStyleFromGroupe qui prend en paramètre un objet groupe et retourne une liste de style jouer par le groupe */
Future<List<Style>> getStyleFromGroupe(int idGroupe) async {
  List<Style> styleDuGroupe = [];
  List<int> listeIdStyle = [];

  FirebaseFirestore db = FirebaseFirestore.instance;

  try {
    // Récupérer tous les documents de la collection "jouer"
    QuerySnapshot querySnapshot = await db
        .collection("jouer")
        .where("idGroupe", isEqualTo: idGroupe)
        .get();

    // Parcourir chaque document récupéré
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      listeIdStyle.add(int.parse(data["idStyle"].toString()));
    }
  } catch (e) {
    return [];
  }

  //Maintenant touts les id recuperer pour chaque id on recuperer le libelle
  try {
    for (int idStyle in listeIdStyle) {
      QuerySnapshot querySnapshot = await db
          .collection("style")
          .where("idStyle", isEqualTo: idStyle)
          .get();

      // Parcourir chaque document récupéré
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Style styleTemp = Style(
          idStyle: int.parse(data["idStyle"].toString()),
          nomStyle: data["nomStyle"].toString(),
        );

        styleDuGroupe.add(styleTemp);
      }
    }
  } catch (e) {
    return [];
  }

  return styleDuGroupe;
}

/* Fonction getInstrumentFromGroupe qui prend en paramètre un objet groupe et retourne une liste d'instrument jouer par le groupe */
Future<List<Instrument>> getInstrumentFromGroupe(int idGroupe) async {
  List<Instrument> instrumentDuGroupe = [];
  List<int> listeIdinstrument = [];

  FirebaseFirestore db = FirebaseFirestore.instance;

  try {
    // Récupérer tous les documents de la collection "utiliser"
    QuerySnapshot querySnapshot = await db
        .collection("utiliser")
        .where("idGroupe", isEqualTo: idGroupe)
        .get();

    // Parcourir chaque document récupéré
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      listeIdinstrument.add(int.parse(data["idInstrument"].toString()));
    }
  } catch (e) {
    return [];
  }

  //Maintenant touts les id recuperer pour chaque id on recuperer le libelle
  try {
    for (int idinstrument in listeIdinstrument) {
      QuerySnapshot querySnapshot = await db
          .collection("instrument")
          .where("idInstrument", isEqualTo: idinstrument)
          .get();

      // Parcourir chaque document récupéré
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Instrument instrumentTemp = Instrument(
          idInstrument: int.parse(data["idinstrument"].toString()),
          nomInstrument: data["nominstrument"].toString(),
        );

        instrumentDuGroupe.add(instrumentTemp);
      }
    }
  } catch (e) {
    return [];
  }

  return instrumentDuGroupe;
}

Future<Ville> getVilleFromGroupeRepeter(int idVille) async {
  FirebaseFirestore db = FirebaseFirestore.instance;

  // Requête pour récupérer le document avec le champ idVille correspondant
  final querySnapshot =
      await db.collection("Ville").where("idVille", isEqualTo: idVille).get();

  // Vérification si au moins un document a été trouvé
  if (querySnapshot.docs.isNotEmpty) {
    // Récupérer le premier document trouvé
    var dataget = querySnapshot.docs.first.data();

    // Récupération des champs nécessaires
    String nomVille = dataget["Nom"];
    String codePostal = dataget["CodePostal"];

    // Création d'une instance de Ville avec les données récupérées
    //Pas besoin de l'évènement concerner car il s'agit de la ville répéter
    Ville villeConcerner = Ville(
      idVille: idVille,
      nomVille: nomVille,
      codePostal: codePostal,
    );

    return villeConcerner;
  } else {
    throw Exception();
  }
}

Future<List<Ville>> getVilleFromGroupeEndroitsJoues(int idGroupe) async {
  List<Ville> collectionEndroitsJoues = [];

  List<int> listeIdVille = [];

  FirebaseFirestore db = FirebaseFirestore.instance;

  try {
    // Récupérer tous les documents de la collection "Deja Jouer"
    QuerySnapshot querySnapshot = await db
        .collection("Deja Jouer")
        .where("idGroupe", isEqualTo: idGroupe)
        .get();

    // Parcourir chaque document récupéré
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      listeIdVille.add(int.parse(data["idVille"].toString()));
    }
  } catch (e) {
    return [];
  }

  //Maintenant touts les id recuperer pour chaque id on recuperer le libelle
  try {
    for (int idVille in listeIdVille) {
      QuerySnapshot querySnapshot = await db
          .collection("Ville")
          .where("idVille", isEqualTo: idVille)
          .get();

      // Parcourir chaque document récupéré
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Ville villeTemp = Ville(
          idVille: data["idVille"],
          nomVille: data["nomVille"],
          codePostal: data["codePostal"],
          nomEvenement: data["nomEvenement"],
        );

        collectionEndroitsJoues.add(villeTemp);
      }
    }
  } catch (e) {
    return [];
  }

  return collectionEndroitsJoues;
}
