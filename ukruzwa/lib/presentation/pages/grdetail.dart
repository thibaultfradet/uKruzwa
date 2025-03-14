import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/presentation/blocs/grdetail/grdetail_bloc.dart';
import 'package:ukruzwa/presentation/blocs/grdetail/grdetail_event.dart';
import 'package:ukruzwa/presentation/blocs/grdetail/grdetail_state.dart';
import 'package:ukruzwa/domain/models/groupe.dart';
import 'package:ukruzwa/presentation/widgets/horizontal_margin.dart';
import 'package:ukruzwa/presentation/widgets/item_valider.dart';
import 'package:ukruzwa/presentation/widgets/vertical_margin.dart';

class Grdetail extends StatefulWidget {
  final Groupe groupeConcerner;
  const Grdetail({super.key, required this.groupeConcerner});

  @override
  State<Grdetail> createState() => _GrdetailState();
}

class _GrdetailState extends State<Grdetail> {
  TextEditingController tecEmpty = TextEditingController();
  //Liste des styles et des instruments du groupe

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GrdetailBloc()..add(GrdetailEvent()),
      child: BlocBuilder<GrdetailBloc, GrdetailState>(
        builder: (BuildContext context, state) {
          //Page de base => on affiche toutes les informations du groupe + la possibilité de postuler
          if (state is GrdetailStateInitial) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: Center(
                  child: Text(
                    "Fiche du groupe ${widget.groupeConcerner.nomGroupe}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              backgroundColor: Colors.white,
              //Permet de scroller car formulaire trop long
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    //Row du haut pour postuler (possibilité future de rajouter des objets en ajoutant une row)
                    const VerticalMargin(ratio: 0.02),
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 2.0,
                          ),
                        ),
                      ),
                      height: MediaQuery.of(context).size.height * 0.06,
                      // Ancien bouton postuler
                      // child: BoutonCustom(
                      //   onpressed: () {
                      //     WidgetsBinding.instance.addPostFrameCallback(
                      //       (_) {
                      //         Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //             builder: (context) => Postuler(
                      //                 groupeConcerner: widget.groupeConcerner),
                      //           ),
                      //         );
                      //       },
                      //     );
                      //   },
                      //   texteValeur: "POSTULER",
                      // ),
                    ),
                    //Colonne de toutes les informations
                    Column(
                      children: [
                        //Nom du groupe
                        Text(
                          widget.groupeConcerner.nomGroupe,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const VerticalMargin(ratio: 0.03),

                        const VerticalMargin(ratio: 0.02),
                        //Style du groupe
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                          child: Column(
                            children: [
                              const Text("Styles du groupe"),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: widget
                                      .groupeConcerner.stylesDuGroupe!.length,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      children: [
                                        const Horizontalmargin(ratio: 0.02),
                                        ItemValider(
                                            valeur: widget
                                                .groupeConcerner
                                                .stylesDuGroupe![index]
                                                .nomStyle),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        //Instrument du groupe
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                          child: Column(
                            children: [
                              const Text("Instruments du groupe"),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: widget.groupeConcerner
                                      .instrumentsDuGroupe!.length,
                                  itemBuilder: (context, index) {
                                    return Row(
                                      children: [
                                        const Horizontalmargin(ratio: 0.02),
                                        ItemValider(
                                            valeur: widget
                                                .groupeConcerner
                                                .instrumentsDuGroupe![index]
                                                .nomInstrument),
                                      ],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        //Si le groupe n'a pas d'endroits deja joués alors on affiche sinon on met rien
                        widget.groupeConcerner.endroitsDejaJoues == null
                            ? const SizedBox()
                            :
                            //Exemple endroits joués
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: Column(
                                  children: [
                                    const Text("Exemple d'endroits joués"),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 2.0,
                                        ),
                                      ),
                                      child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.3,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: widget.groupeConcerner
                                              .endroitsDejaJoues!.length,
                                          itemBuilder: (context, index) {
                                            return ItemValider(
                                              valeur:
                                                  "${widget.groupeConcerner.endroitsDejaJoues![index].nomVille} ; ${widget.groupeConcerner.endroitsDejaJoues![index].codePostal}",
                                              largeur: 0.7,
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                        const VerticalMargin(ratio: 0.05),
                        //Information sur l'endroit de répétition
                        Container(
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height * 0.1,
                          child: Column(
                            children: [
                              const Text(
                                "Situation géographique",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text(widget
                                  .groupeConcerner.villeRepetition.nomVille),
                              Text(widget
                                  .groupeConcerner.villeRepetition.codePostal),
                            ],
                          ),
                        ),
                        //Si le groupe possède une sonorisation on affiche informations sonorisation (possederSonorisation => booleen)
                        widget.groupeConcerner.sonorisationDuGroupe != null
                            ? Container(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    //titre de la section
                                    const Text(
                                      "Information sur la sonorisation",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    //Modèle de la sono
                                    const Text(
                                      "Modèle de la sonorisation",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    ItemValider(
                                      valeur:
                                          // Pour éviter erreur valeur null
                                          widget.groupeConcerner
                                              .sonorisationDuGroupe!.modeleSono,
                                      largeur: 0.8,
                                    ),
                                    //Espace entre les objets
                                    const VerticalMargin(ratio: 0.02),
                                    //Description de la sono
                                    const Text(
                                      "Description de la sonorisation",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    //Appel item valider avec une hauteur car description peut etre longue
                                    ItemValider(
                                      valeur: widget
                                          .groupeConcerner
                                          .sonorisationDuGroupe!
                                          .descriptionSono,
                                      largeur: 0.8,
                                      hauteur: 0.2,
                                    ),
                                    const VerticalMargin(ratio: 0.05),
                                    //Prix location sonorisation

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                            "Prix location sa la sonorisation : "),
                                        const Horizontalmargin(ratio: 0.02),
                                        ItemValider(
                                          valeur: widget
                                              .groupeConcerner
                                              .sonorisationDuGroupe!
                                              .prixLocaSono
                                              .toString(),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox(),

                        const VerticalMargin(ratio: 0.05),
                        // Si le groupe possède un ingénieur son on affiche ses informations (ingeSon => booleen)
                        widget.groupeConcerner.ingeSon != null
                            ? Container(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    //titre de la section
                                    const Text(
                                      "Information sur l'ingénieur son",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    //Ingénieur est t'il un professionel
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                            "Prix service de l'ingénieur : "),
                                        const Horizontalmargin(ratio: 0.02),
                                        ItemValider(
                                          valeur: widget
                                              .groupeConcerner.prixInge
                                              .toString(),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox(),

                        const VerticalMargin(ratio: 0.05),
                        // Information de contact
                        Container(
                          alignment: Alignment.center,
                          //titre de la section
                          child: Column(
                            children: [
                              const Text(
                                "Information de contact",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),

                              //mail de contact
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                child: Column(
                                  children: [
                                    const Text("Adresse mail du contact"),
                                    ItemValider(
                                        valeur: widget.groupeConcerner
                                            .personneAContacter.mail,
                                        largeur: 0.8)
                                  ],
                                ),
                              ),

                              //Numéro téléphone contact
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                child: Column(
                                  children: [
                                    const Text(
                                        "Numéro de téléphone du contact"),
                                    ItemValider(
                                        valeur: widget.groupeConcerner
                                            .personneAContacter.numeroTelephone,
                                        largeur: 0.8)
                                  ],
                                ),
                              ),

                              //Numéro remplacement du contact
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                child: Column(
                                  children: [
                                    const Text(
                                        "Numéro de remplacement du contact"),
                                    ItemValider(
                                        valeur: widget.groupeConcerner
                                            .numeroRemplacementContact,
                                        largeur: 0.8)
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
          //Erreur
          else {
            return const Center(child: Text("Une erreur est survenue."));
          }
        },
      ),
    );
  }
}
