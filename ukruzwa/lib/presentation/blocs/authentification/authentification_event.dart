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
  final String EmailAddress;
  final String Password;
  AuthentificationConnectUser(this.EmailAddress, this.Password) : super();
}

class AuthentificationCreateUser extends AuthentificationEvent {
  final String EmailAddress;
  final String Password;
  AuthentificationCreateUser(this.EmailAddress, this.Password) : super();
}
