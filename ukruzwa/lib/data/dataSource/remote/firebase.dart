import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

/* -------- AUTHENTIFICATION A FIREBASE -------- */

Future<bool> connectUser(String emailAddress, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: emailAddress, password: password);
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      return false;
    } else if (e.code == 'wrong-password') {
      return false;
    }
    return false;
  }
}

Future<bool> createUser(String emailAddress, String password) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      return false;
    } else if (e.code == 'email-already-in-use') {
      return false;
    }
    return false;
  } catch (e) {
    return false;
  }
}
