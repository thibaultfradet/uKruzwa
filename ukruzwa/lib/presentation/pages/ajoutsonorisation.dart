import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/domain/models/groupe.dart';
import 'package:ukruzwa/presentation/blocs/ajoutsonorisation/ajoutsonorisation_bloc.dart';
import 'package:ukruzwa/presentation/blocs/ajoutsonorisation/ajoutsonorisation_event.dart';
import 'package:ukruzwa/presentation/blocs/ajoutsonorisation/ajoutsonorisation_state.dart';
import 'package:ukruzwa/presentation/widgets/bouton_custom.dart';
import 'package:ukruzwa/presentation/widgets/input_custom_pl.dart';

class Ajoutsonorisation extends StatefulWidget {
  final Groupe
      groupeConcerner; // => dans touts les cas MAIS AUSSI pour la modification d'une sono
  const Ajoutsonorisation({super.key, required this.groupeConcerner});

  @override
  State<Ajoutsonorisation> createState() => _AjoutsonorisationState();
}

class _AjoutsonorisationState extends State<Ajoutsonorisation> {
  TextEditingController tecDescriptionSono = TextEditingController();
  bool ingeAccompagne = false;
  bool? ingeEstPro;
  TextEditingController tecModeleSono = TextEditingController();
  TextEditingController tecPuissanceSono = TextEditingController();
  TextEditingController tecPrixLocationSono = TextEditingController();
  TextEditingController tecPrixServiceInge = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AjoutsonorisationBloc, AjoutsonorisationState>(
      builder: (BuildContext context, state) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Center(
              child: Text(
                "Ajouter une sonorisation",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          body: Column(
            children: [
              //Description de la sono
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child: InputCustomPL(
                  placeholder: "Description de la sonorisation",
                  controllerPL: tecDescriptionSono,
                  isObscure: false,
                ),
              ),
              // Ingénieur accompagne groupe => + info qui dépende si true
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Column(
                  children: [
                    Checkbox(
                      value: ingeAccompagne,
                      onChanged: (bool? value) {
                        setState(
                          () {
                            ingeAccompagne =
                                value ?? false; // => false si valeur null
                          },
                        );
                      },
                    ),
                    //Activé uniquement si ingeAccompagne est vrai
                    Checkbox(
                      value: ingeEstPro,
                      onChanged: ingeAccompagne == true
                          ? (bool? value) {
                              setState(
                                () {
                                  ingeEstPro = value;
                                },
                              );
                            }
                          : null,
                    ),
                    InputCustomPL(
                      placeholder: "Prix service ingénieur",
                      controllerPL: tecPrixServiceInge,
                      isObscure: false,
                      enable: ingeAccompagne,
                    )
                  ],
                ),
              ),

              //modèle de la sono
              InputCustomPL(
                placeholder: "Modèle de la sonorisation",
                controllerPL: tecModeleSono,
                isObscure: false,
              ),
              //puissance sono
              InputCustomPL(
                placeholder: "Puissance de la sonorisation",
                controllerPL: tecPuissanceSono,
                isObscure: false,
              ),
              //Prix location sono
              InputCustomPL(
                placeholder: "Prix location de la sonorisation",
                controllerPL: tecPrixLocationSono,
                isObscure: false,
              ),

              //Bouton validation formulaire
              BoutonCustom(
                onpressed: () {
                  BlocProvider.of<AjoutsonorisationBloc>(context).add(
                    ASEventCreate(
                      descriptionSono: tecDescriptionSono.text,
                      ingeAccompagne: ingeAccompagne,
                      modeleSono: tecModeleSono.text,
                      prixLocationSono: int.parse(tecPrixLocationSono.text),
                      puissanceSono: int.parse(tecPuissanceSono.text),
                      //valeur nullable
                      ingeEstPro: ingeEstPro,
                      prixServiceInge: tecPrixServiceInge.text != ""
                          ? int.parse(tecPrixServiceInge.text)
                          : null,
                    ),
                  );
                },
                texteValeur: "Valider",
              ),
            ],
          ),
        );
      },
    );
  }
}
