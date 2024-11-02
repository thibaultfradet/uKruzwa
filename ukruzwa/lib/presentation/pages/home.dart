import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/presentation/blocs/home/home_bloc.dart';
import 'package:ukruzwa/presentation/blocs/home/home_state.dart';
import 'package:ukruzwa/presentation/blocs/home/home_event.dart';
import 'package:ukruzwa/presentation/widgets/GlobalPresentation.dart';
import 'package:ukruzwa/presentation/widgets/InputCustomPL.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Pour DropDownButton => liste des options
  List<String> options = ['Nom du groupe', 'Style', 'Ville'];
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
          if (state is HomeStateInitial) {
            return Scaffold(
              appBar: AppBar(
                title: const Text("Rechercher un groupe"),
                centerTitle: true,
                actions: [
                  IconButton(
                    // L'utilisateur clique => page d'informations sur son compte (liste des annonces, etc.)
                    onPressed: () {},
                    icon: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                  ),
                ],
              ),
              // On rend toute la page scrollable
              body: SingleChildScrollView(
                // Colonne de la page
                child: Column(
                  children: [
                    // Partie du haut avec recherche
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Column(
                        children: [
                          // Affichage du filtre avec la valeur sélectionnée
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "Filtre : $selectedValue",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          // Ligne avec entrée utilisateur et bouton valider
                          Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: Row(
                              children: [
                                Expanded(
                                  child: InputCustomPL(
                                    placeholder:
                                        "Rechercher par " + selectedValue!,
                                    controllerPL: tecRecherche,
                                    isObscure: false,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    // Validation de la recherche on appelle l'event de recherche et on passe en paramètre le libelle saisie et l'option choisis par l'utilisateur
                                    BlocProvider.of<HomeBloc>(context).add(
                                        HomeEventUtilisateurRecherche(
                                            tecRecherche.text, selectedValue!));
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    "Valider",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // ComboBox avec les différents filtres de recherche
                          Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                dropdownColor: Colors.black,
                                value: selectedValue,
                                icon: const Icon(Icons.arrow_drop_down,
                                    color: Colors.white),
                                style: const TextStyle(color: Colors.white),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedValue = newValue;
                                  });
                                },
                                items: options.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Résultat aléatoire
                    Container(
                      height: MediaQuery.of(context).size.height * 0.12,
                      child: const Text(
                        "Goupe apparant de manière aléatoire parmis les résultats de la recherche",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),

                    //Liste view des résultats
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.collectionGroupe.length,
                        itemBuilder: (context, index) {
                          return Globalpresentation(
                              groupeConcerner: state.collectionGroupe[index]);
                        }),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text("Une erreur est survenue."));
          }
        }));
  }
}
