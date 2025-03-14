import 'package:ukruzwa/data/dataSource/remote/groupe_firebase.dart';
import 'package:ukruzwa/data/dataSource/remote/sonorisation_firebase.dart';
import 'package:ukruzwa/domain/models/sonorisation.dart';
import 'package:ukruzwa/domain/models/groupe.dart';
import 'package:ukruzwa/presentation/blocs/ajoutsonorisation/ajoutsonorisation_event.dart';
import 'package:ukruzwa/presentation/blocs/ajoutsonorisation/ajoutsonorisation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AjoutsonorisationBloc
    extends Bloc<AjoutsonorisationEvent, AjoutsonorisationState> {
  AjoutsonorisationBloc() : super(AjoutsonorisationStateInitial()) {
    //Etat initial

    on<ASEventCreate>((event, emit) async {
      // TODO : Vérifier si la sonorisation n'existe pas deja en base si elle existe on récupère l'identifiant et on met à jour
      try {
        //Création longue donc on emit un state de chargement en attendant
        emit(ASLoading());

        //on créer un objet de sonorisation
        Sonorisation sonorisationTemp = Sonorisation(
          "",
          event.modeleSono,
          event.descriptionSono,
          double.parse(event.prixLocationSono),
          double.parse(event.puissanceSono),
        );
        //Ajout en base de l'objet + récupération de l'identifiant
        String idSonorisation = await createSonorisation(sonorisationTemp);

        //Modification en bdd avec l'identifiant de la sonorisation
        Groupe groupeTemp = await retrieveGroupe(event.idGroupeConcerner);
        groupeTemp.sonorisationDuGroupe = sonorisationTemp;
        // TODO: Modifier pour rajouter les elements du formulaire comme ingeSon et + si il est bien égale à true => passer en paramètre de la fonction
        updateGroupeSonorisation(groupeTemp.idGroupe!, idSonorisation);
        //Réussi => on emit le state success
        emit(ASSuccess());
      } catch (e) {
        //Non réussi => on emit le state failure
        emit(ASFailure());
      }
    });
  }
}
