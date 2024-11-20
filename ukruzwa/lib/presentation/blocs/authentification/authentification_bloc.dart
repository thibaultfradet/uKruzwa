import 'package:ukruzwa/domain/models/personnne.dart';
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
          emit(AuthFailure("Adresse mail ou mot de passe invalide."));
        }
      } catch (e) {
        emit(AuthFailure("Une erreur est survenue"));
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
        emit(AuthFailure("Informations vides."));
        return; // Sortie immédiate du bloc
      }

      // password et confirmPassword non identiques
      if (event.password != event.confirmPassword) {
        emit(AuthFailure("Mot de passes non identiques."));
        return; // Sortie immédiate du bloc
      }

      // Regex : adresse mail
      if (!emailRegex.hasMatch(event.emailAddress)) {
        emit(AuthFailure("Mail saisie invalide."));
        return; // Sortie immédiate du bloc
      }

      // Regex : mot de passe
      if (!passwordRegex.hasMatch(event.password)) {
        emit(AuthFailure(
            "Mot de passe saisie invalide.\r\n • Au moins 8 caractères \r\n • Au moins 1 majuscule/minuscule \r\n • Au moins 1 chiffre \r\n • Au moins 1 caractère spécial"));
        return; // Sortie immédiate du bloc
      }

      try {
        // Création dans Firebase Auth
        bool success = await createUser(event.emailAddress, event.password);

        // On ajoute dans Firestore
        success = await Personne.empty().createUserInFirestore(
            event.emailAddress,
            event.nom,
            event.prenom,
            event.numeroTelephone,
            event.codePostal,
            event.ville);

        if (success) {
          emit(const AuthSuccess(isLoginMode: false));
        } else {
          emit(AuthFailure("Création du compte non réussi"));
        }
      } catch (e) {
        emit(AuthFailure("Une erreur est survenue."));
      }
    });
  }
}
