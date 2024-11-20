/* createGroupe qui prend en paramètre un objet groupe qui essaye de créer le groupe dans firebase et retourne le statut du résultat */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ukruzwa/data/dataSource/remote/instrument_firebase.dart';
import 'package:ukruzwa/data/dataSource/remote/personne_firebase.dart';
import 'package:ukruzwa/data/dataSource/remote/style_firebase.dart';
import 'package:ukruzwa/data/dataSource/remote/ville_firebase.dart';
import 'package:ukruzwa/domain/models/groupe.dart';
import 'package:ukruzwa/domain/models/instrument.dart';
import 'package:ukruzwa/domain/models/personnne.dart';
import 'package:ukruzwa/domain/models/style.dart';
import 'package:ukruzwa/domain/models/ville.dart';

Future<bool> createGroupe(Groupe groupeCreate) async {
  bool isSuccess = false;
  return isSuccess;
}

/* Fonction findAllGroupeCompte qui prend en paramètre le mail de l'utilisateur et retourne la liste de groupe affilier à son compte */
Future<List<Groupe>> findAllGroupeCompte(String email) async {
  List<Groupe> collectionGroupe = [];

  // On récupère le numéro de téléphone associer à l'email
  Personne personneTemp = Personne.empty();
  personneTemp = await retrievePersonne(email);

  FirebaseFirestore db = FirebaseFirestore.instance;
  //On récupère le contenu de la collection groupe
  QuerySnapshot<Map<String, dynamic>> querySnapshot = await db
      .collection("Groupes")
      .where("NumeroTelephone", isEqualTo: personneTemp.numeroTelephone)
      .get();

  //pour chaque groupe dans la collection
  for (var item in querySnapshot.docs) {
    //Récupération des données
    Map<String, dynamic>? data = item.data();

    Groupe groupeTemp = await Groupe.empty().GroupeFromJSON(data);

    //Ajout item i dans la boucle
    collectionGroupe.add(groupeTemp);
  }

  return collectionGroupe;
}

/* Méthode deleteGroupe */
Future<void> deleteGroupe(String idGroupe) async {}

/* Méthode findAllGrouperecherche qui prend en paramètre le libelle de la recherche et l'option cibler et retourne la liste de groupe associer */
Future<List<Groupe>> findAllGroupeRecherche(
    String libelle, String option) async {
  List<Groupe> collectionGroupe = [];
  return collectionGroupe;
}

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

    Groupe groupeTemp = await Groupe.empty().GroupeFromJSON(data);
    //Ajout item i dans la boucle
    collectionGroupe.add(groupeTemp);
  }

  return collectionGroupe;
}
