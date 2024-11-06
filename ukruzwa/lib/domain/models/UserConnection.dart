import 'package:firebase_auth/firebase_auth.dart';

class UserConnection {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Méthode pour obtenir l'utilisateur actuel
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Méthode pour se connecter avec email et mot de passe
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return userCredential.user;
    } catch (e) {
      print("Erreur de connexion : $e");
      return null;
    }
  }

  // Méthode pour se déconnecter
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
