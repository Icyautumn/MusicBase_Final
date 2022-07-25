import 'package:chat_application/models/user_model.dart';
import 'package:chat_application/screens/add_homework_detail_screen.dart';
import 'package:chat_application/screens/add_lesson_detail_screen.dart';
import 'package:chat_application/screens/auth_screen.dart';
import 'package:chat_application/screens/edit_homework_detail_screen.dart';
import 'package:chat_application/screens/edit_lesson_detail_screen.dart';
import 'package:chat_application/screens/home_screen.dart';
import 'package:chat_application/screens/navigation.dart';
import 'package:chat_application/screens/registration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  Future<Widget> userSignedIn() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      UserModel userModel = UserModel.fromJson(userData);
      if (userModel.role == "null") {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: RegistrationScreen(userModel),
          routes: {
            EditLessonDetailScreen.routeName: (_) {
              return EditLessonDetailScreen();
            },
            AddLessonDetailScreen.routeName: (_) {
              return AddLessonDetailScreen();
            },
            AddHomeworkDetailScreen.routeName: (_) {
              return AddHomeworkDetailScreen();
            },
            EditHomeworkDetailScreen.routeName: (_) {
              return EditHomeworkDetailScreen();
            }
          },
        );
      } else {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Navigation(userModel),
          routes: {
            EditLessonDetailScreen.routeName: (_) {
              return EditLessonDetailScreen();
            },
            AddLessonDetailScreen.routeName: (_) {
              return AddLessonDetailScreen();
            },
            AddHomeworkDetailScreen.routeName: (_) {
              return AddHomeworkDetailScreen();
            },
            EditHomeworkDetailScreen.routeName: (_) {
              return EditHomeworkDetailScreen();
            }
          },
        );
      }
    } else {
      return AuthScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
            future: userSignedIn(),
            builder: (context, AsyncSnapshot<Widget> snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!;
              }
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }));
  }
}
