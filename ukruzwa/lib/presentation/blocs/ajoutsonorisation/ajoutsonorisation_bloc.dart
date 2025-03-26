import 'package:ukruzwa/data/dataSource/remote/groupe_firebase.dart';
import 'package:ukruzwa/data/dataSource/remote/sonorisation_firebase.dart';
import 'package:ukruzwa/domain/models/groupe.dart';
import 'package:ukruzwa/presentation/blocs/ajoutsonorisation/ajoutsonorisation_event.dart';
import 'package:ukruzwa/presentation/blocs/ajoutsonorisation/ajoutsonorisation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AjoutsonorisationBloc
    extends Bloc<AjoutsonorisationEvent, AjoutsonorisationState> {
  AjoutsonorisationBloc() : super(AjoutsonorisationStateInitial()) {
    //L'utilisateur veux détacher la sonorisation de son groupe
    on<ASEventRemove>((event, emit) async {
      bool success = await removeSonoFromGroupe(
          event.idSonorisation, event.groupeConcerner);
      if (success) {
        emit(ASSuccess());
      } else {
        emit(ASFailure(
            "Une erreur est survenue lors de la suppression de la sonorisation avec le groupe"));
      }
    });

    //L'utilisateur modifie la sonorisation de son groupe
    on<ASEventEdit>((event, emit) async {
      try {
        emit(ASLoading());
        bool success = await createOrEditSonorisation(
            event.modeleSono,
            event.descriptionSono,
            double.parse(event.prixLocationSono),
            double.parse(event.puissanceSono),
            event.groupeConcerner);

        if (success) {
          //On met maintenant a jour le groupe si un inge accompagne le groupe
          if (event.ingeAccompagne) {
            Groupe groupeAddInge = event.groupeConcerner;
            groupeAddInge.ingeSon = true;
            groupeAddInge.prixInge = event.prixServiceInge;
            groupeAddInge.ingePro = event.ingeEstPro;

            updateGroupe(groupeAddInge);
          }
          emit(ASSuccess());
        } else {
          emit(ASFailure(
              "Une erreur est survenue lors de la tentative de modification de la sonorisation. Veuillez saisir tous les champs."));
        }
      } catch (e) {
        emit(ASFailure(
            "Une erreur est survenue lors de la tentative de modification de la sonorisation. Veuillez saisir tous les champs."));
      }
    });
    //Etat initial
    on<AjoutsonorisationEvent>((event, emit) async {
      emit(AjoutsonorisationStateInitial());
    });

    //L'utilisateur créer une sonorisation pour son groupe
    on<ASEventCreate>((event, emit) async {
      try {
        //Création longue donc on emit un state de chargement en attendant
        emit(ASLoading());

        //on créer un objet de sonorisation
        bool success = await createOrEditSonorisation(
            event.modeleSono,
            event.descriptionSono,
            double.parse(event.prixLocationSono),
            double.parse(event.puissanceSono),
            event.groupeConcerner);

        if (success) {
          //On met maintenant a jour le groupe si un inge accompagne le groupe
          if (event.ingeAccompagne) {
            Groupe groupeAddInge = event.groupeConcerner;
            groupeAddInge.ingeSon = true;
            groupeAddInge.prixInge = event.prixServiceInge;
            groupeAddInge.ingePro = event.ingeEstPro;

            updateGroupe(groupeAddInge);
          }

          emit(ASSuccess());
        } else {
          emit(ASFailure(
              "Une erreur est survenue lors de la tentative de création de la sonorisation. Veuillez saisir tous les champs."));
        }
      } catch (e) {
        //Non réussi => on emit le state failure
        emit(ASFailure(
            "Une erreur est survenue lors de la tentative de création de la sonorisation. Veuillez saisir tous les champs."));
      }
    });
  }
}
