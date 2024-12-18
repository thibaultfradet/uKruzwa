import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/presentation/blocs/ajoutsonorisation/ajoutsonorisation_bloc.dart';
import 'package:ukruzwa/presentation/blocs/ajoutsonorisation/ajoutsonorisation_event.dart';
import 'package:ukruzwa/presentation/blocs/ajoutsonorisation/ajoutsonorisation_state.dart';
import 'package:ukruzwa/presentation/pages/home.dart';
import 'package:ukruzwa/presentation/widgets/bouton_custom.dart';
import 'package:ukruzwa/presentation/widgets/input_custom_pl.dart';
import 'package:ukruzwa/presentation/widgets/vertical_margin.dart';

class Ajoutsonorisation extends StatefulWidget {
  final String
      idGroupeConcerner; // => dans touts les cas MAIS AUSSI pour la modification d'une sono
  const Ajoutsonorisation({super.key, required this.idGroupeConcerner});

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
        //Si la création de sonorisation cest bien produit
        if (state is ASSuccess) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const Home(),
                ),
              );
            },
          );
        }
        if (state is ASFailure) {
          WidgetsBinding.instance.addPostFrameCallback(
            (_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Center(
                    child: Text(
                      'Une erreur est survenue lors de la création, veuillez saisir touts les champs.',
                    ),
                  ),
                ),
              );
            },
          );
        }
        return Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Center(
              child: Text(
                "Ajouter une sonorisation",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const VerticalMargin(ratio: 0.05),
                  //Description de la sono
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.96,
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: InputCustomPL(
                      placeholder: "Description de la sonorisation",
                      controllerPL: tecDescriptionSono,
                      isObscure: false,
                    ),
                  ),

                  const VerticalMargin(ratio: 0.03),
                  // Ingénieur accompagne groupe => + info qui dépende si true
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.09,
                    child: Column(
                      children: [
                        const Text("Un ingénieur accompagne t'il le groupe ?"),
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
                      ],
                    ),
                  ),

                  const VerticalMargin(ratio: 0.03),
                  //Activé uniquement si ingeAccompagne est vrai
                  Visibility(
                    visible: ingeAccompagne,
                    child: SizedBox(
                      // height: MediaQuery.of(context).size.height * 0.3,
                      child: Column(
                        children: [
                          //Ingénieur est pro
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.96,
                            height: MediaQuery.of(context).size.height * 0.22,
                            child: Column(
                              children: [
                                const Text(
                                  "L'ingénieur qui accompagne le groupe est t'il un professionnel ?",
                                  textAlign: TextAlign.center,
                                ),
                                Checkbox(
                                  value: ingeEstPro ?? false,
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
                                const VerticalMargin(ratio: 0.03),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.96,
                                  child: InputCustomPL(
                                    placeholder: "Prix service ingénieur",
                                    controllerPL: tecPrixServiceInge,
                                    isObscure: false,
                                    isDouble: true,
                                    enable: ingeAccompagne,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const VerticalMargin(ratio: 0.03),

                  //modèle de la sono
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.96,
                    child: InputCustomPL(
                      placeholder: "Modèle de la sonorisation",
                      controllerPL: tecModeleSono,
                      isObscure: false,
                    ),
                  ),

                  const VerticalMargin(ratio: 0.03),
                  //puissance sono
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.96,
                    child: InputCustomPL(
                      placeholder: "Puissance de la sonorisation",
                      controllerPL: tecPuissanceSono,
                      isObscure: false,
                      isDouble: true,
                    ),
                  ),

                  const VerticalMargin(ratio: 0.03),
                  //Prix location sono
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.96,
                    child: InputCustomPL(
                      placeholder: "Prix location de la sonorisation",
                      controllerPL: tecPrixLocationSono,
                      isObscure: false,
                      isDouble: true,
                    ),
                  ),

                  const VerticalMargin(ratio: 0.03),
                  //Bouton validation formulaire
                  BoutonCustom(
                    onpressed: () {
                      BlocProvider.of<AjoutsonorisationBloc>(context).add(
                        ASEventCreate(
                          idGroupeConcerner: widget.idGroupeConcerner,
                          descriptionSono: tecDescriptionSono.text,
                          ingeAccompagne: ingeAccompagne,
                          modeleSono: tecModeleSono.text,
                          prixLocationSono: tecPrixLocationSono.text,
                          puissanceSono: tecPuissanceSono.text,
                          //valeur nullable
                          ingeEstPro:
                              ingeAccompagne == false ? null : ingeEstPro,
                          prixServiceInge: ingeAccompagne == false
                              ? null
                              : tecPrixServiceInge.text != ""
                                  ? int.parse(tecPrixServiceInge.text)
                                  : null,
                        ),
                      );
                    },
                    texteValeur: "Valider",
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
