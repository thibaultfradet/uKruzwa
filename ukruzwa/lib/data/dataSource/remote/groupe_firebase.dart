import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ukruzwa/data/dataSource/remote/personne_firebase.dart';
import 'package:ukruzwa/data/dataSource/remote/style_firebase.dart';
import 'package:ukruzwa/domain/models/groupe.dart';
import 'package:ukruzwa/domain/models/personnne.dart';
import 'package:ukruzwa/domain/models/style.dart';

/* Fonction createGroupe qui prend en paramètre un objet groupe et créer un objet groupe en base retourne l'id du groupe si l'opération c'est bien passé sinon retourne une chaîne de caractère vide*/
Future<Groupe> createGroupe(Groupe groupeCreate) async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final docGroupe = db.collection("Groupes").doc();
  try {
    await docGroupe.set(groupeCreate.toFirestore(docGroupe.id));
  } catch (exception) {
    return Groupe.empty();
  }
  groupeCreate.idGroupe = docGroupe.id;
  return groupeCreate;
}

/* Fonction updateGroupe qui prend en paramètre un groupe et le met à jour dans la base de données
Retourne true si la modification est réussi false sinon */
Future<bool> updateGroupe(Groupe groupeEdit) async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final docGroupe = db.collection("Groupes").doc(groupeEdit.idGroupe);
  try {
    await docGroupe.set(groupeEdit.toFirestore(groupeEdit.idGroupe!));
  } catch (exception) {
    return false;
  }
  return true;
}

/* Fonction retrieveGroupe qui prend en paramètre un id de groupe et retourne l'objet groupe associé dans la base de données */
Future<Groupe> retrieveGroupe(String idGroupe) async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final docGroupe = db.collection("Groupes").doc(idGroupe);

  var getDataGroupe = await docGroupe.get();
  Map<String, dynamic>? dataGroupe = getDataGroupe.data();

  Groupe groupeTemp = await Groupe.empty().groupeFromJSON(dataGroupe!);
  return groupeTemp;
}

/*Fonction updateGroupeSonorisation => 
Prend en parmètre un id de groupe et un id de sonorisation et fait le lien entre les deux dans la base de données */
Future<bool> updateGroupeSonorisation(
    String idGroupe, String idSonorisation) async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final docGroupe = db.collection("Groupes").doc(idGroupe);
  try {
    await docGroupe.update({"idSonorisation": idSonorisation});
  } catch (exception) {
    return false;
  }
  return true;
}

/* Méthode deleteGroupe => qui supprimer un objet groupe en base de données baser sur l'id du groupe passer en paramètre */
Future<bool> deleteGroupe(String idGroupe) async {
  try {
    FirebaseFirestore db = FirebaseFirestore.instance;
    final docGroupe = db.collection("Groupes").doc(idGroupe);
    docGroupe.delete();
    return true;
  } catch (exception) {
    return false;
  }
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

    Groupe groupeTemp = await Groupe.empty().groupeFromJSON(data);
    //Ajout item i dans la boucle
    collectionGroupe.add(groupeTemp);
  }

  return collectionGroupe;
}

/* variant findAll */
/* Méthode findAllGrouperecherche qui prend en paramètre le libelle de la recherche et l'option cibler et retourne la liste de groupe associer */
Future<List<Groupe>> findAllGroupeRecherche(String libelle) async {
  List<Groupe> collectionGroupe = [];
  FirebaseFirestore db = FirebaseFirestore.instance;

  // Query snapshot qui va dependre des paramètres
  QuerySnapshot<Map<String, dynamic>>? querySnapshot;

  // On récupère d'abord le style en base
  Style? styleTemp = await retrieveStyleByLibelle(libelle);
  querySnapshot = await db
      .collection("Groupes")
      .where("idStyles", arrayContains: styleTemp.idStyle)
      .get();
  // si le style n'a pas été trouvé
  // ignore: unnecessary_null_comparison
  if (styleTemp == null) {
    return [];
  }
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

/* Méthode getNbChanteursDuGroupe => 
  Prend en paramètre un id de groupe
  Retourne le nombre de chanteurs présent dans le groupe
  */
Future<int> getNbChanteursDuGroupe(String idGroupe) async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final docGroupe = db.collection("Groupes").doc(idGroupe);

  var getDataGroupe = await docGroupe.get();
  Map<String, dynamic>? dataGroupe = getDataGroupe.data();

  int counter = 0; // Initialize the counter
  String idChanteur = "TRObRcioAfUvrk67BDLO";
  // Loop through the JSON list
  dataGroupe!["idInstruments"].forEach((element) {
    // Check if the string element matches the target string
    if (element == idChanteur) {
      counter++; // Increment the counter
    }
  });

  return counter;
}
