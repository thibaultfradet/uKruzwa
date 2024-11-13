import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/data/dataSource/remote/firebase.dart';
import 'package:ukruzwa/domain/models/Instrument.dart';
import 'package:ukruzwa/domain/models/Personne.dart';
import 'package:ukruzwa/domain/models/Style.dart';
import 'package:ukruzwa/domain/models/Ville.dart';
import 'package:ukruzwa/presentation/blocs/postuler/postuler_event.dart';
import 'package:ukruzwa/presentation/blocs/postuler/postuler_state.dart';

class PostulerBloc extends Bloc<PostulerEvent, PostulerState> {
  PostulerBloc() : super(const PostulerStateInitial()) {
    //State/Event initial
    on<PostulerEvent>((event, emit) async {
      emit(const PostulerStateInitial());
    });

    //Event ajout du postulat
    on<PostulerEventUtilisateurValider>((event, emit) async {
      bool isCreateSuccess = false;

      emit(PostulerStateCreateStatut(isSuccess: isCreateSuccess));
    });
  }
}
