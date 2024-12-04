import 'package:flutter/material.dart';
import 'package:ukruzwa/domain/models/groupe.dart';
import 'package:ukruzwa/presentation/blocs/ajoutgroupe/ajoutgroupe_bloc.dart';
import 'package:ukruzwa/presentation/blocs/ajoutgroupe/ajoutgroupe_event.dart';
import 'package:ukruzwa/presentation/blocs/ajoutgroupe/ajoutgroupe_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/presentation/widgets/bouton_custom.dart';
import 'package:ukruzwa/presentation/widgets/horizontal_margin.dart';
import 'package:ukruzwa/presentation/widgets/input_custom_pl.dart';
import 'package:ukruzwa/presentation/widgets/vertical_margin.dart';

class Ajoutgroupe extends StatefulWidget {
  final Groupe? groupeAModifier; // => cas de modification d'un groupe
  const Ajoutgroupe({super.key, this.groupeAModifier});

  @override
  State<Ajoutgroupe> createState() => _AjoutgroupeState();
}

class _AjoutgroupeState extends State<Ajoutgroupe> {
  List<String> instrumentSelectionnes = [];
  List<String> stylesSelectionnes = [];
  List<String> villeJouesSelectionnes = [];
  String numeroTelContactSaisie = "";
  TextEditingController tecNomDuGroupe = TextEditingController();
  TextEditingController tecStyleDuGroupe = TextEditingController();
  TextEditingController tecInstrumentDuGroupe = TextEditingController();
  TextEditingController tecNumTelContact = TextEditingController();
  TextEditingController tecNumRemplacementContact = TextEditingController();
  TextEditingController tecNomVilleRepetition = TextEditingController();
  TextEditingController tecCodePostalVilleRep = TextEditingController();
  TextEditingController tecAdresseRepetition = TextEditingController();
  TextEditingController tecNbChanteurs = TextEditingController();
  TextEditingController tecEndroitsJoues = TextEditingController();
  bool isSonorisation = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AjoutgroupeBloc()..add(const AjoutgroupeEvent()),
      child: BlocBuilder<AjoutgroupeBloc, AjoutgroupeState>(
        builder: (BuildContext context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: const Center(
                child: Text(
                  "Ajouter un groupe",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (state is AjoutgroupeStateInitial) ...[
                  const VerticalMargin(ratio: 0.05),

                  //Nom du groupe
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.96,
                    child: InputCustomPL(
                      placeholder: "Nom du groupe",
                      controllerPL: tecNomDuGroupe,
                      isObscure: false,
                    ),
                  ),

                  const VerticalMargin(ratio: 0.04),
                  // Style du groupe
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.96,
                    //ligne entrée utilisateur et bouton de validation
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: InputCustomPL(
                            controllerPL: tecStyleDuGroupe,
                            placeholder: "Style joués",
                            largeur: 0.8,
                          ),
                        ),
                        const Horizontalmargin(ratio: 0.04),
                        // bouton pour ajouter le style saisies dans la liste + vider la saisie
                        SizedBox(
                          child: BoutonCustom(
                            largeur: 0.12,
                            onpressed: () {
                              setState(
                                () {
                                  stylesSelectionnes.add(
                                    tecStyleDuGroupe.text.toLowerCase(),
                                  );
                                  tecStyleDuGroupe.text = "";
                                },
                              );
                            },
                            texteValeur: "+",
                          ),
                        ),
                      ],
                    ),
                  ),

                  const VerticalMargin(ratio: 0.04),

                  // Instrument du groupe
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.96,
                    //ligne entrée utilisateur et bouton de validation
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: InputCustomPL(
                            controllerPL: tecInstrumentDuGroupe,
                            placeholder: "Instruments joués(sans chanteurs)",
                            largeur: 0.8,
                          ),
                        ),
                        const Horizontalmargin(ratio: 0.04),
                        // bouton pour ajouter le style saisies dans la liste + vider la saisie
                        SizedBox(
                          child: BoutonCustom(
                            largeur: 0.12,
                            onpressed: () {
                              setState(
                                () {
                                  instrumentSelectionnes.add(
                                    tecInstrumentDuGroupe.text.toLowerCase(),
                                  );
                                  tecInstrumentDuGroupe.text = "";
                                },
                              );
                            },
                            texteValeur: "+",
                          ),
                        ),
                      ],
                    ),
                  ),

                  const VerticalMargin(ratio: 0.04),

                  //Nombre de chanteurs
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.96,
                    child: InputCustomPL(
                      placeholder: "Nombre de chanteurs",
                      controllerPL: tecNbChanteurs,
                      isObscure: false,
                    ),
                  ),

                  const VerticalMargin(ratio: 0.04),

                  // Endroits joués
                  SizedBox(
                    //ligne entrée utilisateur et bouton de validation
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: InputCustomPL(
                            controllerPL: tecInstrumentDuGroupe,
                            placeholder: "Endroits joués",
                            largeur: 0.8,
                          ),
                        ),
                        const Horizontalmargin(ratio: 0.04),
                        // bouton pour ajouter le style saisies dans la liste + vider la saisie
                        SizedBox(
                          child: BoutonCustom(
                            largeur: 0.12,
                            onpressed: () {
                              setState(
                                () {
                                  instrumentSelectionnes.add(
                                    tecInstrumentDuGroupe.text.toLowerCase(),
                                  );
                                  tecInstrumentDuGroupe.text = "";
                                },
                              );
                            },
                            texteValeur: "+",
                          ),
                        ),
                      ],
                    ),
                  ),

                  const VerticalMargin(ratio: 0.04),

                  // Posséder une sonorisation
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: Column(
                      children: [
                        const Text("Posséder-vous une sonorisation ?"),
                        Checkbox(
                          value: isSonorisation,
                          onChanged: (bool? value) {
                            setState(
                              () {
                                isSonorisation = value ?? false;
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const VerticalMargin(ratio: 0.04),
                  // Bouton validation formulaire
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.96,
                    child: BoutonCustom(
                      onpressed: () {
                        BlocProvider.of<AjoutgroupeBloc>(context).add(
                          AGEventCreate(
                            nomGroupe: tecNomDuGroupe.text,
                            instrumentsDuGroupe: instrumentSelectionnes,
                            nombreChanteurs: int.parse(tecNbChanteurs.text),
                            numeroRemplacementContact:
                                tecNumRemplacementContact.text,
                            numeroTelContact: tecNumTelContact.text,
                            possederSonorisation: isSonorisation,
                            stylesDuGroupe: stylesSelectionnes,
                            nomVilleRepetition: tecNomVilleRepetition.text,
                            codePostalVilleRepetition:
                                tecCodePostalVilleRep.text,
                            endroitsJouesDuGroupe: villeJouesSelectionnes,
                          ),
                        );
                      },
                      texteValeur: "Valider",
                    ),
                  ),
                ] else if (state is AGLoading) ...[
                  const Center(child: CircularProgressIndicator()),
                ] else ...[
                  const Text("Une erreur est survenue"),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
