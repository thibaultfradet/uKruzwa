import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/presentation/blocs/ajoutsallesp/ajout_sallesp_bloc.dart';
import 'package:ukruzwa/presentation/blocs/ajoutsallesp/ajout_sallesp_event.dart';
import 'package:ukruzwa/presentation/blocs/ajoutsallesp/ajout_sallesp_state.dart';
import 'package:ukruzwa/presentation/widgets/bouton_custom.dart';
import 'package:ukruzwa/presentation/widgets/input_custom_pl.dart';
import 'package:ukruzwa/presentation/widgets/vertical_margin.dart';

class Ajoutsallesp extends StatefulWidget {
  const Ajoutsallesp({super.key});

  @override
  State<Ajoutsallesp> createState() => _AjoutsallespState();
}

class _AjoutsallespState extends State<Ajoutsallesp> {
  TextEditingController tecNomSalle = TextEditingController();
  TextEditingController tecCodePostal = TextEditingController();
  TextEditingController tecAdresse = TextEditingController();
  TextEditingController tecVille = TextEditingController();
  TextEditingController tecNbPlaceMax = TextEditingController();
  bool isSonorisation = false;
  bool isIngenieur = false;
  bool estPublique = false;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AjoutSalleSpBloc()..add(const AjoutSalleSpEvent()),
      child: BlocBuilder<AjoutSalleSpBloc, AjoutSalleSpState>(
        builder: (BuildContext context, state) {
          //Page de base => touts les groupes du compte concerner
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: const Text("Ajouter une salle de spectacle"),
            ),
            body: Stack(
              children: [
                if (state is ASPLoading) const CircularProgressIndicator(),
                Center(
                  child: Column(
                    children: [
                      const VerticalMargin(ratio: 0.05),
                      InputCustomPL(
                        controllerPL: tecNomSalle,
                        placeholder: "Nom de la salle de spectacle",
                      ),

                      const VerticalMargin(ratio: 0.02),
                      InputCustomPL(
                        controllerPL: tecNbPlaceMax,
                        placeholder: "Nombre de place maximum de la salle",
                      ),
                      const VerticalMargin(ratio: 0.02),
                      InputCustomPL(
                        controllerPL: tecCodePostal,
                        placeholder: "Code postal de la salle",
                      ),

                      const VerticalMargin(ratio: 0.02),
                      InputCustomPL(
                        controllerPL: tecAdresse,
                        placeholder: "Adresse de la salle",
                      ),

                      const VerticalMargin(ratio: 0.02),
                      InputCustomPL(
                        controllerPL: tecVille,
                        placeholder: "Ville de la salle",
                      ),

                      const VerticalMargin(ratio: 0.02),

                      //Checkbox
                      SizedBox(
                        // height: 400,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Column(
                          children: [
                            const Text("La salle possède une sonorisation ? "),
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
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,

                        // height: 400,
                        child: Column(
                          children: [
                            const Text("La salle possède un ingénieur ? "),
                            Checkbox(
                              value: isIngenieur,
                              onChanged: (bool? value) {
                                setState(
                                  () {
                                    isIngenieur = value ?? false;
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        // height: 400,
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: Column(
                          children: [
                            const Text("La salle est t'elle publique ?"),
                            Checkbox(
                              value: estPublique,
                              onChanged: (bool? value) {
                                setState(
                                  () {
                                    estPublique = value ?? false;
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      //Bouton validation formulaire
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.1,

                        // height: 400,
                        child: BoutonCustom(
                          onpressed: () {
                            BlocProvider.of<AjoutSalleSpBloc>(context).add(
                              ASPCreate(
                                  tecNomSalle.text,
                                  tecCodePostal.text,
                                  tecAdresse.text,
                                  tecVille.text,
                                  int.parse(tecNbPlaceMax.text),
                                  isSonorisation,
                                  isIngenieur,
                                  estPublique),
                            );
                          },
                          texteValeur: "VALIDER",
                        ),
                      ),
                    ],
                  ),
                ),
                if (state is ASPSuccess)
                  const Text("La salle a bien été ajoutée."),
                if (state is ASPFailure)
                  const Text(
                      "Une erreur est survenue lors de la création de la salle."),
              ],
            ),
          );
        },
      ),
    );
  }
}
