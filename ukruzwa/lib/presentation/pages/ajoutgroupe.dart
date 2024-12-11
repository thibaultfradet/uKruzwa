import 'package:flutter/material.dart';
import 'package:ukruzwa/domain/models/groupe.dart';
import 'package:ukruzwa/presentation/blocs/ajoutgroupe/ajoutgroupe_bloc.dart';
import 'package:ukruzwa/presentation/blocs/ajoutgroupe/ajoutgroupe_event.dart';
import 'package:ukruzwa/presentation/blocs/ajoutgroupe/ajoutgroupe_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/presentation/pages/ajoutsonorisation.dart';
import 'package:ukruzwa/presentation/pages/compte.dart';
import 'package:ukruzwa/presentation/widgets/bouton_custom.dart';
import 'package:ukruzwa/presentation/widgets/floating_item.dart';
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
  List<List<String>> villeJouesSelectionnes = [];
  String numeroTelContactSaisie = "";
  TextEditingController tecNomDuGroupe = TextEditingController();
  TextEditingController tecStyleDuGroupe = TextEditingController();
  TextEditingController tecInstrumentDuGroupe = TextEditingController();
  TextEditingController tecNumTelContact = TextEditingController();
  TextEditingController tecNumRemplacementContact = TextEditingController();
  TextEditingController tecNbChanteurs = TextEditingController();

  //partie ville repetition
  TextEditingController tecNomVilleJoues = TextEditingController();
  TextEditingController tecCodePostalJoues = TextEditingController();
  TextEditingController tecAdresseRepetition = TextEditingController();

  //partie ville deja joués
  TextEditingController tecNomVilleRepetition = TextEditingController();
  TextEditingController tecCodePostalVilleRep = TextEditingController();

  bool isSonorisation = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AjoutgroupeBloc()..add(const AjoutgroupeEvent()),
      child: BlocBuilder<AjoutgroupeBloc, AjoutgroupeState>(
        builder: (BuildContext context, state) {
          if (state is AGSuccess) {
            //Si le groupe créer possède une sonorisation alors on l'envoie sur la page d'ajout de sonorisation sinon on l'envoie sur la page de compte
            if (state.isSonorisation) {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => Ajoutsonorisation(
                        groupeConcerner: state.groupeConcerner,
                      ),
                    ),
                  );
                },
              );
            } else {
              WidgetsBinding.instance.addPostFrameCallback(
                (_) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const Compte(),
                    ),
                  );
                },
              );
            }
          }
          if (state is AGFailure) {
            WidgetsBinding.instance.addPostFrameCallback(
              (_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Center(
                      child: Text(
                        'Une erreur est survenue lors de la création, veuillez saisir touts les champs.',
                      ),
                    ),
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
            body: SingleChildScrollView(
              child: Column(
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

                    const VerticalMargin(ratio: 0.03),
                    // Style du groupe
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.96,
                      //ligne entrée utilisateur et bouton de validation
                      child: Column(
                        children: [
                          //Row champs de validation
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                child: InputCustomPL(
                                  controllerPL: tecStyleDuGroupe,
                                  placeholder: "Style joués",
                                  largeur: 0.8,
                                ),
                              ),
                              const Horizontalmargin(ratio: 0.03),
                              // bouton pour ajouter le style saisies dans la liste + vider la saisie
                              SizedBox(
                                child: BoutonCustom(
                                  largeur: 0.12,
                                  onpressed: () {
                                    setState(
                                      () {
                                        if (tecStyleDuGroupe.text
                                            .trim()
                                            .isNotEmpty) {
                                          stylesSelectionnes.add(
                                            tecStyleDuGroupe.text.toLowerCase(),
                                          );
                                        }
                                        tecStyleDuGroupe.text = "";
                                      },
                                    );
                                  },
                                  texteValeur: "+",
                                ),
                              ),
                            ],
                          ),
                          const VerticalMargin(ratio: 0.02),
                          //row list view des styles
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: stylesSelectionnes.length,
                              itemBuilder: (context, index) {
                                return FloatingItem(
                                  valeur: stylesSelectionnes[index],
                                  onPressed: () {
                                    setState(
                                      () {
                                        stylesSelectionnes.removeAt(index);
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const VerticalMargin(ratio: 0.03),

                    // Instrument du groupe
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.96,
                      //ligne entrée utilisateur et bouton de validation
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                child: InputCustomPL(
                                  controllerPL: tecInstrumentDuGroupe,
                                  placeholder:
                                      "Instruments joués(sans chanteurs)",
                                  largeur: 0.8,
                                ),
                              ),
                              const Horizontalmargin(ratio: 0.03),
                              // bouton pour ajouter le style saisies dans la liste + vider la saisie
                              SizedBox(
                                child: BoutonCustom(
                                  largeur: 0.12,
                                  onpressed: () {
                                    setState(
                                      () {
                                        if (tecInstrumentDuGroupe.text
                                            .trim()
                                            .isNotEmpty) {
                                          instrumentSelectionnes.add(
                                            tecInstrumentDuGroupe.text
                                                .toLowerCase(),
                                          );
                                          tecInstrumentDuGroupe.text = "";
                                        }
                                      },
                                    );
                                  },
                                  texteValeur: "+",
                                ),
                              ),
                            ],
                          ),
                          const VerticalMargin(ratio: 0.02),
                          //row list view des instruments
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: instrumentSelectionnes.length,
                              itemBuilder: (context, index) {
                                return FloatingItem(
                                  valeur: instrumentSelectionnes[index],
                                  onPressed: () {
                                    setState(
                                      () {
                                        instrumentSelectionnes.removeAt(index);
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const VerticalMargin(ratio: 0.03),

                    //Nombre de chanteurs
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.96,
                      child: InputCustomPL(
                        placeholder: "Nombre de chanteurs",
                        controllerPL: tecNbChanteurs,
                        isObscure: false,
                        isDouble: true,
                      ),
                    ),

                    const VerticalMargin(ratio: 0.03),

                    //ville de repetition
                    SizedBox(
                      child: Column(
                        children: [
                          const Text("Ville de répetition du groupe"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                child: InputCustomPL(
                                  controllerPL: tecCodePostalVilleRep,
                                  placeholder: "Code postal",
                                  largeur: 0.4,
                                  isDouble: true,
                                ),
                              ),
                              const Horizontalmargin(ratio: 0.07),
                              SizedBox(
                                child: InputCustomPL(
                                  controllerPL: tecNomVilleRepetition,
                                  placeholder: "Ville",
                                  largeur: 0.4,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const VerticalMargin(ratio: 0.03),

                    // Endroits joués
                    SizedBox(
                      //ligne entrée utilisateur et bouton de validation
                      child: Column(
                        children: [
                          const Text("Endroits joués du groupe"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                child: InputCustomPL(
                                  controllerPL: tecCodePostalJoues,
                                  placeholder: "Code postal endroit joué",
                                  largeur: 0.4,
                                  isDouble: true,
                                ),
                              ),
                              SizedBox(
                                child: InputCustomPL(
                                  controllerPL: tecNomVilleJoues,
                                  placeholder: "Ville endroit joué",
                                  largeur: 0.4,
                                ),
                              ),
                              const Horizontalmargin(ratio: 0.03),
                              // bouton pour ajouter le style saisies dans la liste + vider la saisie
                              SizedBox(
                                child: BoutonCustom(
                                  largeur: 0.12,
                                  onpressed: () {
                                    setState(
                                      () {
                                        if (tecCodePostalJoues.text
                                                .trim()
                                                .isNotEmpty &&
                                            tecNomVilleJoues.text
                                                .trim()
                                                .isNotEmpty) {
                                          //Ajout à la liste
                                          villeJouesSelectionnes.add(
                                            [
                                              tecCodePostalJoues.text,
                                              tecNomVilleJoues.text
                                                  .toLowerCase()
                                            ],
                                          );
                                          tecCodePostalJoues.text = "";
                                          tecNomVilleJoues.text = "";
                                        }
                                      },
                                    );
                                  },
                                  texteValeur: "+",
                                ),
                              ),
                            ],
                          ),
                          const VerticalMargin(ratio: 0.02),
                          //row list view des endroits joués
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: villeJouesSelectionnes.length,
                              itemBuilder: (context, index) {
                                return FloatingItem(
                                  valeur:
                                      "${villeJouesSelectionnes[index][0]} ${villeJouesSelectionnes[index][1]}",
                                  onPressed: () {
                                    setState(
                                      () {
                                        villeJouesSelectionnes.removeAt(index);
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const VerticalMargin(ratio: 0.03),

                    // Posséder une sonorisation
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.09,
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

                    const VerticalMargin(ratio: 0.03),
                    // Bouton validation formulaire
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.96,
                      child: BoutonCustom(
                        onpressed: () {
                          //Si l'utilisateur n'a pas valider ses listes alors on lui affiches un message pour le prévenir
                          if (instrumentSelectionnes.isEmpty ||
                              stylesSelectionnes.isEmpty ||
                              villeJouesSelectionnes.isEmpty) {
                            WidgetsBinding.instance.addPostFrameCallback(
                              (_) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Center(
                                      child: Text(
                                        'Les champs avec des boutons "+" n\' ont pas été validés.',
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            BlocProvider.of<AjoutgroupeBloc>(context).add(
                              AGEventCreate(
                                nomGroupe: tecNomDuGroupe.text,
                                instrumentsDuGroupe: instrumentSelectionnes,
                                nombreChanteurs: tecNbChanteurs.text,
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
                          }
                        },
                        texteValeur: "Valider",
                      ),
                    ),
                    const VerticalMargin(ratio: 0.03),
                  ] else if (state is AGLoading) ...[
                    const Center(child: CircularProgressIndicator()),
                  ] else ...[
                    const Text("Une erreur est survenue"),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
