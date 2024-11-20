import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/domain/models/groupe.dart';
import 'package:ukruzwa/presentation/blocs/compte/compte_event.dart';
import 'package:ukruzwa/presentation/blocs/compte/compte_state.dart';
import 'package:ukruzwa/utils/constants/current_user.dart';

class CompteBloc extends Bloc<CompteEvent, CompteState> {
  CompteBloc() : super(CompteStateInitial([])) {
    // État initial
    on<CompteEvent>((event, emit) async {
      //on emit un state de chargement en attendant les données
      emit(const CompteStateLoading());

      List<Groupe> groupeDuCompte = await Groupe.empty()
          .findAllGroupeCompte(CurrentUser.getUserCurrent.email!);
      emit(CompteStateInitial(groupeDuCompte));
    });

    //L'utilisateur clique sur supprimer un groupe
    on<UserDeleteGroupe>((event, emit) async {
      // on supprime le groupe concerner de la bdd
      Groupe.empty().deleteGroupe(event.idGroupe);

      //récupération nouvelle liste et on emit => toujours en se basant sur le mail de l'utilisateur connecter

      List<Groupe> groupeDuCompteNew = await Groupe.empty()
          .findAllGroupeCompte(CurrentUser.getUserCurrent.email!);
      emit(CompteStateInitial(groupeDuCompteNew));
    });
  }
}
