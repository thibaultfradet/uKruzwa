import 'package:ukruzwa/domain/models/Groupe.dart';

abstract class HomeState {
  const HomeState();
}

class HomeStateLoading extends HomeState {
  HomeStateLoading() : super();
}

class HomeStateInitial extends HomeState {
  List<Groupe> collectionGroupe = [];
  HomeStateInitial(this.collectionGroupe) : super();
}
