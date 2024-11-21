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
  List<String> options = ['Nom', 'Style', 'Instrument'];
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
                      // Colonne de la page
                      child: Column(
                        children: [
                          // Partie du haut avec recherche
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height * 0.22,
                            child: Column(
                              children: [
                                // Ligne avec entrée utilisateur et bouton valider
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.07,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: InputCustomPL(
                                          placeholder:
                                              "Rechercher par ${selectedValue!}",
                                          controllerPL: tecRecherche,
                                          isObscure: false,
                                        ),
                                      ),
                                      //Bouton validation
                                      // Validation de la recherche on appelle l'event de recherche et on passe en paramètre le libelle saisie et l'option choisis par l'utilisateur
                                      BoutonCustom(
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
                                // Affichage du filtre avec la valeur sélectionnée,
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.11,
                                  child: Column(
                                    //Affichage filtre selectionner
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          "Filtre : $selectedValue",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),

                                      //Espace entre les deux
                                      const VerticalMargin(ratio: 0.01),
                                      // ComboBox avec les différents filtres de recherche
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.9,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<String>(
                                            dropdownColor: Colors.black,
                                            value: selectedValue,
                                            icon: const Icon(
                                                Icons.arrow_drop_down,
                                                color: Colors.white),
                                            style: const TextStyle(
                                                color: Colors.white),
                                            onChanged: (String? newValue) {
                                              setState(
                                                () {
                                                  selectedValue = newValue;
                                                },
                                              );
                                            },
                                            items: options
                                                .map<DropdownMenuItem<String>>(
                                              (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(
                                                    value,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                );
                                              },
                                            ).toList(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Résultat aléatoire texte
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.08,
                            child: const Text(
                              "Goupe apparant de manière aléatoire parmis les résultats de la recherche",
                              style: TextStyle(fontWeight: FontWeight.bold),
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
