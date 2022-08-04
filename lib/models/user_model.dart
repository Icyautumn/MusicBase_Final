import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String email;
  String image;
  Timestamp date;
  String uid;
  String username;
  String role;
  String emailType;

  UserModel(
      {required this.email,
      required this.image,
      required this.date,
      required this.uid,
      required this.username,
      required this.role,
      required this.emailType});

  factory UserModel.fromJson(DocumentSnapshot snapshot) {
    return UserModel(
      email: snapshot['email'] ?? '',
      image: snapshot['image']?? '',
      date: snapshot['date']?? '',
      uid: snapshot['uid']?? '',
      username: snapshot['username']?? '',
      role: snapshot['role']?? '',
      emailType: snapshot['emailType']?? '',
    );
  }
}
