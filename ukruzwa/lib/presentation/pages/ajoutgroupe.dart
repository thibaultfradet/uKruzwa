import 'package:flutter/material.dart';
import 'package:ukruzwa/presentation/blocs/ajoutgroupe/ajoutgroupe_bloc.dart';
import 'package:ukruzwa/presentation/blocs/ajoutgroupe/ajoutgroupe_event.dart';
import 'package:ukruzwa/presentation/blocs/ajoutgroupe/ajoutgroupe_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/presentation/widgets/BoutonCustom.dart';
import 'package:ukruzwa/presentation/widgets/InputCustomPL.dart';

class Ajoutgroupe extends StatefulWidget {
  const Ajoutgroupe({super.key});

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
  TextEditingController tecVilleRepetition = TextEditingController();
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
          //Page de base => formulaire à remplir pour Ajoutgroupe

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              title: const Text("Ajouter un groupe"),
            ),
            body: state is AjoutgroupeStateInitial
                ? Column(
                    children: [
                      //nom du groupe
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: InputCustomPL(
                            placeholder: "Nom du groupe",
                            controllerPL: tecNomDuGroupe,
                            isObscure: false),
                      ),
                      //style du groupe => autoComplete
                      Autocomplete<String>(
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          //Suggestion d'auto completion
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<String>.empty();
                          }
                          return state.styleDisponible
                              .map((style) => style.nomStyle)
                              .where(
                            (String style) {
                              return style.toLowerCase().contains(
                                  textEditingValue.text.toLowerCase());
                            },
                          ).toList();
                        },
                        // A la selection on ajoute l'objet selectionner à la liste correspondante
                        onSelected: (String styleSaisie) {
                          setState(() {
                            stylesSelectionnes.add(styleSaisie);
                          });
                        },
                        //Apparence
                        fieldViewBuilder: (
                          BuildContext context,
                          TextEditingController tecStyle,
                          FocusNode focusNode,
                          VoidCallback onFieldSubmitted,
                        ) {
                          //on se sert du inputCustomPL comme le fieldViewBuilder permet d'instancier un TEC
                          return InputCustomPL(
                            placeholder: "Style du groupe",
                            controllerPL: tecStyle,
                            isObscure: false,
                          );
                        },
                      ),

                      /* */
                      Autocomplete<String>(
                        initialValue: const TextEditingValue(text: ""),
                        optionsBuilder: (TextEditingValue value) {
                          if (value.text.isEmpty) {
                            return [];
                          }
                          /*return state.styleDisponible.where(
                            (style) => style.nomStyle
                                .toLowerCase()
                                .trim()
                                .contains(value.text.toLowerCase().trim()),
                          );
                        }, */
                          return [];
                        },
                        //L'utilisateur séle  ctionne donc on remplis la textBox avec la valeur selectionner
                        onSelected: (suggestion) {
                          setState(
                            () {
                              stylesSelectionnes.add(suggestion);
                            },
                          );
                        },
                      ),
                      /**/
                      //numero tel contact => auto complete
                      Autocomplete<String>(
                        //Suggestion d'auto completion
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<String>.empty();
                          }
                          return state.contactDisponible
                              .map((contact) => contact.numeroTelephone)
                              .where(
                            (String numero) {
                              return numero.toLowerCase().contains(
                                  textEditingValue.text.toLowerCase());
                            },
                          ).toList();
                        },
                        // A la selection on ajoute l'objet selectionner à sa variable attitrée
                        onSelected: (String numSaisie) {
                          setState(() {
                            numeroTelContactSaisie = numSaisie;
                          });
                        },
                        //Apparence
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController tecNumeroTelContact,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted) {
                          //on se sert du inputCustomPL comme le fieldViewBuilder permet d'instancier un TEC
                          return InputCustomPL(
                            placeholder: "Numéro téléphone du contact",
                            controllerPL: tecNumeroTelContact,
                            isObscure: false,
                          );
                        },
                      ),
                      //Instruments joués par le groupe => auto complete
                      Autocomplete<String>(
                        //Suggestion d'auto completion
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<String>.empty();
                          }
                          return state.instrumentDisponible
                              .map((instrument) => instrument.nomInstrument)
                              .where(
                            (String instrument) {
                              return instrument.toLowerCase().contains(
                                  textEditingValue.text.toLowerCase());
                            },
                          ).toList();
                        },
                        // A la selection on ajoute l'objet selectionner à sa variable attitrée
                        onSelected: (String instrumentSaisie) {
                          setState(() {
                            instrumentSelectionnes.add(instrumentSaisie);
                          });
                        },
                        //Apparence
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController tecInstrument,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted) {
                          //on se sert du inputCustomPL comme le fieldViewBuilder permet d'instancier un TEC
                          return InputCustomPL(
                            placeholder: "Instrument du groupe (sans chanteur)",
                            controllerPL: tecInstrument,
                            isObscure: false,
                          );
                        },
                      ),
                      //Nombre chanteurs => calcul instruments + nb chanteurs
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: InputCustomPL(
                            placeholder: "Nombre de chanteurs",
                            controllerPL: tecNbChanteurs,
                            isObscure: false),
                      ),
                      //Endroits joués
                      Autocomplete<String>(
                        //Suggestion d'auto completion
                        optionsBuilder: (TextEditingValue textEditingValue) {
                          if (textEditingValue.text.isEmpty) {
                            return const Iterable<String>.empty();
                          }
                          return state.villeDisponible
                              .map((ville) => ville.nomVille)
                              .where(
                            (String ville) {
                              return ville.toLowerCase().contains(
                                  textEditingValue.text.toLowerCase());
                            },
                          ).toList();
                        },
                        // A la selection on ajoute l'objet selectionner à sa variable attitrée
                        onSelected: (String endroits) {
                          setState(() {
                            villeJouesSelectionnes.add(endroits);
                          });
                        },
                        //Apparence
                        fieldViewBuilder: (
                          BuildContext context,
                          TextEditingController tecVille,
                          FocusNode focusNode,
                          VoidCallback onFieldSubmitted,
                        ) {
                          //on se sert du inputCustomPL comme le fieldViewBuilder permet d'instancier un TEC
                          return InputCustomPL(
                            placeholder: "Endroits deja joué(s)",
                            controllerPL: tecVille,
                            isObscure: false,
                          );
                        },
                      ),
                      //Posseder une sonorisation
                      Container(
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: Column(
                          children: [
                            const Text("Posséder-vous une sonorisation ?"),
                            Checkbox(
                                value: isSonorisation,
                                onChanged: (bool? value) {
                                  setState(() {
                                    //False si null
                                    isSonorisation = value ?? false;
                                  });
                                }),
                          ],
                        ),
                      ),
                      //Bouton validation formulaire => à l'appuie on declenche le bloc de création de groupe
                      BoutonCustom(
                          onpressed: () {
                            //compléter event avec les valeur textEditing + valeur normal (surement un rajout après bloc de suggestion plutot que du simple TextFormField)
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
                                villeRepetitionDuGroupe:
                                    tecVilleRepetition.text,
                                endroitsJouesDuGroupe: villeJouesSelectionnes,
                              ),
                            );
                          },
                          texteValeur: "Valider"),
                    ],
                  )
                : const SizedBox(),
          );
        },
      ),
    );
  }
}
