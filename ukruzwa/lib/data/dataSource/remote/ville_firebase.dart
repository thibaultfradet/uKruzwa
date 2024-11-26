/* CRUD ET AUTRE */

/* Méthode createVille qui prend en paamètre une ville et qui retourne un booleen si la ville a réussi à être créer */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ukruzwa/domain/models/ville.dart';

Future<String> createVille(Ville villeCreate) async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  try {
    // On ajoute la ville et l'utilisateur en base
    final docVille = db.collection("Villes").doc();
    await docVille.set(villeCreate.toFirestore());
    await docVille.update({'idVille': docVille.id});

    //si encore a ce stade alors création reussi donc on retourne l'id du doc créer
    return docVille.id;
  } catch (e) {
    return "";
  }
}

/* retrieveVille qui prend en paramètre un idVile et retourne un objet ville lier dans la base de données */
Future<Ville> retrieveVille(String idVille) async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final docVille = db.collection("Villes").doc(idVille);

  var getDataVille = await docVille.get();
  Map<String, dynamic>? dataVille = getDataVille.data();

  return Ville.fromJSON(dataVille!);
}

/* Fonction findAllVille qui retourne la liste des ville de la base de données */
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
    Ville villeTemp = Ville.fromJSON(data);
    listeVille.add(villeTemp);
  }
  return listeVille;
}
