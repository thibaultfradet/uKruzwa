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

      //Vérifications entrées utilisateurs
      if (event.password.trim().isEmpty || event.emailAddress.trim().isEmpty) {
        emit(AuthFailure("Informations vides"));
      }

      try {
        final success = await connectUser(event.emailAddress, event.password);
        if (success) {
          emit(const AuthSuccess(isLoginMode: true));
        } else {
          emit(AuthFailure("Invalid email or password"));
        }
      } catch (e) {
        emit(AuthFailure("Erreur catch"));
      }
    });

    on<AuthCreate>((event, emit) async {
      emit(const AuthLoading());

      RegExp emailRegex =
          RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
      RegExp passwordRegex =
          RegExp(r"^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$");

      // Vérification des données saisies
      // Entrée utilisateur vide
      if (event.codePostal.trim().isEmpty ||
          event.confirmPassword.trim().isEmpty ||
          event.password.trim().isEmpty ||
          event.emailAddress.trim().isEmpty ||
          event.nom.trim().isEmpty ||
          event.prenom.trim().isEmpty ||
          event.numeroTelephone.trim().isEmpty ||
          event.ville.trim().isEmpty) {
        emit(AuthFailure("Informations vides"));
        return; // Sortie immédiate du bloc
      }

      // password et confirmPassword non identiques
      if (event.password != event.confirmPassword) {
        emit(AuthFailure("Mot de passes non identiques"));
        return; // Sortie immédiate du bloc
      }

      // Regex : adresse mail
      if (!emailRegex.hasMatch(event.emailAddress)) {
        emit(AuthFailure("Regex mail invalide"));
        return; // Sortie immédiate du bloc
      }

      // Regex : mot de passe
      if (!passwordRegex.hasMatch(event.password)) {
        emit(AuthFailure("Regex pass invalide"));
        return; // Sortie immédiate du bloc
      }

      try {
        // Création dans Firebase Auth
        bool success = await createUser(event.emailAddress, event.password);

        // On ajoute dans Firestore
        success = await createUserInFirestore(event.emailAddress, event.nom,
            event.prenom, event.numeroTelephone, event.codePostal, event.ville);

        if (success) {
          emit(const AuthSuccess(isLoginMode: false));
        } else {
          emit(AuthFailure("Failed to create account"));
        }
      } catch (e) {
        emit(AuthFailure("Erreur catch"));
      }
    });
  }
}
