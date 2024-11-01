import 'package:ukruzwa/presentation/blocs/grdetail/grdetail_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/presentation/blocs/grdetail/grdetail_state.dart';

class GrdetailBloc extends Bloc<GrdetailEvent, GrdetailState> {
  GrdetailBloc() : super(const GrdetailStateInitial()) {
    //State initial
    on<GrdetailEvent>((event, emit) async {
      emit(GrdetailStateInitial());
    });
  }
}
