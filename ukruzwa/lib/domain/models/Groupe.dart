import 'package:ukruzwa/data/dataSource/remote/instrument_firebase.dart';
import 'package:ukruzwa/data/dataSource/remote/personne_firebase.dart';
import 'package:ukruzwa/data/dataSource/remote/style_firebase.dart';
import 'package:ukruzwa/data/dataSource/remote/ville_firebase.dart';
import 'package:ukruzwa/domain/models/ville.dart';
import 'package:ukruzwa/domain/models/personnne.dart';
import 'package:ukruzwa/domain/models/style.dart';
import 'package:ukruzwa/domain/models/instrument.dart';

class Groupe {
  final String? idGroupe;
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
  final List<Style>? stylesDuGroupe;
  final List<Instrument>? instrumentsDuGroupe;
  final List<Ville>? endroitsDejaJoues;

  /* Constructeur vide */
  Groupe.empty()
      : idGroupe = "",
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
        stylesDuGroupe = [],
        instrumentsDuGroupe = [],
        endroitsDejaJoues = [];

  /* Constructeur surchargé */
  Groupe({
    this.idGroupe,
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
    this.stylesDuGroupe,
    this.instrumentsDuGroupe,
    this.endroitsDejaJoues,
  });

  /* FONCTION DE CONVERSION */
  Map<String, dynamic> toFirestore() {
    return {
      'IngeSon': ingeSon,
      'ModeleSono': modeleSono,
      'NomGroupe': nomGroupe,
      'NumeroRemplacementContact': numeroRemplacementContact,
      'NumeroTelephone': personneAContacter.numeroTelephone,
      'PossederSonorisation': possederSonorisation,
      'PrixInge': prixInge,
      'PrixLocaSono': prixLocationSono,
      'PuissanceSono': puissanceSonorisation,
      'idVille': villeRepetition.idVille,
      'idInstruments': instrumentsDuGroupe!.map((item) {
        return item.idInstrument;
      }).toList(),
      'IdStyles': stylesDuGroupe!.map((item) {
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
      possederSonorisation: json['PossederSonorisation'],
      ingeSon: json['IngeSon'],
      modeleSono: json['ModeleSono'],
      descriptionSono: json['DescriptionSono'],
      prixLocationSono: json['PrixLocaSono'],
      puissanceSonorisation: json['PuissanceSono'],
      ingePro: json['IngePro'],
      prixInge: json['PrixInge'],
      villeRepetition: await retrieveVille(json['idVille']),
      personneAContacter: await retrieveContact(json['NumeroTelephone']),
      stylesDuGroupe: styles,
      instrumentsDuGroupe: instruments,
      endroitsDejaJoues: endroits,
    );
  }
}
