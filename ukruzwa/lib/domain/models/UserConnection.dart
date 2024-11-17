import 'package:firebase_auth/firebase_auth.dart';

class UserConnection {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserConnection();

  String getUserMail() {
    return _auth.currentUser!.email.toString();
  }

  String getUserUID() {
    return _auth.currentUser!.uid.toString();
  }
}
