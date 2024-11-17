class AuthentificationEvent {
  AuthentificationEvent();
}

class AuthConnect extends AuthentificationEvent {
  final String emailAddress;
  final String password;
  AuthConnect(this.emailAddress, this.password) : super();
}

class AuthCreate extends AuthentificationEvent {
  final String emailAddress;
  final String password;
  final String confirmPassword;
  final String nom;
  final String prenom;
  final String numeroTelephone;
  final String codePostal;
  final String ville;
  AuthCreate(
      {required this.emailAddress,
      required this.password,
      required this.confirmPassword,
      required this.nom,
      required this.prenom,
      required this.numeroTelephone,
      required this.codePostal,
      required this.ville})
      : super();
}
