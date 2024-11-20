import 'package:cloud_firestore/cloud_firestore.dart';

class Instrument {
  final int idInstrument;
  final String nomInstrument;

  /* Constructeur vide */
  Instrument.empty()
      : idInstrument = 0,
        nomInstrument = '';
  /* Constructeur surcharger */
  Instrument({required this.idInstrument, required this.nomInstrument});

  Future<int> getMaxIdInstrument() async {
    return 0;
  }

  Future<bool> createInstrument(Instrument instrumentCreate) async {
    bool isSuccess = true;
    return isSuccess;
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
          idInstrument: int.parse(item.id),
          nomInstrument: data["NomInstrument"]);
      listeInstrument.add(instrumentTemp);
    }

    return listeInstrument;
  }
}
