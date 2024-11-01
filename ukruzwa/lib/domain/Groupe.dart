import 'package:ukruzwa/domain/Ville.dart';
import 'package:ukruzwa/domain/Personne.dart';

class Groupe {
  final int idGroupe;
  final String nomGroupe;
  final String numeroRemplacementContact;
  final bool ingeSon;
  final bool possederSonorisation;
  final String? modeleSono;
  final String? descriptionSono;
  final int? prixLocationSono;
  final int? puissanceSonorisation;
  final bool? ingePro;
  final int? prixInge;
  //Clé étrangère
  final Ville villeRepetition;
  final Contact personneAContacter;

  Groupe(
      {required this.idGroupe,
      required this.nomGroupe,
      required this.numeroRemplacementContact,
      required this.ingeSon,
      required this.possederSonorisation,
      this.modeleSono,
      this.descriptionSono,
      this.prixLocationSono,
      this.puissanceSonorisation,
      this.ingePro,
      this.prixInge,
      required this.villeRepetition,
      required this.personneAContacter});
}
