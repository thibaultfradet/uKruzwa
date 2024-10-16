import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/presentation/blocs/home/home_bloc.dart';
import 'package:ukruzwa/presentation/blocs/home/home_state.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc,HomeState>(
      builder: (BuildContext context, state) {
        
        return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Text("non")
          ),
        );
      
      }
    );
  }
}