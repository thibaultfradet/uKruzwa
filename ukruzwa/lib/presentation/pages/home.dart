import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/presentation/blocs/home/home_bloc.dart';
import 'package:ukruzwa/presentation/blocs/home/home_state.dart';
import 'package:ukruzwa/presentation/blocs/home/home_event.dart';
import 'package:ukruzwa/presentation/pages/compte.dart';
import 'package:ukruzwa/presentation/widgets/bouton_custom.dart';
import 'package:ukruzwa/presentation/widgets/global_presentation.dart';
import 'package:ukruzwa/presentation/widgets/input_custom_pl.dart';
import 'package:ukruzwa/presentation/widgets/vertical_margin.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Pour DropDownButton => liste des options
  List<String> options = ['Style'];
  // Pour DropDownButton => valeur sélectionnée par défaut
  String? selectedValue;
  // Pour TextEditingController
  TextEditingController tecRecherche = TextEditingController();

  @override
  void initState() {
    super.initState();

    selectedValue =
        options[0]; // Valeur par défaut: première valeur de la liste
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(HomeEvent()),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (BuildContext context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: Colors.white,
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(4.0),
                child: Container(
                  color: Colors.black,
                  height: 1.0,
                ),
              ),
              title: const Text(
                "Rechercher un groupe",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              actions: [
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: IconButton(
                    // L'utilisateur clique => page d'informations sur son compte (liste des annonces, etc.)
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Compte()),
                          );
                        },
                      );
                    },
                    icon: const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      child: Icon(Icons.person),
                    ),
                  ),
                ),
              ],
            ),
            body: Stack(
              children: [
                // Contenu principal
                if (state is HomeStateInitial)
                  Center(
                    // On rend toute la page scrollable
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const VerticalMargin(ratio: 0.02),
                          // Partie du haut avec recherche
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.20,
                            child: Column(
                              children: [
                                // Ligne avec entrée utilisateur et bouton valider
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.15,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: InputCustomPL(
                                          placeholder: "Rechercher par style",
                                          controllerPL: tecRecherche,
                                          isObscure: false,
                                        ),
                                      ),

                                      //Bouton validation
                                      BoutonCustom(
                                        hauteur: 0.06,
                                        onpressed: () {
                                          BlocProvider.of<HomeBloc>(context)
                                              .add(
                                            HomeEventUtilisateurRecherche(
                                                tecRecherche.text,
                                                selectedValue!),
                                          );
                                        },
                                        texteValeur: "Valider",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Résultat aléatoire texte
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: const Text(
                              "Goupe apparant de manière aléatoire parmis les résultats de la recherche",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(
                            child: Text(""),
                          ),
                          //Liste view des résultats
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.9,
                            child: ListView.builder(
                              //on laisse le single child scroll view prendre le scroll
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: state.collectionGroupe.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Globalpresentation(
                                        groupeConcerner:
                                            state.collectionGroupe[index]),
                                    const VerticalMargin(ratio: 0.03)
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (state is HomeStateLoading)
                  const Center(child: CircularProgressIndicator())
              ],
            ),
          );
        },
      ),
    );
  }
}
