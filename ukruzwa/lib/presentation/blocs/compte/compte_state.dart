import 'package:ukruzwa/domain/models/groupe.dart';

abstract class CompteState {
  const CompteState();
}

class CompteStateInitial extends CompteState {
  final List<Groupe> groupeDuCompte;
  CompteStateInitial(this.groupeDuCompte) : super();
}

class CompteStateLoading extends CompteState {
  const CompteStateLoading();
}
