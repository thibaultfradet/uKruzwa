import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ukruzwa/domain/models/style.dart';

/* CRUD ET AUTRE */

/* Fonction createStyle qui prend en paramètre un objet style qui essaye de créer le style et retourner le statut */

Future<bool> createStyle(Style styleCreate) async {
  bool isSuccess = true;
  return isSuccess;
}

/* fonction findAllStyle qui retourne la liste de touts les styles de la base de données */
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

/* fonction retrieveStyle qui prende un paramètre un id du style et retourne l'objet style associer dans la base de données */
Future<Style> retrieveStyle(String idStyle) async {
  Style styleTemp = Style.empty();

  return styleTemp;
}
