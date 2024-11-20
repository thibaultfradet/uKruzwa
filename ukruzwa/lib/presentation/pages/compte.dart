import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/presentation/blocs/compte/compte_bloc.dart';
import 'package:ukruzwa/presentation/blocs/compte/compte_event.dart';
import 'package:ukruzwa/presentation/blocs/compte/compte_state.dart';
import 'package:ukruzwa/presentation/pages/ajoutgroupe.dart';
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
          if (state is CompteStateInitial) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Information sur votre compte"),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(
                      child: Text(
                        "GESTION DES ANNONCES",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.07,
                      width: MediaQuery.of(context).size.width,
                      child: BoutonCustom(
                          onpressed: () {
                            WidgetsBinding.instance.addPostFrameCallback(
                              (_) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Ajoutgroupe(),
                                  ),
                                );
                              },
                            );
                          },
                          texteValeur: "Ajouter un groupe"),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.9,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.groupeDuCompte.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Globalpresentationcompte(
                                groupeConcerner: state.groupeDuCompte[index],
                                //On appel l'event pour supprimer le groupe
                                onPressedDelete: () {
                                  BlocProvider.of<CompteBloc>(context).add(
                                    UserDeleteGroupe(
                                      state.groupeDuCompte[index].idGroupe
                                          .toString(),
                                    ),
                                  );
                                },
                                //Envoie de l'utilisateur vers la page de modification de groupe
                                onPressedEdit: () {},
                                //Envoie de l'utilisateur vers la page de modification de la sono du groupe concerner
                                onPressedEditSono: () {},
                              ),
                              const VerticalMargin(ratio: 0.03)
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const Center(child: Text("Une erreur est survenue"));
        },
      ),
    );
  }
}
