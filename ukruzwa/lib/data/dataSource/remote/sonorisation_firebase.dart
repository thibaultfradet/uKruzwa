import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ukruzwa/data/dataSource/remote/groupe_firebase.dart';
import 'package:ukruzwa/domain/models/groupe.dart';
import 'package:ukruzwa/domain/models/sonorisation.dart';

/* Fonction createSonorisation qui prend en paramètre un objet sonorisation et le créer dans la base 
retourne :
  Chaine de caractère vide si non réussi
  L'identifiant de l'objet sonorisation tout juste crée si réussi
*/
Future<String> createSonorisation(Sonorisation sonorisationCreate) async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final docSonorisation = db.collection("Sonorisation").doc();
  try {
    await docSonorisation
        .set(sonorisationCreate.toFirestore(docSonorisation.id));
  } catch (exception) {
    return "";
  }
  return docSonorisation.id;
}

/* Fonction retrieveSonorisation qui prend en paramètre un id et retourne la sonorisation affilié à sa sonorisation dans la base de données */
Future<Sonorisation> retrieveSonorisation(String idSonorisation) async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  final docSonorisation = db.collection("Sonorisation").doc(idSonorisation);

  var getDataSonorisation = await docSonorisation.get();
  Map<String, dynamic>? dataSonorisation = getDataSonorisation.data();

  return Sonorisation.fromJSON(dataSonorisation!);
}

/* Méthode removeSonoFromGroupe => permet de détacher la sonorisation a un groupe*/
Future<bool> removeSonoFromGroupe(
    String idSonorisation, Groupe groupeConcerner) async {
  try {
    //Modification des champs => ingeSon,ingePro,prixInge,idSonorisation
    Groupe groupeTemp = groupeConcerner;
    groupeTemp.ingePro = null;
    groupeTemp.ingeSon = null;
    groupeTemp.prixInge = null;
    groupeTemp.sonorisationDuGroupe = null;

    bool success = await updateGroupe(groupeTemp);
    if (success) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}

/* Fonction createOrEditSonorisation qui prend en paramètre tout le nécessaire pour créer un objet sonorisation ainsi qu'un objet groupe
 => Cette méthode Vérifie si la sonorisation n'existe pas déjà dans la base de données
 Si elle n'existe pas la sonorisation est créer
 Dans tout les cas on fait le lien avec le groupe et la sonorisation (créer ou existente)
 */
Future<bool> createOrEditSonorisation(String modele, String description,
    double prixLocation, double puissanceSono, Groupe groupeConcerner) async {
  FirebaseFirestore db = FirebaseFirestore.instance;

  try {
    final sonoRef = db.collection("Sonorisation");
    var querySnapshot = await sonoRef
        .where("modeleSono", isEqualTo: modele)
        .where("DescriptionSonorisation", isEqualTo: description)
        .where("PrixLocaSono", isEqualTo: prixLocation)
        .where("PuissanceSono", isEqualTo: puissanceSono)
        .limit(1)
        .get(); // Récupérer les résultats
    String idSonorisation = "";

    // Vérifier si la collection est vide ou non
    if (querySnapshot.docs.isEmpty) {
      // N'existe pas encore => on crée une nouvelle entrée
      Sonorisation sonoTempCreate =
          Sonorisation("", modele, description, prixLocation, puissanceSono);
      idSonorisation = await createSonorisation(sonoTempCreate);
    } else {
      // Récupérer l'ID du premier document
      idSonorisation = querySnapshot.docs.first.id;
    }

    //Dans touts les cas on affilie la sonorisation et le groupe
    Sonorisation sonorisationTemp = Sonorisation.empty();
    sonorisationTemp.idSonorisation = idSonorisation;
    groupeConcerner.sonorisationDuGroupe = sonorisationTemp;
    updateGroupeSonorisation(
        groupeConcerner.idGroupe!, sonorisationTemp.idSonorisation);

    return true;
  } catch (e) {
    return false;
  }
}
