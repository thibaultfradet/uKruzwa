import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/presentation/blocs/postuler/postuler_bloc.dart';
import 'package:ukruzwa/presentation/blocs/postuler/postuler_event.dart';
import 'package:ukruzwa/presentation/blocs/postuler/postuler_state.dart';
import 'package:ukruzwa/domain/models/Style.dart';
import 'package:ukruzwa/domain/models/Instrument.dart';
import 'package:ukruzwa/domain/models/Ville.dart';
import 'package:ukruzwa/domain/models/Groupe.dart';
import 'package:ukruzwa/presentation/widgets/BoutonCustom.dart';
import 'package:ukruzwa/presentation/widgets/InputCustomPL.dart';
import 'package:ukruzwa/presentation/widgets/VerticalMargin.dart';

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
  TextEditingController tecCodePostal = TextEditingController();
  TextEditingController tecNom = TextEditingController();
  TextEditingController tecPrenom = TextEditingController();

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
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: const Text(
                  "Postuler pour un groupe",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              body: Column(
                children: [
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

                  //Styles
                  InputCustomPL(
                    placeholder: "Style",
                    controllerPL: tecStyle,
                    isObscure: false,
                  ),

                  const VerticalMargin(ratio: 0.05),
                  //Instruments
                  InputCustomPL(
                      placeholder: "Instruments joués",
                      controllerPL: tecInstrument,
                      isObscure: false),

                  const VerticalMargin(ratio: 0.05),

                  BoutonCustom(
                      onpressed: () {
                        BlocProvider.of<PostulerBloc>(context).add(
                          PostulerEventUtilisateurValider(
                            groupeConcerner: widget.groupeConcerner,
                            numTel: tecNumTel.text,
                            nom: tecNom.text,
                            prenom: tecPrenom.text,
                            stylesJoues: stylesSaisis,
                            instrumentsJoues: instrumentsSaisis,
                            ville: tecVille.text,
                            codePostal: tecCodePostal.text,
                          ),
                        );
                      },
                      texteValeur: "Valider")
                  //Bouton validation du formulaire
                ],
              ),
            );
          } else {
            return const Center(child: Text("Une erreur est survenue."));
          }
        },
      ),
    );
  }
}
