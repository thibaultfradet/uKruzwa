import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ukruzwa/domain/models/instrument.dart';
/* CRUD ET AUTRE */

/* Fonction createInstrument qui prend en paramètre un objet instrument qui essaye de le créer en base et retourne le numéro du doc */
Future<String> createInstrument(Instrument instrumentCreate) async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final docInstrument = db.collection("Instruments").doc();
  try {
    await docInstrument.set(instrumentCreate.toFirestore(docInstrument.id));
  } catch (exception) {
    return "";
  }
  return docInstrument.id;
}

/* Fonction findAllInstrument qui retourne la liste de touts les instruments présent dans la base de données */
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
        idInstrument: data["idInstrument"],
        nomInstrument: data["NomInstrument"]);
    listeInstrument.add(instrumentTemp);
  }

  return listeInstrument;
}

/* Fonction retrieveInstrument qui prend en paramètre un id d'instrument et retourne l'objet instrument affilier dans la base de données */
Future<Instrument> retrieveInstrument(String idInstrument) async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final docInstrument = db.collection("Instruments").doc(idInstrument);

  var getDataInstrument = await docInstrument.get();
  Map<String, dynamic>? dataInstrument = getDataInstrument.data();

  return Instrument.fromJSON(dataInstrument!);
}

/* fonction retrieveInstrumentByLibelle qui prend en paramètre un libelle (unique en base) et retourne l'objet associer en base si existant */
Future<Instrument> retrieveInstrumentByLibelle(String libelle) async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  QuerySnapshot<Map<String, dynamic>> snapshotInstrument = await db
      .collection("Instruments")
      .where("NomInstrument", isEqualTo: libelle)
      .get();

  Instrument instrumentTemp = Instrument.empty();

  for (var itemInstrument in snapshotInstrument.docs) {
    Map<String, dynamic>? dataInstrument = itemInstrument.data();
    instrumentTemp = Instrument.fromJSON(dataInstrument);
  }
  return instrumentTemp;
}
