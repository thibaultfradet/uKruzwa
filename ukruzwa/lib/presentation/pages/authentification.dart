import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/presentation/blocs/authentification/authentification_bloc.dart';
import 'package:ukruzwa/presentation/blocs/authentification/authentification_event.dart';
import 'package:ukruzwa/presentation/blocs/authentification/authentification_state.dart';
import 'package:ukruzwa/presentation/pages/registration.dart';
import 'package:ukruzwa/presentation/widgets/bouton_custom.dart';
import 'package:ukruzwa/presentation/widgets/custom_alert.dart';
import 'package:ukruzwa/presentation/widgets/input_custom_pl.dart';
import 'package:ukruzwa/presentation/widgets/vertical_margin.dart';
import 'package:ukruzwa/presentation/pages/home.dart';

class Authentification extends StatefulWidget {
  const Authentification({super.key});

  @override
  State<Authentification> createState() => _AuthentificationState();
}

class _AuthentificationState extends State<Authentification> {
  TextEditingController tecEmailAddress = TextEditingController();
  TextEditingController tecPassword = TextEditingController();
  bool isLoginMode = true;

  customdialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CustomAlert(
          onPressed: () {
            Navigator.of(context).pop();
          },
          texte: error,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthentificationBloc, AuthentificationState>(
      builder: (BuildContext context, state) {
        if (state is AuthFailure) {
          customdialog(context, state.error);
        }
        // Rediriger vers la page d'accueil après une connexion réussie => uniquement si il s'agit d'une connexion
        if (state is AuthSuccess && state.isLoginMode) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const Home()),
              );
            },
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(backgroundColor: Colors.white),
          body: Center(
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Intitulé
                    const Text("Je me connecte à mon compte"),
                    //Colonne du formulaire
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
                        BlocProvider.of<AuthentificationBloc>(context).add(
                          AuthConnect(
                            tecEmailAddress.text,
                            tecPassword.text,
                          ),
                        );
                      },
                      texteValeur: "Valider ma connexion",
                    ),
                    // Bouton pour changer de mode (connexion/création)
                    BoutonCustom(
                      onpressed: () {
                        WidgetsBinding.instance.addPostFrameCallback(
                          (_) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Registration(),
                              ),
                            );
                          },
                        );
                      },
                      texteValeur: "Créer un compte",
                    ),

                    // Afficher les messages d'erreur si présents
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
