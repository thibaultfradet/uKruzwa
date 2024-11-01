import 'package:flutter/material.dart';
import 'package:ukruzwa/domain/Groupe.dart';
import 'package:ukruzwa/domain/Style.dart';
import 'package:ukruzwa/domain/Instrument.dart';
import 'package:ukruzwa/data/dataSource/remote/firebase.dart';
import 'package:ukruzwa/presentation/pages/grdetail.dart';
import 'package:ukruzwa/presentation/widgets/ItemValider.dart';

class Globalpresentation extends StatefulWidget {
  final Groupe groupeConcerner;

  Globalpresentation({super.key, required this.groupeConcerner});

  @override
  State<Globalpresentation> createState() => _GlobalpresentationState();
}

class _GlobalpresentationState extends State<Globalpresentation> {
  List<Style> styleDuGroupe = [];
  List<Instrument> instrumentDuGroupe = [];

  @override
  void initState() {
    super.initState();
    getStyleFromGroupe(widget.groupeConcerner.idGroupe).then((value_style) {
      setState(() {
        styleDuGroupe = value_style;
      });
    });
    getInstrumentFromGroupe(widget.groupeConcerner.idGroupe)
        .then((value_instrument) {
      setState(() {
        instrumentDuGroupe = value_instrument;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // On push vers la page de vue détaillée d'item
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Grdetail(
                        groupeConcerner: widget.groupeConcerner,
                      )));
        });
      },
      child: Container(
        //taille
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.40,
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
              height: MediaQuery.of(context).size.height * 0.1,
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
              height: MediaQuery.of(context).size.height * 0.2,
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
                        ListView.builder(
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
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: instrumentDuGroupe.length,
                          itemBuilder: (context, index) {
                            return ItemValider(
                                valeur:
                                    instrumentDuGroupe[index].nomInstrument);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //Ligne informations adresse
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              child: Text(
                '${widget.groupeConcerner.villeRepetition.codePostal}, ${widget.groupeConcerner.villeRepetition.idVille}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
