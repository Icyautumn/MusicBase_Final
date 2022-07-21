import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<UserCredential> register(email, password) {
    return FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> login(email, password) {
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  Stream<User?> getAuthUser() {
    return FirebaseAuth.instance.authStateChanges();
  }

  logOut() {
    return FirebaseAuth.instance.signOut();
  }

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }
}