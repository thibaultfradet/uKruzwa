import 'package:ukruzwa/data/dataSource/remote/sonorisation_firebase.dart';
import 'package:ukruzwa/presentation/blocs/ajoutsonorisation/ajoutsonorisation_event.dart';
import 'package:ukruzwa/presentation/blocs/ajoutsonorisation/ajoutsonorisation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AjoutsonorisationBloc
    extends Bloc<AjoutsonorisationEvent, AjoutsonorisationState> {
  AjoutsonorisationBloc() : super(AjoutsonorisationStateInitial()) {
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
          emit(ASSuccess());
        } else {
          emit(ASFailure());
        }
      } catch (e) {
        emit(ASFailure());
      }
    });
    //Etat initial
    on<AjoutsonorisationEvent>((event, emit) async {
      emit(AjoutsonorisationStateInitial());
    });
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
          emit(ASSuccess());
        } else {
          emit(ASFailure());
        }
      } catch (e) {
        //Non réussi => on emit le state failure
        emit(ASFailure());
      }
    });
  }
}
