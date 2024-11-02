import 'package:ukruzwa/presentation/blocs/authentification/authentification_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/presentation/blocs/authentification/authentification_state.dart';
import 'package:ukruzwa/data/dataSource/remote/firebase.dart';

class AuthentificationBloc
    extends Bloc<AuthentificationEvent, AuthentificationState> {
  AuthentificationBloc() : super(const AuthentificationStateInitial()) {
    //State initial
    on<AuthentificationEvent>((event, emit) async {
      emit(const AuthentificationStateInitial());
    });

    // L'utilisateur veux créer un compte et demande l'affichage
    on<AuthentificationShowCreate>((event, emit) async {
      emit(AuthentificationStateCreate());
    });
    // L'utilisateur veux se connecter donc on affiche le formulaire de connexion => initialState
    on<AuthentificationShowConnect>((event, emit) async {
      emit(const AuthentificationStateInitial());
    });

    // L'utilisateur essaye de ce connecter
    on<AuthentificationConnectUser>((event, emit) async {
      /* On essaye de connecter l'utilisateur si non réussi alors =>
        Reussi : State Success
        Non reussi : State failure
      */
      bool isConnect = await connectUser(event.emailAddress, event.password);

      isConnect == true
          ? emit(AuthentificationStateConnectSuccess())
          : emit(AuthentificationStateConnectFailure());
    });

    on<AuthentificationCreateUser>((event, emit) async {
      /* On essaye de créer l'utilisateur si non réussi alors =>
        Reussi : State Success
        Non reussi : State failure
      */

      bool isCreate = await createUser(event.emailAddress, event.password);
      isCreate == true
          ? emit(AuthentificationStateCreateSuccess())
          : emit(AuthentificationStateCreateFailure());
    });
  }
}
