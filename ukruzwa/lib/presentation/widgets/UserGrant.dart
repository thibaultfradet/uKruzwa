import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/presentation/blocs/authentification/authentification_bloc.dart';
import 'package:ukruzwa/presentation/blocs/authentification/authentification_event.dart';

class UserGrant extends StatefulWidget {
  const UserGrant({super.key});

  @override
  State<UserGrant> createState() => _UserGrantState();
}

class _UserGrantState extends State<UserGrant> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Création du compte"),
      content: SingleChildScrollView(
        child: Column(
          children: [
            const Text("La création de votre compte s'est bien effectuée."),
            TextButton(
              //State page de connexion initial
              onPressed: () {
                BlocProvider.of<AuthentificationBloc>(context)
                    .add(AuthentificationShowConnect());
              },
              child: const Text("Se connecter"),
            )
          ],
        ),
      ),
    );
  }
}
