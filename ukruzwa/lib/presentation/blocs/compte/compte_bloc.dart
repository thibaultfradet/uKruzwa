import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/data/dataSource/remote/firebase.dart';
import 'package:ukruzwa/domain/models/Groupe.dart';
import 'package:ukruzwa/presentation/blocs/compte/compte_event.dart';
import 'package:ukruzwa/presentation/blocs/compte/compte_state.dart';

class CompteBloc extends Bloc<CompteEvent, CompteState> {
  CompteBloc() : super(CompteStateInitial([])) {
    // État initial
    on<CompteEvent>((event, emit) async {
      //on emit un state de chargement en attendant les données
      emit(const CompteStateLoading());

      final FirebaseAuth auth = FirebaseAuth.instance;
      List<Groupe> groupeDuCompte =
          await findAllGroupeCompte(auth.currentUser!.email!);
      emit(CompteStateInitial(groupeDuCompte));
    });
  }
}
