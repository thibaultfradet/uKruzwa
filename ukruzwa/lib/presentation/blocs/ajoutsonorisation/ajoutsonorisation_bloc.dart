import 'package:ukruzwa/presentation/blocs/ajoutsonorisation/ajoutsonorisation_event.dart';
import 'package:ukruzwa/presentation/blocs/ajoutsonorisation/ajoutsonorisation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AjoutsonorisationBloc
    extends Bloc<AjoutsonorisationEvent, AjoutsonorisationState> {
  AjoutsonorisationBloc() : super(AjoutsonorisationStateInitial()) {
    //Etat initial

    on<ASEventCreate>((event, emit) async {
      try {
        //Création longue donc on emit un state de chargement en attendant
        emit(ASLoading());

        //Appel de la méthode de création

        //Réussi => on emit le state success
        emit(ASSuccess());
      } catch (e) {
        //Non réussi => on emit le state failure
        emit(ASFailure());
      }
    });
  }
}
