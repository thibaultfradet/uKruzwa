import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/presentation/blocs/postuler/postuler_bloc.dart';
import 'package:ukruzwa/presentation/blocs/postuler/postuler_event.dart';
import 'package:ukruzwa/presentation/blocs/postuler/postuler_state.dart';

import 'package:ukruzwa/domain/models/Groupe.dart';
import 'package:ukruzwa/presentation/widgets/BoutonCustom.dart';
import 'package:ukruzwa/presentation/widgets/FloatingItem.dart';
import 'package:ukruzwa/presentation/widgets/HorizontalMargin.dart';
import 'package:ukruzwa/presentation/widgets/VerticalMargin.dart';

class Postuler extends StatefulWidget {
  final Groupe groupeConcerner;
  const Postuler({super.key, required this.groupeConcerner});

  @override
  State<Postuler> createState() => _PostulerState();
}

class _PostulerState extends State<Postuler> {
  //TextEditingController pour entrées utilisateurs
  TextEditingController tecStyle = TextEditingController();
  TextEditingController tecInstrument = TextEditingController();

  //Liste pour instrument et style
  List<String> stylesSaisis = [];
  List<String> instrumentsSaisis = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PostulerBloc()..add(PostulerEvent()),
      child: BlocBuilder<PostulerBloc, PostulerState>(
        builder: (BuildContext context, state) {
          //Page de base => formulaire à remplir pour postuler
          if (state is PostulerStateInitial) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
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
                  const VerticalMargin(ratio: 0.05),
                  Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Autocomplete<String>(
                          initialValue: const TextEditingValue(text: ""),
                          optionsBuilder:
                              (TextEditingValue textEditingValue) async {
                            if (textEditingValue.text.isEmpty) {
                              return [];
                            }

                            return state.styleDisponible
                                .where((style) => style.nomStyle
                                    .toLowerCase()
                                    .trim()
                                    .contains(
                                        textEditingValue.text.toLowerCase()))
                                .map((element) => element.nomStyle);
                          },
                          //L'utilisateur sélectionne donc on ajoute à la liste avec la valeur selectionner
                          onSelected: (suggestion) {
                            setState(
                              () {
                                stylesSaisis.add(suggestion);
                              },
                            );
                          },
                        ),
                      ),
                      //FloatingItem
                      Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: stylesSaisis.length,
                          itemBuilder: (context, index) {
                            //Floating item avec la valeur i et au clique on supprime de la liste
                            return Row(
                              children: [
                                FloatingItem(
                                  valeur: stylesSaisis[index],
                                  onPressed: () {
                                    setState(() {
                                      stylesSaisis.removeAt(index);
                                    });
                                  },
                                ),
                                const Horizontalmargin(ratio: 0.05)
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const VerticalMargin(ratio: 0.05),
                  //Instruments
                  Column(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.06,
                        child: Autocomplete<String>(
                          initialValue: const TextEditingValue(text: ""),
                          optionsBuilder:
                              (TextEditingValue textEditingValue) async {
                            if (textEditingValue.text.isEmpty) {
                              return [];
                            }

                            return state.instrumentDisponible
                                .where((instrument) => instrument.nomInstrument
                                    .toLowerCase()
                                    .trim()
                                    .contains(
                                        textEditingValue.text.toLowerCase()))
                                .map((element) => element.nomInstrument);
                          },
                          //L'utilisateur sélectionne donc on ajoute à la liste avec la valeur selectionner
                          onSelected: (suggestion) {
                            setState(
                              () {
                                instrumentsSaisis.add(suggestion);
                              },
                            );
                          },
                        ),
                      ),
                      //FloatingItem
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: instrumentsSaisis.length,
                          itemBuilder: (context, index) {
                            //Floating item avec la valeur i et au clique on supprime de la liste
                            return FloatingItem(
                              valeur: instrumentsSaisis[index],
                              onPressed: () {
                                instrumentsSaisis.removeAt(index);
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const VerticalMargin(ratio: 0.05),

                  //Bouton validation du formulaire
                  BoutonCustom(
                    onpressed: () {
                      BlocProvider.of<PostulerBloc>(context).add(
                        PostulerEventUtilisateurValider(
                          groupeConcerner: widget.groupeConcerner,
                          stylesJoues: stylesSaisis,
                          instrumentsJoues: instrumentsSaisis,
                        ),
                      );
                    },
                    texteValeur: "Valider",
                  )
                ],
              ),
            );
          } else {
            return const Center(
              child: Text("Une erreur est survenue."),
            );
          }
        },
      ),
    );
  }
}
