import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ukruzwa/domain/models/style.dart';

/* CRUD ET AUTRE */

/* Fonction createStyle qui prend en paramètre un objet style qui essaye de créer le style et retourner le statut */

Future<String> createStyle(Style styleCreate) async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final docStyle = db.collection("Styles").doc();
  try {
    await docStyle.set(styleCreate.toFirestore(docStyle.id));
  } catch (exception) {
    return "";
  }
  return docStyle.id;
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
    Style styleTemp = Style.fromJSON(data);
    listeStyle.add(styleTemp);
  }
  return listeStyle;
}

/* fonction retrieveStyle qui prende un paramètre un id du style et retourne l'objet style associer dans la base de données */
Future<Style> retrieveStyle(String idStyle) async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final docStyle = db.collection("Styles").doc(idStyle);

  var getDataStyle = await docStyle.get();
  Map<String, dynamic>? dataStyle = getDataStyle.data();

  return Style.fromJSON(dataStyle!);
}

/* fonction retrieveStyleByLibelle qui prend en paramètre un libelle (unique en base) et retourne l'objet associer en base si existant */
Future<Style> retrieveStyleByLibelle(String libelle) async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  QuerySnapshot<Map<String, dynamic>> snapshotStyle =
      await db.collection("Styles").where("NomStyle", isEqualTo: libelle).get();

  Style styleTemp = Style.empty();

  for (var itemStyle in snapshotStyle.docs) {
    Map<String, dynamic>? dataStyle = itemStyle.data();
    styleTemp = Style.fromJSON(dataStyle);
  }
  return styleTemp;
}
