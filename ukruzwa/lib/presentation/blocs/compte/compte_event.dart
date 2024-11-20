class CompteEvent {
  CompteEvent();
}

class UserDeleteGroupe extends CompteEvent {
  final String idGroupe;
  UserDeleteGroupe(this.idGroupe);
}
