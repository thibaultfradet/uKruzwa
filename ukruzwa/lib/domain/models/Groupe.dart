import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ukruzwa/domain/models/ville.dart';
import 'package:ukruzwa/domain/models/personnne.dart';
import 'package:ukruzwa/domain/models/style.dart';
import 'package:ukruzwa/domain/models/instrument.dart';

class Groupe {
  final int idGroupe;
  final String nomGroupe;
  final String numeroRemplacementContact;
  final bool possederSonorisation;
  final bool? ingeSon;
  final String? modeleSono;
  final String? descriptionSono;
  final int? prixLocationSono;
  final int? puissanceSonorisation;
  final bool? ingePro;
  final int? prixInge;
  //Clé étrangère
  final Ville villeRepetition;
  final Contact personneAContacter;
  final List<Style>? stylDuGroupe;
  final List<Instrument>? instrumentDuGroupe;
  final List<Ville>? endroitsDejaJoues;

  /* Constructeur vide */
  Groupe.empty()
      : idGroupe = 0,
        nomGroupe = '',
        numeroRemplacementContact = '',
        possederSonorisation = false,
        ingeSon = null,
        modeleSono = null,
        descriptionSono = null,
        prixLocationSono = null,
        puissanceSonorisation = null,
        ingePro = null,
        prixInge = null,
        villeRepetition = Ville.empty(),
        personneAContacter = Contact.empty(),
        stylDuGroupe = [],
        instrumentDuGroupe = [],
        endroitsDejaJoues = [];
  /* Constructeur surcharger */
  Groupe({
    required this.idGroupe,
    required this.nomGroupe,
    required this.numeroRemplacementContact,
    required this.possederSonorisation,
    this.ingeSon,
    this.modeleSono,
    this.descriptionSono,
    this.prixLocationSono,
    this.puissanceSonorisation,
    this.ingePro,
    this.prixInge,
    required this.villeRepetition,
    required this.personneAContacter,
    this.stylDuGroupe,
    this.instrumentDuGroupe,
    this.endroitsDejaJoues,
  });

  Future<bool> createGroupe(Groupe groupeCreate) async {
    bool isSuccess = false;
    return isSuccess;
  }

  Future<List<Groupe>> findAllGroupeCompte(String email) async {
    List<Groupe> groupeDuCompte = [];

    return groupeDuCompte;
  }

  /* Méthode deleteGroupe */
  Future<void> deleteGroupe(String idGroupe) async {}

  /* Méthode findAllGrouperecherche qui prend en paramètre le libelle de la recherche et l'option cibler et retourne la liste de groupe associer */
  Future<List<Groupe>> findAllGroupeRecherche(
      String libelle, String option) async {
    List<Groupe> collectionGroupe = [];
    return collectionGroupe;
  }

  Future<int> maxIdGroupe() async {
    return 0;
  }

/* FindAllVille => permet de recuperer toutes les villes*/
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

  Future<List<Contact>> findAllContact() async {
    List<Contact> listeContact = [];
    return listeContact;
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

      //item pour la boucle
      Ville villeRepetition =
          await Ville.empty().retrieveVille(data["idVille"]);
      Contact personneAContacter =
          await Contact.empty().retrieveContact(data["NumeroTelephone"]);

      //objets externe
      List<Instrument> instrumentsDuGroupe = [];
      List<Style> stylesDuGroupe = [];
      List<Ville> endroitsJouesDuGroupe = [];

      //Récupérations obj externe
      //styles
      QuerySnapshot<Map<String, dynamic>> snapShotJouer = await db
          .collection("Jouer")
          .where("GroupeId", isEqualTo: item.id)
          .get();
      for (var jouer in snapShotJouer.docs) {
        Map<String, dynamic>? dataJouer = jouer.data();
        Style styleTemp = Style(
            idStyle: int.parse(jouer.id), nomStyle: dataJouer["NomStyle"]);
        stylesDuGroupe.add(styleTemp);
      }

      //instruments
      QuerySnapshot<Map<String, dynamic>> snapshotUtiliser = await db
          .collection("Utiliser")
          .where("GroupeId", isEqualTo: item.id)
          .get();
      for (var utiliser in snapshotUtiliser.docs) {
        Map<String, dynamic>? dataUtiliser = utiliser.data();
        Instrument instrumentTemp = Instrument(
            idInstrument: int.parse(utiliser.id),
            nomInstrument: dataUtiliser["NomInstrument"]);
        instrumentsDuGroupe.add(instrumentTemp);
      }

      //endroits deja joues
      QuerySnapshot<Map<String, dynamic>> snapshotVille = await db
          .collection("DejaJouer")
          .where("GroupeId", isEqualTo: item.id)
          .get();
      for (var dejajouer in snapshotVille.docs) {
        Map<String, dynamic>? dataDejaJouer = dejajouer.data();
        Ville villeTemp = Ville(
            codePostal: dataDejaJouer["CodePostal"],
            idVille: int.parse(dejajouer.id),
            nomVille: dataDejaJouer["NomVille"]);
        endroitsJouesDuGroupe.add(villeTemp);
      }

      //Création obj groupe
      Groupe groupeTemp = Groupe(
        idGroupe: int.parse(item.id),
        nomGroupe: data["NomGroupe"],
        numeroRemplacementContact: data["NumeroRemplacementContact"],
        ingeSon: data["IngeSon"],
        possederSonorisation: data["PossederSonorisation"],
        modeleSono: data["ModeleSono"],
        descriptionSono: data["DescriptionSono"],
        prixLocationSono: data["PrixLocaSono"],
        ingePro: data["IngePro"],
        prixInge: data["PrixInge"],
        villeRepetition: villeRepetition,
        personneAContacter: personneAContacter,
        endroitsDejaJoues: endroitsJouesDuGroupe,
        instrumentDuGroupe: instrumentsDuGroupe,
        stylDuGroupe: stylesDuGroupe,
      );

      //Ajout item i dans la boucle
      collectionGroupe.add(groupeTemp);
    }

    return collectionGroupe;
  }
}
