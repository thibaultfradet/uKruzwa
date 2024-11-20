import 'package:firebase_auth/firebase_auth.dart';

class CurrentUser {
  static late User user;

  static init() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    user = auth.currentUser!;
  }

  static User get getUserCurrent => user;
}
