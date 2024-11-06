import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/presentation/blocs/authentification/authentification_bloc.dart';
import 'package:ukruzwa/presentation/blocs/authentification/authentification_event.dart';
import 'package:ukruzwa/presentation/blocs/authentification/authentification_state.dart';
import 'package:ukruzwa/presentation/widgets/BoutonCustom.dart';
import 'package:ukruzwa/presentation/widgets/InputCustomPL.dart';
import 'package:ukruzwa/presentation/widgets/VerticalMargin.dart';
import 'package:ukruzwa/presentation/pages/home.dart';

class Authentification extends StatefulWidget {
  const Authentification({super.key});

  @override
  State<Authentification> createState() => _AuthentificationState();
}

class _AuthentificationState extends State<Authentification> {
  TextEditingController tecEmailAddress = TextEditingController();
  TextEditingController tecPassword = TextEditingController();
  bool isLoginMode = true; // Indique si le mode actuel est connexion

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthentificationBloc, AuthentificationState>(
        builder: (BuildContext context, state) {
      // Rediriger vers la page d'accueil après une connexion réussie => uniquement si il s'agit d'une connexion
      if (state is AuthSuccess && state.isLoginMode) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
          );
        });
      }
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //Intitulé
              Text(
                isLoginMode
                    ? "Je me connecte à mon compte"
                    : "Je créer un compte",
              ),
              //Colonne du formulaire
              Column(
                children: [
                  InputCustomPL(
                    placeholder: "Adresse mail",
                    controllerPL: tecEmailAddress,
                    isObscure: false,
                  ),
                  const VerticalMargin(ratio: 0.02),
                  InputCustomPL(
                    placeholder: "Mot de passe",
                    controllerPL: tecPassword,
                    isObscure: true,
                  ),
                  // Bouton de envoie formulaire
                  BoutonCustom(
                      onpressed: () {
                        if (isLoginMode) {
                          BlocProvider.of<AuthentificationBloc>(context).add(
                            AuthConnect(
                              tecEmailAddress.text,
                              tecPassword.text,
                            ),
                          );
                        } else {
                          BlocProvider.of<AuthentificationBloc>(context).add(
                            AuthCreate(
                              tecEmailAddress.text,
                              tecPassword.text,
                            ),
                          );
                        }
                        ;
                      },
                      texteValeur: isLoginMode
                          ? "Valider ma connexion"
                          : "Valider ma création"),
                ],
              ),
              // Bouton pour changer de mode (connexion/création)
              BoutonCustom(
                onpressed: () {
                  setState(
                    () {
                      isLoginMode = !isLoginMode;
                    },
                  );
                },
                texteValeur:
                    isLoginMode ? "Créer un compte" : "Connexion à mon compte",
              ),
              // Afficher les messages d'erreur si présents
              state is AuthFailure ? const Text("Failed") : const SizedBox(),
            ],
          ),
        ),
      );
    });
  }
}
