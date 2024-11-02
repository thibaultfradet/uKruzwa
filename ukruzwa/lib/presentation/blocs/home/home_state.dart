import 'package:ukruzwa/domain/Groupe.dart';

abstract class HomeState {
  const HomeState();
}

class HomeStateInitial extends HomeState {
  List<Groupe> collectionGroupe = [];
  HomeStateInitial(this.collectionGroupe) : super();
}
