/* createGroupe qui prend en paramètre un objet groupe qui essaye de créer le groupe dans firebase et retourne le statut du résultat */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ukruzwa/data/dataSource/remote/instrument_firebase.dart';
import 'package:ukruzwa/data/dataSource/remote/personne_firebase.dart';
import 'package:ukruzwa/data/dataSource/remote/style_firebase.dart';
import 'package:ukruzwa/domain/models/groupe.dart';
import 'package:ukruzwa/domain/models/instrument.dart';
import 'package:ukruzwa/domain/models/personnne.dart';
import 'package:ukruzwa/domain/models/style.dart';

Future<bool> createGroupe(Groupe groupeCreate) async {
  bool isSuccess = false;
  return isSuccess;
}

/* Méthode deleteGroupe => qui supprimer un objet groupe en base de données baser sur l'id du groupe passer en paramètre */
Future<void> deleteGroupe(String idGroupe) async {}

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

    Groupe groupeTemp = await Groupe.empty().groupeFromJSON(data);
    //Ajout item i dans la boucle
    collectionGroupe.add(groupeTemp);
  }

  return collectionGroupe;
}

/* variant findAll */
/* Méthode findAllGrouperecherche qui prend en paramètre le libelle de la recherche et l'option cibler et retourne la liste de groupe associer */
Future<List<Groupe>> findAllGroupeRecherche(
    String libelle, String option) async {
  List<Groupe> collectionGroupe = [];

  FirebaseFirestore db = FirebaseFirestore.instance;

  // Query snapshot qui va dependre des paramètres
  QuerySnapshot<Map<String, dynamic>>? querySnapshot;

  switch (option) {
    case "Nom":
      querySnapshot = await db
          .collection("Groupes")
          .where("NomGroupe", isEqualTo: libelle)
          .get();
      break;

    // => se base sur le libelle fournit et récupère touts les groupes avec au moins 1 fois le style
    case "Style":
      // On récupère d'abord le style en base
      Style styleTemp = await retrieveStyleByLibelle(libelle);
      querySnapshot = await db
          .collection("Groupes")
          .where("idStyles", arrayContains: styleTemp.idStyle)
          .get();
      break;
    case "Instrument":
      // On récupère d'abord le style en base
      Instrument instrumentTemp = await retrieveInstrumentByLibelle(libelle);
      querySnapshot = await db
          .collection("Groupes")
          .where("idInstruments", arrayContains: instrumentTemp.idInstrument)
          .get();
      break;
    // par défaut => on retourne une liste vide car il s'agit d'une erreur
    default:
      return [];
  }

  //pour chaque groupe dans la collection
  for (var item in querySnapshot!.docs) {
    //Récupération des données
    Map<String, dynamic>? data = item.data();

    Groupe groupeTemp = await Groupe.empty().groupeFromJSON(data);
    //Ajout item i dans la boucle
    collectionGroupe.add(groupeTemp);
  }

  return collectionGroupe;
}

/* Fonction findAllGroupeCompte qui prend en paramètre le mail de l'utilisateur et retourne la liste de groupe affilier à son compte */
Future<List<Groupe>> findAllGroupeCompte(String email) async {
  List<Groupe> collectionGroupe = [];

  // On récupère le contact associer à cette adresse mail pour la recherche car recherche par le biais d'un numéro de téléphone
  Contact contactTemp = await retrieveContactByMail(email);

  FirebaseFirestore db = FirebaseFirestore.instance;
  //On récupère le contenu de la collection groupe
  QuerySnapshot<Map<String, dynamic>> querySnapshot = await db
      .collection("Groupes")
      .where("NumeroTelephone", isEqualTo: contactTemp.numeroTelephone)
      .get();

  //pour chaque groupe dans la collection
  for (var item in querySnapshot.docs) {
    //Récupération des données
    Map<String, dynamic>? data = item.data();

    Groupe groupeTemp = await Groupe.empty().groupeFromJSON(data);
    //Ajout item i dans la boucle
    collectionGroupe.add(groupeTemp);
  }

  return collectionGroupe;
}
