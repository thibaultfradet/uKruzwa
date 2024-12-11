import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/presentation/blocs/compte/compte_bloc.dart';
import 'package:ukruzwa/presentation/blocs/compte/compte_event.dart';
import 'package:ukruzwa/presentation/blocs/compte/compte_state.dart';
import 'package:ukruzwa/presentation/pages/ajoutgroupe.dart';
import 'package:ukruzwa/presentation/pages/ajoutsonorisation.dart';
import 'package:ukruzwa/presentation/widgets/bouton_custom.dart';
import 'package:ukruzwa/presentation/widgets/global_presentation_compte.dart';
import 'package:ukruzwa/presentation/widgets/vertical_margin.dart';

class Compte extends StatefulWidget {
  const Compte({super.key});

  @override
  State<Compte> createState() => _CompteState();
}

class _CompteState extends State<Compte> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CompteBloc()..add(CompteEvent()),
      child: BlocBuilder<CompteBloc, CompteState>(
        builder: (BuildContext context, state) {
          //Page de base => touts les groupes du compte concerner
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: const Center(
                child: Text(
                  "Information sur votre compte",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            body: Stack(
              children: [
                // Contenu principal
                if (state is CompteStateInitial)
                  Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const VerticalMargin(ratio: 0.02),
                          const SizedBox(
                            child: Text(
                              "GESTION DES ANNONCES",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          const VerticalMargin(ratio: 0.02),

                          //Bouton ajout de groupe
                          BoutonCustom(
                              largeur: 0.9,
                              onpressed: () {
                                WidgetsBinding.instance.addPostFrameCallback(
                                  (_) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const Ajoutgroupe(),
                                      ),
                                    );
                                  },
                                );
                              },
                              texteValeur: "Ajouter un groupe"),
                          const VerticalMargin(ratio: 0.02),
                          SizedBox(
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: state.groupeDuCompte.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    const VerticalMargin(ratio: 0.05),
                                    Globalpresentationcompte(
                                      groupeConcerner:
                                          state.groupeDuCompte[index],
                                      //On appel l'event pour supprimer le groupe
                                      onPressedDelete: () {
                                        BlocProvider.of<CompteBloc>(context)
                                            .add(
                                          UserDeleteGroupe(
                                            state.groupeDuCompte[index].idGroupe
                                                .toString(),
                                          ),
                                        );
                                      },
                                      //Envoie de l'utilisateur vers la page de modification de groupe
                                      onPressedEdit: () {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback(
                                          (_) {
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    Ajoutgroupe(
                                                  groupeAModifier: state
                                                      .groupeDuCompte[index],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      //Envoie de l'utilisateur vers la page de modification de la sono du groupe concerner
                                      onPressedEditSono: () {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback(
                                          (_) {
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    Ajoutsonorisation(
                                                  groupeConcerner: state
                                                      .groupeDuCompte[index],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                    const VerticalMargin(ratio: 0.03)
                                  ],
                                );
                              },
                            ),
                          ),
                          const VerticalMargin(ratio: 0.05),
                        ],
                      ),
                    ),
                  ),

                if (state is CompteStateLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
              ],
            ),
          );
        },
      ),
    );
  }
}
