import 'package:flutter/material.dart';
import 'package:ukruzwa/domain/models/groupe.dart';
import 'package:ukruzwa/presentation/pages/grdetail.dart';
import 'package:ukruzwa/presentation/widgets/bouton_custom.dart';
import 'package:ukruzwa/presentation/widgets/item_valider.dart';
import 'package:ukruzwa/presentation/widgets/vertical_margin.dart';

class Globalpresentationcompte extends StatefulWidget {
  final VoidCallback onPressedDelete;
  final VoidCallback onPressedEdit;
  final VoidCallback onPressedEditSono;
  final Groupe groupeConcerner;

  const Globalpresentationcompte({
    super.key,
    required this.groupeConcerner,
    required this.onPressedDelete,
    required this.onPressedEdit,
    required this.onPressedEditSono,
  });

  @override
  State<Globalpresentationcompte> createState() =>
      _GlobalpresentationcompteState();
}

class _GlobalpresentationcompteState extends State<Globalpresentationcompte> {
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
        height: MediaQuery.of(context).size.height * 0.55,
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
            SizedBox(
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
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.24,
              child: Row(
                //La ligne est séparer en deux container ( 1 colonne chaqun pour mieux gerer la largeur => instrument et style)
                children: [
                  //style du groupe
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Column(
                      children: [
                        const Text(
                          "Style",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        //Liste view pour tous les styles
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                widget.groupeConcerner.stylesDuGroupe!.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ItemValider(
                                      valeur: widget.groupeConcerner
                                          .stylesDuGroupe![index].nomStyle),
                                  const VerticalMargin(ratio: 0.01),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  //instrument du groupe
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Column(
                      children: [
                        const Text(
                          "Instrument",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),

                        //Liste view pour tous les instruments
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget
                                .groupeConcerner.instrumentsDuGroupe!.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ItemValider(
                                    valeur: widget
                                        .groupeConcerner
                                        .instrumentsDuGroupe![index]
                                        .nomInstrument,
                                  ),
                                  const VerticalMargin(ratio: 0.01),
                                ],
                              );
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
            SizedBox(
              child: Text(
                '${widget.groupeConcerner.villeRepetition.codePostal}, ${widget.groupeConcerner.villeRepetition.nomVille}',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
            //Container avec les différents bouton (modification groupe / modification sono / suppresion d'un groupe)
            SizedBox(
              child: Column(
                children: [
                  //bouton supprimer
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.058,
                    child: BoutonCustom(
                      largeur: 0.7,
                      onpressed: () {
                        widget.onPressedDelete();
                      },
                      texteValeur: "SUPPRIMER",
                      isDeleteButton: true,
                    ),
                  ),
                  const VerticalMargin(ratio: 0.01),
                  //edit groupe button
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.058,
                    child: BoutonCustom(
                      largeur: 0.7,
                      onpressed: () {
                        widget.onPressedEdit;
                      },
                      texteValeur: "MODIFIER LE GROUPE",
                    ),
                  ),
                  const VerticalMargin(ratio: 0.01),
                  //edit sono button
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.058,
                    child: BoutonCustom(
                      largeur: 0.7,
                      onpressed: () {
                        widget.onPressedEditSono;
                      },
                      texteValeur: "MODIFIER LA SONORISATION",
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
