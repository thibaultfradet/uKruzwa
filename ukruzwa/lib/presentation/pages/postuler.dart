import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/presentation/blocs/postuler/postuler_bloc.dart';
import 'package:ukruzwa/presentation/blocs/postuler/postuler_event.dart';
import 'package:ukruzwa/presentation/blocs/postuler/postuler_state.dart';

class Postuler extends StatefulWidget {
  const Postuler({super.key});

  @override
  State<Postuler> createState() => _PostulerState();
}

class _PostulerState extends State<Postuler> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => PostulerBloc()..add(PostulerEvent()),
        child: BlocBuilder<PostulerBloc, PostulerState>(
            builder: (BuildContext context, state) {
          //Page de base => on affiche toutes les informations du groupe + la possibilité de Postuler
          if (state is PostulerStateInitial) {
            return Scaffold();
          } else {
            return const Center(child: Text("Une erreur est survenue."));
          }
        }));
  }
}
