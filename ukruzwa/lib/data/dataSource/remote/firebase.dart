import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/* -------- AUTHENTIFICATION A FIREBASE -------- */

/* connectUser qui prend en paramètre une adresse mail et un mot de passe et retourne le résultat de la connexion sous form d'un booleen */
Future<bool> connectUser(String emailAddress, String password) async {
  try {
    final credential = await FirebaseAuth.instance
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

/* Fonction createUser qui prend en paramètre une adresse mail et un mot de passe et retourne le statut de la tentative de création */
Future<bool> createUser(String emailAddress, String password) async {
  try {
    final credential =
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

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}

Future<bool> emailAlreadyInDatabase(String email) async {
  FirebaseFirestore db = FirebaseFirestore.instance;
  // On récupère le contenu de la collection groupe
  QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await db.collection("Personnes").where("Mail", isEqualTo: email).get();
  return querySnapshot.docs.isNotEmpty ? true : false;
}
