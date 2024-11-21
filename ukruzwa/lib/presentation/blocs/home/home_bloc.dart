import 'package:ukruzwa/data/dataSource/remote/groupe_firebase.dart';
import 'package:ukruzwa/presentation/blocs/home/home_state.dart';
import 'package:ukruzwa/presentation/blocs/home/home_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/domain/models/groupe.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeStateInitial([])) {
    // État initial
    on<HomeEvent>((event, emit) async {
      //en attente du chargement des données on emit un load
      emit(HomeStateLoading());

      // Instanciation d'une liste de groupes + appel de méthode dans BDD Firebase
      List<Groupe> collectionGroupe = await findAllGroupe();
      collectionGroupe.shuffle();
      emit(HomeStateInitial(collectionGroupe));
    });

    /* L'utilisateur recherche un groupe */
    on<HomeEventUtilisateurRecherche>((event, emit) async {
      // On rappelle le HomeStateInitial mais avec une nouvelle liste en rapport avec la demande de l'utilisateur
      List<Groupe> collectionGroupe =
          await findAllGroupeRecherche(event.libelle, event.option);
      //On randomise les résultats
      collectionGroupe.shuffle();
      emit(HomeStateInitial(collectionGroupe));
    });
  }
}
