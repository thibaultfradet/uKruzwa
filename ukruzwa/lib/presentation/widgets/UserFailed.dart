import 'package:flutter/material.dart';
import 'package:ukruzwa/presentation/blocs/authentification/authentification_state.dart';

class UserFailed extends StatefulWidget {
  final String motif;
  final String erreur;
  final AuthentificationState state;
  const UserFailed(
      {super.key,
      required this.motif,
      required this.erreur,
      required this.state});
  @override
  State<UserFailed> createState() => _UserFailedState();
}

class _UserFailedState extends State<UserFailed> {
  @override
  Widget build(BuildContext context) {
    if (widget.state == AuthentificationStateConnectFailure ||
        widget.state == AuthentificationStateCreateFailure) {
      return AlertDialog(
        title: const Text('Erreur'),
        content: SingleChildScrollView(
          child: Column(children: [
            widget.motif == "connexion"
                ? const Text("La tentative de connexion a echoué.")
                : const Text("La tentative de création de compte à échoué."),

            // A CHANGER AVEC UN SWITCH CASE
            widget.erreur == 'user-not-found'
                ? const Text("L'utilisateur n'existe pas.")
                : const Text("Le mot de passe est incorrect."),

            // bouton pour fermer la pop up
            TextButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
                child: const Text("Fermer")),
          ]),
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
