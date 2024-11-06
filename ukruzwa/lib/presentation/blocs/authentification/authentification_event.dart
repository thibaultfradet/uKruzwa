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
  AuthCreate(this.emailAddress, this.password) : super();
}

class ToggleAuthMode extends AuthentificationEvent {
  ToggleAuthMode() : super();
}
