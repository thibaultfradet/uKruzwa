abstract class AjoutSalleSpState {
  AjoutSalleSpState();
}

//State initial
class AjoutSalleSpStateInitial extends AjoutSalleSpState {
  AjoutSalleSpStateInitial();
}

// Tentative de création => load,success,fail
class ASPSuccess extends AjoutSalleSpState {
  ASPSuccess() : super();
}

class ASPFailure extends AjoutSalleSpState {
  ASPFailure() : super();
}

class ASPLoading extends AjoutSalleSpState {
  ASPLoading() : super();
}
