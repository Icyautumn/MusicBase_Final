import 'package:chat_application/models/user_model.dart';
import 'package:chat_application/screens/add_homework_detail_screen.dart';
import 'package:chat_application/screens/add_lesson_detail_screen.dart';
import 'package:chat_application/screens/auth_screen.dart';
import 'package:chat_application/screens/edit_homework_detail_screen.dart';
import 'package:chat_application/screens/edit_lesson_detail_screen.dart';
import 'package:chat_application/screens/chat_main_screen.dart';
import 'package:chat_application/screens/metronome.dart';
import 'package:chat_application/screens/navigation.dart';
import 'package:chat_application/screens/registration.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application
  Future<Widget> userSignedIn() async {
    // sign in the user
    User? user = FirebaseAuth.instance.currentUser;
    // check if user is signed in, 
    // if user not signed in
    if (user == null) {
      return AnimatedSplashScreen(
        splash: Column(
          children: [
            Image.asset('assets/musicBase_logo.png'),
            const Text('MusicBase',
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white))
          ],
        ),
        backgroundColor: Colors.white,
        nextScreen: AuthScreen(),
        splashIconSize: 250,
        duration: 2000,
        splashTransition: SplashTransition.slideTransition,
      );
      // if user signed in talk details from users collection
    } else {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      UserModel userModel = UserModel.fromJson(userData);
      // if user has not picked a role, 
      // push register screen to the user to input details
      if (userModel.role == "null") {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: AnimatedSplashScreen(
           splash: Column(
          children: [
            Image.asset('assets/musicBase_logo.png'),
            const Text('MusicBase',
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white))
          ],
        ),
        backgroundColor: Colors.white,
        nextScreen: RegistrationScreen(userModel),
        splashIconSize: 250,
        duration: 4000,
        splashTransition: SplashTransition.slideTransition,
        
      ),
          routes: {
            EditLessonDetailScreen.routeName: (_) {
              return EditLessonDetailScreen(userModel);
            },
            AddLessonDetailScreen.routeName: (_) {
              return AddLessonDetailScreen(userModel);
            },
            AddHomeworkDetailScreen.routeName: (_) {
              return AddHomeworkDetailScreen(userModel);
            },
            EditHomeworkDetailScreen.routeName: (_) {
              return EditHomeworkDetailScreen();
            }
          },
          
        );
        // enter user to application
      } else {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: AnimatedSplashScreen(
           splash: Column(
          children: [
            Image.asset('assets/musicBase_logo.png'),
            const Text('MusicBase',
                style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white))
          ],
        ),
        backgroundColor: Colors.white,
        nextScreen: Navigation(userModel),
        splashIconSize: 250,
        duration: 4000,
        splashTransition: SplashTransition.slideTransition,
        
      ),
          routes: {
            EditLessonDetailScreen.routeName: (_) {
              return EditLessonDetailScreen(userModel);
            },
            AddLessonDetailScreen.routeName: (_) {
              return AddLessonDetailScreen(userModel);
            },
            AddHomeworkDetailScreen.routeName: (_) {
              return AddHomeworkDetailScreen(userModel);
            },
            EditHomeworkDetailScreen.routeName: (_) {
              return EditHomeworkDetailScreen();
            }
          },
          
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Music Base',
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
