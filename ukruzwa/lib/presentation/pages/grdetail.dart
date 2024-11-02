import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/presentation/blocs/grdetail/grdetail_bloc.dart';
import 'package:ukruzwa/presentation/blocs/grdetail/grdetail_event.dart';
import 'package:ukruzwa/presentation/blocs/grdetail/grdetail_state.dart';
import 'package:ukruzwa/domain/Groupe.dart';
import 'package:ukruzwa/domain/Style.dart';
import 'package:ukruzwa/domain/Instrument.dart';
import 'package:ukruzwa/data/dataSource/remote/firebase.dart';
import 'package:ukruzwa/presentation/pages/postuler.dart';
import 'package:ukruzwa/presentation/widgets/ItemValider.dart';
import 'package:ukruzwa/domain/Ville.dart';
import 'package:ukruzwa/presentation/widgets/VerticalMargin.dart';

class Grdetail extends StatefulWidget {
  final Groupe groupeConcerner;
  const Grdetail({super.key, required this.groupeConcerner});

  @override
  State<Grdetail> createState() => _GrdetailState();
}

class _GrdetailState extends State<Grdetail> {
  //Liste des styles et des instruments du groupe
  List<Style> styleDuGroupe = [];
  List<Instrument> instrumentDuGroupe = [];
  List<Ville> endroitsJouesDuGroupe = [];

  @override
  void initState() {
    super.initState();
    getStyleFromGroupe(widget.groupeConcerner.idGroupe).then((valueStyle) {
      setState(() {
        styleDuGroupe = valueStyle;
      });
    });
    getInstrumentFromGroupe(widget.groupeConcerner.idGroupe)
        .then((valueInstrument) {
      setState(() {
        instrumentDuGroupe = valueInstrument;
      });
    });
    getVilleFromGroupeEndroitsJoues(widget.groupeConcerner.idGroupe)
        .then((valueEndroits) {
      setState(() {
        endroitsJouesDuGroupe = valueEndroits;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => GrdetailBloc()..add(GrdetailEvent()),
        child: BlocBuilder<GrdetailBloc, GrdetailState>(
            builder: (BuildContext context, state) {
          //Page de base => on affiche toutes les informations du groupe + la possibilité de postuler
          if (state is GrdetailStateInitial) {
            return Scaffold(
                backgroundColor: Colors.white,
                //Permet de scroller car formulaire trop long
                body: SingleChildScrollView(
                    child: Column(children: [
                  //Row du haut pour postuler (possibilité future de rajouter des objets en ajoutant une row)
                  Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                      ),
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.black,
                          ),
                          // L'utilisateur clique sur postuler => on l'envoie vers la fenêtre
                          onPressed: () {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Postuler()));
                            });
                          },
                          child: const Text(
                            "POSTULER",
                            style: TextStyle(color: Colors.white),
                          ))),
                  //Colonne de toutes les informations
                  Column(children: [
                    //Nom du groupe
                    Text(
                      widget.groupeConcerner.nomGroupe,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    //Style du groupe
                    Container(
                      height: MediaQuery.of(context).size.height * 0.12,
                      child: Row(
                        children: [
                          const Text("Style du groupe"),
                          ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: styleDuGroupe.length,
                            itemBuilder: (context, index) {
                              return ItemValider(
                                  valeur: styleDuGroupe[index].nomStyle);
                            },
                          ),
                        ],
                      ),
                    ),
                    //Instrument du groupe
                    Container(
                        height: MediaQuery.of(context).size.height * 0.12,
                        child: Row(
                          children: [
                            const Text("Instrument du groupe"),
                            ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: instrumentDuGroupe.length,
                                itemBuilder: (context, index) {
                                  return ItemValider(
                                      valeur: instrumentDuGroupe[index]
                                          .nomInstrument);
                                })
                          ],
                        )),
                    //Ligne nombres de chanteurs
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: Row(
                        children: [
                          const Text("Nombres de chanteurs : "),
                          ItemValider(
                              valeur: instrumentDuGroupe.length.toString())
                        ],
                      ),
                    ),
                    //Exemple endroits joués
                    Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Row(
                        children: [
                          const Text("Exemple d'endroits joués"),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey,
                                width: 2.0,
                              ),
                            ),
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: endroitsJouesDuGroupe.length,
                              itemBuilder: (context, index) {
                                return ItemValider(
                                  valeur: (endroitsJouesDuGroupe[index]
                                          .nomEvenement!) +
                                      " ; " +
                                      endroitsJouesDuGroupe[index].nomVille,
                                  largeur: 0.8,
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),

                    //Information sur l'endroit de répétition
                    Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: Column(
                          children: [
                            const Text(
                                "Information sur l'endroit de répetition",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(widget
                                .groupeConcerner.villeRepetition.nomVille),
                            Text(widget
                                .groupeConcerner.villeRepetition.codePostal),
                          ],
                        )),
                    //Si le groupe possède une sonorisation on affiche informations sonorisation (possederSonorisation => booleen)
                    widget.groupeConcerner.possederSonorisation
                        ? Container(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                //titre de la section
                                const Text("Information sur la sonorisation",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                                //Modèle de la sono
                                const Text("Modèle de la sonorisation",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                ItemValider(
                                  valeur:
                                      // Pour éviter erreur valeur null
                                      widget.groupeConcerner.modeleSono!,
                                  largeur: 0.8,
                                ),
                                //Espace entre les objets
                                const VerticalMargin(ratio: 0.02),
                                //Description de la sono
                                const Text("Description de la sonorisation",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                //Appel item valider avec une hauteur car description peut etre longue
                                ItemValider(
                                    valeur:
                                        widget.groupeConcerner.descriptionSono!,
                                    largeur: 0.8,
                                    hauteur: 0.25),
                                //Prix location sonorisation
                                Row(
                                  children: [
                                    const Text(
                                        "Prix location sa la sonorisation : "),
                                    ItemValider(
                                        valeur: widget
                                            .groupeConcerner.prixLocationSono
                                            .toString())
                                  ],
                                )
                              ],
                            ),
                          )
                        : const SizedBox(),

                    // Si le groupe possède un ingénieur son on affiche ses informations (ingeSon => booleen)
                    widget.groupeConcerner.ingeSon
                        ? Container(
                            alignment: Alignment.center,
                            child: Column(children: [
                              //titre de la section
                              const Text("Information sur l'ingénieur son",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              //Ingénieur est t'il un professionel
                              Row(
                                children: [
                                  const Text(
                                      "L'ingénieur est t'il un professionel : "),
                                  Checkbox(
                                    //Valeur null => éviter intéraction utilisateur (mode read only)
                                    onChanged: null,
                                    value: widget.groupeConcerner.ingePro,
                                  ),
                                ],
                              ),
                              //Prix service de l'ingénieur
                              Row(
                                children: [
                                  const Text("Prix service de l'ingénieur : "),
                                  ItemValider(
                                      valeur: widget.groupeConcerner.prixInge
                                          .toString())
                                ],
                              )
                            ]),
                          )
                        : const SizedBox(),

                    // Information de contact
                    Container(
                      alignment: Alignment.center,
                      //titre de la section
                      child: Column(children: [
                        const Text("Information de contact",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),

                        //mail de contact
                        Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: Column(
                            children: [
                              const Text("Adresse mail du contact"),
                              ItemValider(
                                  valeur: widget
                                      .groupeConcerner.personneAContacter.mail,
                                  largeur: 0.8)
                            ],
                          ),
                        ),

                        //Numéro téléphone contact
                        Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: Column(
                            children: [
                              const Text("numéro de téléphone du contact"),
                              ItemValider(
                                  valeur: widget.groupeConcerner
                                      .personneAContacter.numeroTelephone,
                                  largeur: 0.8)
                            ],
                          ),
                        ),

                        //Numéro remplacement du contact
                        Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: Column(
                            children: [
                              const Text("Adresse mail du contact"),
                              ItemValider(
                                  valeur: widget.groupeConcerner
                                      .numeroRemplacementContact,
                                  largeur: 0.8)
                            ],
                          ),
                        )
                      ]),
                    ),
                  ])
                ])));
          }
          //Erreur
          else {
            return const Center(child: Text("Une erreur est survenue."));
          }
        }));
  }
}
