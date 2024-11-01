abstract class AuthentificationState {
  const AuthentificationState();
}

// Par défaut on affiche la connexion donc le state "initial" est en fait la connexion
class AuthentificationStateInitial extends AuthentificationState {
  const AuthentificationStateInitial() : super();
}

class AuthentificationStateConnectSuccess extends AuthentificationState {
  AuthentificationStateConnectSuccess() : super();
}

class AuthentificationStateConnectFailure extends AuthentificationState {
  AuthentificationStateConnectFailure() : super();
}

class AuthentificationStateCreate extends AuthentificationState {
  AuthentificationStateCreate() : super();
}

class AuthentificationStateCreateSuccess extends AuthentificationState {
  AuthentificationStateCreateSuccess() : super();
}

class AuthentificationStateCreateFailure extends AuthentificationState {
  AuthentificationStateCreateFailure() : super();
}
