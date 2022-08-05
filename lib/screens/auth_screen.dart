import 'package:chat_application/main.dart';
import 'package:chat_application/screens/Register_normal_email.dart';
import 'package:chat_application/screens/login_form.dart';
import 'package:chat_application/utils/kConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future signInFunction() async {
    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      return;
    }
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    DocumentSnapshot userExist =
        await firestore.collection('users').doc(userCredential.user!.uid).get();

    if (userExist.exists) {
    } else {
      await firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': userCredential.user!.email,
        'image': userCredential.user!.photoURL,
        'username': 'null',
        'role': 'null',
        'uid': userCredential.user!.uid,
        'date': DateTime.now(),
        'emailType': "google"
      });
    }

    Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context) => MyApp()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 13),
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text("Welcome",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        )),
                    const SizedBox(
                      height: 8,
                    ),
                    Text("Please login or sign up to continue using our app.",
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        )),
                    const SizedBox(
                      height: 30,
                    ),
                    Image.asset("assets/musicBase_logo.png"),
                    const SizedBox(
                      height: 50,
                    ),
                    Text("Enter via social networks",
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        )),
                    const SizedBox(
                      height: 30,
                    ),

                    ElevatedButton(
                      onPressed: () async {
                        await signInFunction();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            'https://www.freepnglogos.com/uploads/google-logo-png/google-logo-png-webinar-optimizing-for-success-google-business-webinar-13.png',
                            height: 36,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Sign in With Google",
                            style: TextStyle(fontSize: 20),
                          )
                        ],
                      ),
                       style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black),
                    padding: MaterialStateProperty.all(
                        EdgeInsets.symmetric(vertical: 12))),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text("or login with email",
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      child: SignUpContainer(st: "Login"),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => LoginForm()));
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      child: SignUpContainer(st: "Sign Up"),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RegisterNormalEmail()));
                      },
                    ),
                    //Text("data"),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // return Scaffold(
    //     body: Center(
    //   child: Column(children: [
    //     Expanded(
    //       child: Container(
    //         decoration: BoxDecoration(
    //             image: DecorationImage(
    //                 image: AssetImage("assets/musicBase_logo.png"))),
    //       ),
    //     ),
    //     Padding(
    //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    //       child: Column(
    //         children: [
    //           ElevatedButton(
    //             onPressed: () {
    //               Navigator.push(context, MaterialPageRoute(builder: (context) => LoginForm()));
    //             },
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 Text(
    //                   "Login",
    //                   style: TextStyle(fontSize: 20),
    //                 )
    //               ],
    //             ),
    //             style: ButtonStyle(
    //                 backgroundColor: MaterialStateProperty.all(Colors.blue.shade300),
    //                 padding: MaterialStateProperty.all(
    //                     EdgeInsets.symmetric(vertical: 12))),
    //           ),
    //           ElevatedButton(
    //             onPressed: () {
    //               Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterNormalEmail()));
    //             },
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 Text(
    //                   "Register",
    //                   style: TextStyle(fontSize: 20),
    //                 )
    //               ],
    //             ),
    //             style: ButtonStyle(
    //                 backgroundColor: MaterialStateProperty.all(Colors.blue.shade300),
    //                 padding: MaterialStateProperty.all(
    //                     EdgeInsets.symmetric(vertical: 12))),
    //           ),
    //           ElevatedButton(
    //             onPressed: () async {
    //               await signInFunction();
    //             },
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 Image.network(
    //                   'https://www.freepnglogos.com/uploads/google-logo-png/google-logo-png-webinar-optimizing-for-success-google-business-webinar-13.png',
    //                   height: 36,
    //                 ),
    //                 SizedBox(
    //                   width: 10,
    //                 ),
    //                 Text(
    //                   "Sign in With Google",
    //                   style: TextStyle(fontSize: 20),
    //                 )
    //               ],
    //             ),
    //             style: ButtonStyle(
    //                 backgroundColor: MaterialStateProperty.all(Colors.black),
    //                 padding: MaterialStateProperty.all(
    //                     EdgeInsets.symmetric(vertical: 12))),
    //           ),
    //         ],
    //       ),
    //     )
    //   ]),
    // ));
  }
}
