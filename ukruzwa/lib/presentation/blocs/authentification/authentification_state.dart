abstract class AuthentificationState {
  const AuthentificationState();
}

// Par défaut on affiche la connexion donc le state "initial" est en fait la connexion
class AuthStateInitial extends AuthentificationState {
  const AuthStateInitial() : super();
}

class AuthLoading extends AuthentificationState {
  const AuthLoading() : super();
}

class AuthSuccess extends AuthentificationState {
  final bool isLoginMode;
  const AuthSuccess({required this.isLoginMode}) : super();
}

class AuthFailure extends AuthentificationState {
  final String error;

  AuthFailure(this.error);
}

class AuthModeToggle extends AuthentificationState {
  final bool isLoginMode;
  AuthModeToggle(this.isLoginMode);
}
