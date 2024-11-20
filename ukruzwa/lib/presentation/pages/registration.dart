import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/presentation/blocs/authentification/authentification_bloc.dart';
import 'package:ukruzwa/presentation/blocs/authentification/authentification_event.dart';
import 'package:ukruzwa/presentation/blocs/authentification/authentification_state.dart';
import 'package:ukruzwa/presentation/pages/authentification.dart';
import 'package:ukruzwa/presentation/widgets/bouton_custom.dart';

import 'package:ukruzwa/presentation/widgets/input_custom_pl.dart';
import 'package:ukruzwa/presentation/widgets/vertical_margin.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  TextEditingController tecEmailAddress = TextEditingController();
  TextEditingController tecPassword = TextEditingController();
  TextEditingController tecConfirmPassword = TextEditingController();
  bool isLoginMode = true;

  /* Si le statut est une création on a plus d'entrée utilisateur */
  TextEditingController tecNom = TextEditingController();
  TextEditingController tecPrenom = TextEditingController();
  TextEditingController tecNumTel = TextEditingController();
  TextEditingController tecCodePostal = TextEditingController();
  TextEditingController tecVille = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthentificationBloc, AuthentificationState>(
      builder: (BuildContext context, state) {
        // Rediriger vers la page de connexion quand l'utilisateur créer un compte avec succès
        if (state is AuthSuccess && !state.isLoginMode) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Authentification(),
                ),
              );
            },
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.white,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //Intitulé
                const Text(
                  "Je créer un compte",
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
                    const VerticalMargin(ratio: 0.02),
                    InputCustomPL(
                      placeholder: "Confirmation du mot de passe",
                      controllerPL: tecConfirmPassword,
                      isObscure: true,
                    ),

                    Column(
                      children: [
                        const VerticalMargin(ratio: 0.02),
                        InputCustomPL(
                          placeholder: "Nom",
                          controllerPL: tecNom,
                          isObscure: false,
                        ),
                        const VerticalMargin(ratio: 0.02),
                        InputCustomPL(
                          placeholder: "Prenom",
                          controllerPL: tecPrenom,
                          isObscure: false,
                        ),
                        const VerticalMargin(ratio: 0.02),
                        InputCustomPL(
                          placeholder: "Numéro de téléphone",
                          controllerPL: tecNumTel,
                          isObscure: false,
                        ),
                        const VerticalMargin(ratio: 0.02),
                        InputCustomPL(
                          placeholder: "Code postal",
                          controllerPL: tecCodePostal,
                          isObscure: false,
                        ),
                        const VerticalMargin(ratio: 0.02),
                        InputCustomPL(
                          placeholder: "Ville",
                          controllerPL: tecVille,
                          isObscure: false,
                        )
                      ],
                    ),

                    // Bouton de envoie formulaire
                    BoutonCustom(
                      onpressed: () {
                        BlocProvider.of<AuthentificationBloc>(context).add(
                          AuthCreate(
                            emailAddress: tecEmailAddress.text,
                            password: tecPassword.text,
                            confirmPassword: tecConfirmPassword.text,
                            nom: tecNom.text,
                            prenom: tecPrenom.text,
                            codePostal: tecCodePostal.text,
                            numeroTelephone: tecNumTel.text,
                            ville: tecVille.text,
                          ),
                        );
                      },
                      texteValeur: "Valider ma création",
                    ),
                  ],
                ),
                // Bouton pour changer de mode (connexion/création)
                BoutonCustom(
                  onpressed: () {
                    WidgetsBinding.instance.addPostFrameCallback(
                      (_) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Authentification(),
                          ),
                        );
                      },
                    );
                  },
                  texteValeur: "Connexion à mon compte",
                ),
                // Afficher les messages d'erreur si présents

                state is AuthFailure ? Text(state.error) : const SizedBox()
              ],
            ),
          ),
        );
      },
    );
  }
}
