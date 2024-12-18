import 'package:ukruzwa/data/dataSource/remote/instrument_firebase.dart';
import 'package:ukruzwa/data/dataSource/remote/personne_firebase.dart';
import 'package:ukruzwa/data/dataSource/remote/sonorisation_firebase.dart';
import 'package:ukruzwa/data/dataSource/remote/style_firebase.dart';
import 'package:ukruzwa/data/dataSource/remote/ville_firebase.dart';
import 'package:ukruzwa/domain/models/sonorisation.dart';
import 'package:ukruzwa/domain/models/ville.dart';
import 'package:ukruzwa/domain/models/personnne.dart';
import 'package:ukruzwa/domain/models/style.dart';
import 'package:ukruzwa/domain/models/instrument.dart';

class Groupe {
  final String? idGroupe;
  final String nomGroupe;
  final String numeroRemplacementContact;
  final bool? ingeSon;
  final bool? ingePro;
  final int? prixInge;
  //Clé étrangère
  final Ville villeRepetition;
  final Contact personneAContacter;
  Sonorisation? sonorisationDuGroupe;
  final List<Style>? stylesDuGroupe;
  final List<Instrument>? instrumentsDuGroupe;
  final List<Ville>? endroitsDejaJoues;

  /* Constructeur vide */
  Groupe.empty()
      : idGroupe = "",
        nomGroupe = '',
        numeroRemplacementContact = '',
        ingeSon = null,
        ingePro = null,
        prixInge = null,
        villeRepetition = Ville.empty(),
        personneAContacter = Contact.empty(),
        sonorisationDuGroupe = Sonorisation.empty(),
        stylesDuGroupe = [],
        instrumentsDuGroupe = [],
        endroitsDejaJoues = [];

  /* Constructeur surchargé */
  Groupe({
    this.idGroupe,
    required this.nomGroupe,
    required this.numeroRemplacementContact,
    this.ingeSon,
    this.ingePro,
    this.prixInge,
    required this.villeRepetition,
    required this.personneAContacter,
    this.sonorisationDuGroupe,
    this.stylesDuGroupe,
    this.instrumentsDuGroupe,
    this.endroitsDejaJoues,
  });

  /* FONCTION DE CONVERSION */
  Map<String, dynamic> toFirestore(String idGroupe) {
    return {
      'idGroupe': idGroupe,
      'IngeSon': ingeSon,
      'NomGroupe': nomGroupe,
      'NumeroRemplacementContact': numeroRemplacementContact,
      'NumeroTelephone': personneAContacter.numeroTelephone,
      'PrixInge': prixInge,
      'idSonorisation': sonorisationDuGroupe!.idSonorisation,
      'idVille': villeRepetition.idVille,
      'idInstruments': instrumentsDuGroupe!.map((item) {
        return item.idInstrument;
      }).toList(),
      'idStyles': stylesDuGroupe!.map((item) {
        return item.idStyle;
      }).toList(),
      'idVilles': endroitsDejaJoues!.map((item) {
        return item.idVille;
      }).toList()
    };
  }

  /* Fonction from json qui prend en paramètre un json et renvoie l'objet groupe en récupérant les différents objets externe en + */
  Future<Groupe> groupeFromJSON(Map<String, dynamic> json) async {
    // objet liste externe
    List<Style> styles = await Future.wait((json['idStyles'] as List)
        .map((styleId) async => await retrieveStyle(styleId))
        .toList());
    List<Instrument> instruments = await Future.wait(
        (json['idInstruments'] as List)
            .map((instrId) async => await retrieveInstrument(instrId))
            .toList());
    List<Ville> endroits = await Future.wait((json['idVilles'] as List)
        .map((villeId) async => await retrieveVille(villeId))
        .toList());
    return Groupe(
      idGroupe: json['idGroupe'],
      nomGroupe: json['NomGroupe'],
      numeroRemplacementContact: json['NumeroRemplacementContact'],
      ingeSon: json['IngeSon'],
      ingePro: json['IngePro'],
      prixInge: json['PrixInge'],
      villeRepetition: await retrieveVille(json['idVille']),
      personneAContacter: await retrieveContact(json['NumeroTelephone']),
      sonorisationDuGroupe:
          json["idSonorisation"].isEmpty || json["idSonorisation"] == null
              ? null
              : await retrieveSonorisation(json["idSonorisation"]),
      stylesDuGroupe: styles,
      instrumentsDuGroupe: instruments,
      endroitsDejaJoues: endroits,
    );
  }
}
