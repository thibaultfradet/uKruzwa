import 'package:flutter/material.dart';
import 'package:ukruzwa/firebase_options.dart';
import 'package:ukruzwa/presentation/blocs/authentification/authentification_bloc.dart';
import 'package:ukruzwa/presentation/pages/authentification.dart';
import 'package:ukruzwa/presentation/pages/authentification.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ukruzwa/presentation/blocs/home/home_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options:DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MultiBlocProvider(providers: [
    BlocProvider<AuthentificationBloc>(create: (_) => AuthentificationBloc()),
    BlocProvider<HomeBloc>(create: (_) => HomeBloc())
  ], child: const MyApp(),
  ),
);
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'ukruzwa',
      home: Authentification(),
    );
  }
}