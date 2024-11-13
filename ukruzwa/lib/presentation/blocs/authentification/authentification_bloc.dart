import 'package:ukruzwa/presentation/blocs/authentification/authentification_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/presentation/blocs/authentification/authentification_state.dart';
import 'package:ukruzwa/data/dataSource/remote/firebase.dart';

class AuthentificationBloc
    extends Bloc<AuthentificationEvent, AuthentificationState> {
  AuthentificationBloc() : super(const AuthStateInitial()) {
    //State initial
    on<AuthentificationEvent>((event, emit) async {
      emit(const AuthStateInitial());
    });

    on<AuthConnect>((event, emit) async {
      emit(const AuthLoading());
      final success = await connectUser(event.emailAddress, event.password);
      if (success) {
        emit(const AuthSuccess(isLoginMode: true));
      } else {
        emit(AuthFailure("Invalid email or password"));
      }
    });

    on<AuthCreate>((event, emit) async {
      emit(const AuthLoading());
      //Création dans firebase auth
      bool success = await createUser(event.emailAddress, event.password);
      //On ajoute dans firestore
      success = await createUserInFirestore(event.emailAddress, event.nom,
          event.prenom, event.numeroTelephone, event.codePostal, event.ville);
      if (success) {
        emit(const AuthSuccess(isLoginMode: false));
      } else {
        emit(AuthFailure("Failed to create account"));
      }
    });

    on<ToggleAuthMode>((event, emit) {
      final currentState = state;
      if (currentState is AuthModeToggle) {
        emit(AuthModeToggle(currentState.isLoginMode == false));
      } else {
        //Par défaut on démarre en connexion
        emit(AuthModeToggle(true));
      }
    });
  }
}
