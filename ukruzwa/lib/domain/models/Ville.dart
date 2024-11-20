import 'package:cloud_firestore/cloud_firestore.dart';

class Ville {
  final int idVille;
  final String nomVille;
  final String codePostal;

  /* Constructeur vide */
  Ville.empty()
      : idVille = 0,
        nomVille = '',
        codePostal = '';
  /* Constructeur surcharger */
  Ville({
    required this.idVille,
    required this.nomVille,
    required this.codePostal,
  });

  /* Fonction getMaxIdVille qui récupére l'id max de firebase pour les ville et le retourne */
  Future<int> getMaxIdVille() async {
    return 0;
  }

  /* Méthode createVille qui prend en paamètre une ville et qui retourne un booleen si la ville a réussi à être créer */
  Future<bool> createVille(Ville villeCreate) async {
    bool isSuccess = true;
    return isSuccess;
  }

  /* retrieveVille qui prend en paramètre un idVile et retourne un objet ville lier dans la base de données */
  Future<Ville> retrieveVille(int idVille) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    //On récupère le contenu de la collection groupe
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await db.collection("Villes").get();

    Ville? villeHabiter;
    //pour chaque groupe dans la collection
    for (var item in querySnapshot.docs) {
      //Récupération des données
      Map<String, dynamic>? data = item.data();
      //id égale donc bonne ville
      if (item.id == idVille.toString()) {
        villeHabiter = Ville(
          idVille: int.parse(item.id),
          codePostal: data["CodePostal"],
          nomVille: data["NomVille"],
        );
      }
    }
    return villeHabiter!;
  }

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
      Ville villeTemp = Ville(
          idVille: int.parse(item.id),
          codePostal: data["CodePostal"],
          nomVille: data["NomVille"]);
      listeVille.add(villeTemp);
    }
    return listeVille;
  }
}
