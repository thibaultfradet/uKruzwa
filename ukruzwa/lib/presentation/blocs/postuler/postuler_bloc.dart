import 'package:flutter_bloc/flutter_bloc.dart';
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

      // On créer un objet Ville pour la candidature
      emit(PostulerStateCreateStatut(isSuccess: isCreateSuccess));
    });
  }
}
