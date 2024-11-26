import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/data/dataSource/remote/firebase.dart';
import 'package:ukruzwa/presentation/blocs/authentification/authentification_bloc.dart';
import 'package:ukruzwa/presentation/blocs/authentification/authentification_event.dart';
import 'package:ukruzwa/presentation/blocs/authentification/authentification_state.dart';
import 'package:ukruzwa/presentation/pages/registration.dart';
import 'package:ukruzwa/presentation/pages/registration_with_google.dart';
import 'package:ukruzwa/presentation/widgets/bouton_custom.dart';
import 'package:ukruzwa/presentation/widgets/input_custom_pl.dart';
import 'package:ukruzwa/presentation/widgets/vertical_margin.dart';
import 'package:ukruzwa/presentation/pages/home.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:ukruzwa/utils/constants/current_user.dart';

class Authentification extends StatefulWidget {
  const Authentification({super.key});

  @override
  State<Authentification> createState() => _AuthentificationState();
}

class _AuthentificationState extends State<Authentification> {
  TextEditingController tecEmailAddress = TextEditingController();
  TextEditingController tecPassword = TextEditingController();
  bool isLoginMode = true;

  @override
  Widget build(BuildContext context) {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    bool _isLoggedIn = false;
    late GoogleSignInAccount _userObj;
    return BlocBuilder<AuthentificationBloc, AuthentificationState>(
      builder: (BuildContext context, state) {
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
                    const VerticalMargin(ratio: 0.02),
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

                    const VerticalMargin(ratio: 0.05),
                    //Bouton connexion sso
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: BoutonCustom(
                        onpressed: () {
                          _googleSignIn.signIn().then(
                            //auth effectuer => .then
                            (userData) {
                              setState(
                                () async {
                                  _isLoggedIn = true;
                                  _userObj = userData!;
                                  //si l'email existe deja en base alors c'est que l'utilisateur se connecte donc on l'envoie vers home
                                  if (await emailAlreadyInDatabase(
                                      userData.email)) {
                                    // on init le user actif
                                    CurrentUser.init();
                                    WidgetsBinding.instance
                                        .addPostFrameCallback(
                                      (_) {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Home()),
                                        );
                                      },
                                    );
                                  }
                                  //Sinon cest qu'il créer un compte donc on le push pour les dernier renseignement avec les data en paramètre
                                  else {
                                    WidgetsBinding.instance
                                        .addPostFrameCallback(
                                      (_) {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                RegistrationWithGoogle(
                                              activeData: userData,
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                              );
                            },
                          ).catchError((e) {});
                        },
                        texteValeur: "Connexion avec google",
                      ),
                    ),

                    const VerticalMargin(ratio: 0.02),
                    //Si le state est une erreur alors on affiche le message d'erreur dans un texte
                    state is AuthFailure
                        ? Center(child: Text(state.error))
                        : const SizedBox()
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
