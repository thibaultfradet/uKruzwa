import 'package:ukruzwa/data/dataSource/remote/ville_firebase.dart';
import 'package:ukruzwa/domain/models/ville.dart';

class SalleSpectacle {
  final String? idSalleSpectacle;
  final String nomSalleSpectacle;
  final Ville villeSalle;
  final int nbPlaceMaximum;
  final bool possederSonorisation;
  final bool possederIngenieur;
  final bool isStructurePublic;

  SalleSpectacle(
      this.idSalleSpectacle,
      this.nomSalleSpectacle,
      this.villeSalle,
      this.nbPlaceMaximum,
      this.possederSonorisation,
      this.possederIngenieur,
      this.isStructurePublic);

  SalleSpectacle.empty()
      : idSalleSpectacle = '',
        nomSalleSpectacle = '',
        villeSalle = Ville.empty(),
        nbPlaceMaximum = 0,
        possederSonorisation = false,
        possederIngenieur = false,
        isStructurePublic = false;

  Future<SalleSpectacle> salleSpectaclefromJSON(
      Map<String, dynamic> json) async {
    return SalleSpectacle(
      json["idSalleSpectacle"],
      json["NomSalleSpectacle"],
      await retrieveVille(json["idVille"]),
      json["NbPlaceMaximum"],
      json["PossederSonorisation"],
      json["PossederIngenieur"],
      json["IsStructurePublic"],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'idSalleSpectacle': idSalleSpectacle,
      'NomSalleSpectacle': nomSalleSpectacle,
      'idVille': villeSalle.idVille,
      'NbPlaceMaximum': nbPlaceMaximum,
      'PossederSonorisation': possederSonorisation,
      'PossederIngenieur': possederIngenieur,
      'isStructurePublic': isStructurePublic,
    };
  }
}
