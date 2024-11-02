class AuthentificationEvent {
  AuthentificationEvent();
}

class AuthentificationShowConnect extends AuthentificationEvent {
  AuthentificationShowConnect() : super();
}

class AuthentificationShowCreate extends AuthentificationEvent {
  AuthentificationShowCreate() : super();
}

class AuthentificationConnectUser extends AuthentificationEvent {
  final String emailAddress;
  final String password;
  AuthentificationConnectUser(this.emailAddress, this.password) : super();
}

class AuthentificationCreateUser extends AuthentificationEvent {
  final String emailAddress;
  final String password;
  AuthentificationCreateUser(this.emailAddress, this.password) : super();
}
