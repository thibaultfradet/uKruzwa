import 'package:cloud_firestore/cloud_firestore.dart';

class Style {
  final int idStyle;
  final String nomStyle;

  /* Constructeur vide */
  Style.empty()
      : idStyle = 0,
        nomStyle = '';
  /* Constructeur surcharger */
  Style({required this.idStyle, required this.nomStyle});

  Future<int> getMaxIdStyle() async {
    return 0;
  }

  Future<bool> createStyle(Style styleCreate) async {
    bool isSuccess = true;
    return isSuccess;
  }

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
}
