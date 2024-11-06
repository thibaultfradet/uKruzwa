import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/presentation/blocs/postuler/postuler_bloc.dart';
import 'package:ukruzwa/presentation/blocs/postuler/postuler_event.dart';
import 'package:ukruzwa/presentation/blocs/postuler/postuler_state.dart';
import 'package:ukruzwa/domain/models/Style.dart';
import 'package:ukruzwa/domain/models/Instrument.dart';
import 'package:ukruzwa/domain/models/Ville.dart';
import 'package:ukruzwa/domain/models/Groupe.dart';
import 'package:ukruzwa/presentation/widgets/InputCustomPL.dart';

class Postuler extends StatefulWidget {
  final Groupe groupeConcerner;
  const Postuler({super.key, required this.groupeConcerner});

  @override
  State<Postuler> createState() => _PostulerState();
}

class _PostulerState extends State<Postuler> {
  //TextEditingController pour entrées utilisateurs
  TextEditingController tecNumTel = TextEditingController();
  TextEditingController tecStyle = TextEditingController();
  TextEditingController tecVille = TextEditingController();
  TextEditingController tecInstrument = TextEditingController();

  //Liste pour instrument et style
  List<Style> stylesSaisis = [];
  List<Instrument> instrumentsSaisis = [];

  Ville villeTemp =
      Ville(idVille: 0, codePostal: "23200", nomVille: "Aubusson");

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => PostulerBloc()..add(PostulerEvent()),
        child: BlocBuilder<PostulerBloc, PostulerState>(
            builder: (BuildContext context, state) {
          //Page de base => formulaire à remplir pour postuler
          if (state is PostulerStateInitial) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Postuler pour un groupe"),
              ),
              body: Column(children: [
                //Nom du groupe
                Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: Text(
                    widget.groupeConcerner.nomGroupe,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                /* ---- Formulaire ---- */
                //Numéro de téléphone
                InputCustomPL(
                    placeholder: "Numéro de téléphone",
                    controllerPL: tecNumTel,
                    isObscure: false),
                //Styles
                InputCustomPL(
                    placeholder: "Style",
                    controllerPL: tecStyle,
                    isObscure: false),
                //Instruments
                InputCustomPL(
                    placeholder: "Instruments joués",
                    controllerPL: tecInstrument,
                    isObscure: false),

                /* -- Partie formulaire situation géographique -- */
                Container(
                    alignment: Alignment.center,
                    child: const Text(
                      "Situation géographique",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                //Ville
                InputCustomPL(
                    placeholder: "Ville",
                    controllerPL: tecVille,
                    isObscure: false),

                //Bouton validation du formulaire
                TextButton(
                  // On déclenche la tentative de création
                  onPressed: () {
                    BlocProvider.of<PostulerBloc>(context).add(
                        PostulerEventUtilisateurValider(
                            groupeConcerner: widget.groupeConcerner,
                            numTel: tecNumTel.text,
                            stylesJoues: stylesSaisis,
                            instrumentsJoues: instrumentsSaisis,
                            localisation: villeTemp));
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Valider",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ]),
            );
          } else {
            return const Center(child: Text("Une erreur est survenue."));
          }
        }));
  }
}
