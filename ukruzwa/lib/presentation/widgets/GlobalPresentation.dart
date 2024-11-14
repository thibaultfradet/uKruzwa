import 'package:flutter/material.dart';
import 'package:ukruzwa/domain/models/Groupe.dart';
import 'package:ukruzwa/presentation/pages/grdetail.dart';
import 'package:ukruzwa/presentation/widgets/ItemValider.dart';
import 'package:ukruzwa/presentation/widgets/VerticalMargin.dart';

class Globalpresentation extends StatefulWidget {
  final Groupe groupeConcerner;

  Globalpresentation({super.key, required this.groupeConcerner});

  @override
  State<Globalpresentation> createState() => _GlobalpresentationState();
}

class _GlobalpresentationState extends State<Globalpresentation> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // On push vers la page de vue détaillée d'item
        WidgetsBinding.instance.addPostFrameCallback(
          (_) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Grdetail(
                  groupeConcerner: widget.groupeConcerner,
                ),
              ),
            );
          },
        );
      },
      child: Container(
        //taille
        width: MediaQuery.of(context).size.width * 0.91,
        height: MediaQuery.of(context).size.height * 0.35,
        //bordure
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            //Ligne nom du groupe => container car 1 enfant
            Container(
              height: MediaQuery.of(context).size.height * 0.07,
              child: Text(
                widget.groupeConcerner.nomGroupe,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            //Ligne instrument et style décomposer en 2 colonnes => row car multi child mis dans container pour gerer taille
            Container(
              height: MediaQuery.of(context).size.height * 0.24,
              child: Row(
                //La ligne est séparer en deux container ( 1 colonne chaqun pour mieux gerer la largeur => instrument et style)
                children: [
                  //style du groupe
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Column(
                      children: [
                        const Text(
                          "Style",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        //Liste view pour tous les styles
                        Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                widget.groupeConcerner.stylDuGroupe!.length,
                            itemBuilder: (context, index) {
                              return Column(children: [
                                ItemValider(
                                    valeur: widget.groupeConcerner
                                        .stylDuGroupe![index].nomStyle),
                                const VerticalMargin(ratio: 0.01),
                              ]);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  //instrument du groupe
                  Container(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Column(
                      children: [
                        const Text(
                          "Instrument",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        //Liste view pour tous les instruments
                        Container(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget
                                .groupeConcerner.instrumentDuGroupe!.length,
                            itemBuilder: (context, index) {
                              return Column(children: [
                                ItemValider(
                                    valeur: widget
                                        .groupeConcerner
                                        .instrumentDuGroupe![index]
                                        .nomInstrument),
                                const VerticalMargin(ratio: 0.01),
                              ]);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //Ligne informations adresse
            Container(
              child: Text(
                '${widget.groupeConcerner.villeRepetition.codePostal}, ${widget.groupeConcerner.villeRepetition.nomVille}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
