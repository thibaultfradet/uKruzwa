abstract class AjoutsonorisationState {
  AjoutsonorisationState();
}

//State initial
class AjoutsonorisationStateInitial extends AjoutsonorisationState {
  AjoutsonorisationStateInitial();
}

// Tentative de création => load,success,fail
class ASSuccess extends AjoutsonorisationState {
  ASSuccess() : super();
}

class ASFailure extends AjoutsonorisationState {
  final String? erreur;
  ASFailure(this.erreur) : super();
}

class ASLoading extends AjoutsonorisationState {
  ASLoading() : super();
}
