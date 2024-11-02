import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/presentation/blocs/postuler/postuler_event.dart';
import 'package:ukruzwa/presentation/blocs/postuler/postuler_state.dart';

class PostulerBloc extends Bloc<PostulerEvent, PostulerState> {
  PostulerBloc() : super(const PostulerStateInitial()) {
    //State initial
    on<PostulerEvent>((event, emit) async {
      emit(const PostulerStateInitial());
    });
  }
}
