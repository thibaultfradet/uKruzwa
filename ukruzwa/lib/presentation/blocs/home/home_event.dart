class HomeEvent {
  HomeEvent();
}

class HomeEventUtilisateurRecherche extends HomeEvent {
  final String libelle;
  final String option;
  HomeEventUtilisateurRecherche(this.libelle, this.option);
}
