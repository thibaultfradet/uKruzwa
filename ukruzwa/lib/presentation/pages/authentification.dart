import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/data/dataSource/remote/firebase.dart';
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
    return BlocBuilder<AuthentificationBloc,AuthentificationState>(
      builder: (BuildContext context, state) {
        // Si de base le state est la connexion reussi on envoie l'utilisateur vers la vue globale
        if (state is AuthentificationStateConnectSuccess)
        {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) { 
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Home())
              );
            }
          );
        }
        // Si le state est la création réussi affiche une pop-up à l'utilisateur pour lui proposer de se connecter avec emit state sur initiamState connexion
        else if (state is AuthentificationStateCreateSuccess)
        {
          return UserGrant();          
        }

        return Scaffold(
          appBar: AppBar(),
          // par défaut formulaire de connexion à un compte
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                state is AuthentificationStateInitial ? Text("Je me connecte à mon compte") : Text("Je créer un compte"),
                // Colonne de connexion à un compte
                Column(
                  children: [
                    
                    InputCustomPL(placeholder: "Adresse mail",controllerPL: tecEmailAddress, IsObscure: false),
                    VerticalMargin(ratio: 0.02),
                    InputCustomPL(placeholder: "Mot de passe", controllerPL: tecPassword, IsObscure: true),
                    
                    TextButton(
                      // en fonction du state on appel la connexion ou la création d'un compte
                      onPressed: (){
                        state is AuthentificationStateInitial ? 
                        BlocProvider.of<AuthentificationBloc>(context).add(AuthentificationConnectUser(tecEmailAddress.text,tecPassword.text)) :
                        BlocProvider.of<AuthentificationBloc>(context).add(AuthentificationCreateUser(tecEmailAddress.text,tecPassword.text));
                      },
                      child:
                      state is AuthentificationStateInitial ? Text("Valider ma connexion") : Text("Valider ma création"),
                    )
                  ],
                ),
            
                // container pour bouton changer de mode => connexion/creation d'un compte
                Container(
                  child: 
                  // Si l'utilisateur clique on affiche la page de connexion à un compte donc le state initial
                  TextButton(
                    onPressed: () {
                      state is AuthentificationStateInitial ? 
                      BlocProvider.of<AuthentificationBloc>(context).add(AuthentificationShowCreate()) : 
                      BlocProvider.of<AuthentificationBloc>(context).add(AuthentificationShowConnect());
                    },
                    child: 
                    state is AuthentificationStateInitial ? Text("Créer un compte") : Text("Connexion à mon compte"),
                  )
                ),

                // On appel le widget UserFailed si le state mis en paramètre est bien un failed il retournera une pop-up pour informer l'utilisateur
                Column(
                  children: [
                    Container(
                      child: 
                        state is AuthentificationStateConnectFailure ? UserFailed(motif: "connexion", erreur: "", state: state) : UserFailed(motif: "creation", erreur: "", state: state)
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }
    );
  }
}
