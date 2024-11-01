import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/presentation/blocs/authentification/authentification_bloc.dart';
import 'package:ukruzwa/presentation/blocs/authentification/authentification_event.dart';
import 'package:ukruzwa/presentation/blocs/authentification/authentification_state.dart';
import 'package:ukruzwa/presentation/widgets/InputCustomPL.dart';
import 'package:ukruzwa/presentation/widgets/UserFailed.dart';
import 'package:ukruzwa/presentation/widgets/UserGrant.dart';
import 'package:ukruzwa/presentation/widgets/VerticalMargin.dart';
import 'package:ukruzwa/presentation/pages/home.dart';

class Authentification extends StatefulWidget {
  const Authentification({super.key});

  @override
  State<Authentification> createState() => _AuthentificationState();
}

class _AuthentificationState extends State<Authentification> {
  // TextEditingController pour recuperer les valeurs
  TextEditingController tecEmailAddress = TextEditingController();
  TextEditingController tecPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthentificationBloc, AuthentificationState>(
        builder: (BuildContext context, state) {
      // Si de base le state est la connexion reussi on envoie l'utilisateur vers la vue globale
      if (state is AuthentificationStateConnectSuccess) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Home()));
        });
      }
      // Si le state est la création réussi affiche une pop-up à l'utilisateur pour lui proposer de se connecter avec emit state sur initiamState connexion
      else if (state is AuthentificationStateCreateSuccess) {
        return UserGrant();
      }

      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(state is AuthentificationStateInitial ||
                      state is AuthentificationStateConnectFailure ||
                      state is AuthentificationStateConnectSuccess
                  ? "Je me connecte à mon compte"
                  : "Je créer un compte"),
              Column(
                children: [
                  InputCustomPL(
                      placeholder: "Adresse mail",
                      controllerPL: tecEmailAddress,
                      IsObscure: false),
                  VerticalMargin(ratio: 0.02),
                  InputCustomPL(
                      placeholder: "Mot de passe",
                      controllerPL: tecPassword,
                      IsObscure: true),
                  TextButton(
                    onPressed: () {
                      if (state is AuthentificationStateInitial) {
                        BlocProvider.of<AuthentificationBloc>(context).add(
                            AuthentificationConnectUser(
                                tecEmailAddress.text, tecPassword.text));
                      } else {
                        BlocProvider.of<AuthentificationBloc>(context).add(
                            AuthentificationCreateUser(
                                tecEmailAddress.text, tecPassword.text));
                      }
                    },
                    child: Text(state is AuthentificationStateInitial ||
                            state is AuthentificationStateConnectFailure ||
                            state is AuthentificationStateConnectSuccess
                        ? "Valider ma connexion"
                        : "Valider ma création"),
                  )
                ],
              ),
              Container(
                child: TextButton(
                  onPressed: () {
                    BlocProvider.of<AuthentificationBloc>(context).add(
                      state is AuthentificationStateInitial ||
                              state is AuthentificationStateConnectFailure ||
                              state is AuthentificationStateConnectSuccess
                          ? AuthentificationShowConnect()
                          : AuthentificationShowCreate(),
                    );
                  },
                  child: Text(state is AuthentificationStateInitial ||
                          state is AuthentificationStateConnectFailure ||
                          state is AuthentificationStateConnectSuccess
                      ? "Connexion à mon compte"
                      : "Créer un compte"),
                ),
              ),
              Column(children: [
                if (state is AuthentificationStateConnectFailure ||
                    state is AuthentificationStateCreateFailure)
                  UserFailed(
                      motif: state is AuthentificationStateConnectFailure
                          ? "connexion"
                          : "creation",
                      erreur: "",
                      state: state),
              ])
            ],
          ),
        ),
      );
    });
  }
}
