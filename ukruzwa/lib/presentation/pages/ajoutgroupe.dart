import 'package:flutter/material.dart';
import 'package:ukruzwa/domain/models/groupe.dart';
import 'package:ukruzwa/presentation/blocs/ajoutgroupe/ajoutgroupe_bloc.dart';
import 'package:ukruzwa/presentation/blocs/ajoutgroupe/ajoutgroupe_event.dart';
import 'package:ukruzwa/presentation/blocs/ajoutgroupe/ajoutgroupe_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/presentation/widgets/bouton_custom.dart';
import 'package:ukruzwa/presentation/widgets/input_custom_pl.dart';

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
              title: const Text("Ajouter un groupe"),
            ),
            body: Column(
              children: [
                if (state is AjoutgroupeStateInitial) ...[
                  // Nom du groupe
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: InputCustomPL(
                      placeholder: "Nom du groupe",
                      controllerPL: tecNomDuGroupe,
                      isObscure: false,
                    ),
                  ), // Style du groupe => AutoComplete
                  Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<String>.empty();
                      }
                      return state.styleDisponible
                          .map((style) => style.nomStyle)
                          .where((String style) {
                        return style
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase());
                      }).toList();
                    },
                    onSelected: (String styleSaisie) {
                      setState(() {
                        stylesSelectionnes.add(styleSaisie);
                      });
                    },
                    fieldViewBuilder: (
                      BuildContext context,
                      TextEditingController tecStyle,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted,
                    ) {
                      return InputCustomPL(
                        placeholder: "Style du groupe",
                        controllerPL: tecStyle,
                        isObscure: false,
                      );
                    },
                  ), // Instrument du groupe
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: InputCustomPL(
                      placeholder: "Instrument du groupe (sans chanteurs)",
                      controllerPL: tecInstrumentDuGroupe,
                      isObscure: false,
                    ),
                  ), // Nombre de chanteurs
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: InputCustomPL(
                      placeholder: "Nombre de chanteurs",
                      controllerPL: tecNbChanteurs,
                      isObscure: false,
                    ),
                  ), // Endroits joués
                  Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<String>.empty();
                      }
                      return state.villeDisponible
                          .map((ville) => ville.nomVille)
                          .where((String ville) {
                        return ville
                            .toLowerCase()
                            .contains(textEditingValue.text.toLowerCase());
                      }).toList();
                    },
                    onSelected: (String endroits) {
                      setState(() {
                        villeJouesSelectionnes.add(endroits);
                      });
                    },
                    fieldViewBuilder: (
                      BuildContext context,
                      TextEditingController tecVille,
                      FocusNode focusNode,
                      VoidCallback onFieldSubmitted,
                    ) {
                      return InputCustomPL(
                        placeholder: "Endroits deja joué(s)",
                        controllerPL: tecVille,
                        isObscure: false,
                      );
                    },
                  ), // Posséder une sonorisation
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Column(
                      children: [
                        const Text("Posséder-vous une sonorisation ?"),
                        Checkbox(
                          value: isSonorisation,
                          onChanged: (bool? value) {
                            setState(() {
                              isSonorisation = value ?? false;
                            });
                          },
                        ),
                      ],
                    ),
                  ), // Bouton validation formulaire
                  BoutonCustom(
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
                          codePostalVilleRepetition: tecCodePostalVilleRep.text,
                          endroitsJouesDuGroupe: villeJouesSelectionnes,
                        ),
                      );
                    },
                    texteValeur: "Valider",
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
