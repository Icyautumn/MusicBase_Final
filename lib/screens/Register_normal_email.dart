import 'dart:io';

import 'package:chat_application/main.dart';
import 'package:chat_application/screens/login_form.dart';
import 'package:chat_application/services/auth_service.dart';
import 'package:chat_application/utils/kConstants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:chat_application/models/user_model.dart';
import 'package:chat_application/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class RegisterNormalEmail extends StatefulWidget {
  @override
  State<RegisterNormalEmail> createState() => _RegisterNormalEmailState();
}

class _RegisterNormalEmailState extends State<RegisterNormalEmail> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var form = GlobalKey<FormState>();
  int student_or_teacher = 0;
  String? username;
  String? email;
  String? password;
  String? confirmPassword;
  dynamic checkerUsername;
  dynamic checkerEmail;
  File? profileTempImage;
  String? textHolderEmail = "Email";
  String? textHolderPassword = "Password";
  String? textHolderCfmPassword = "Confirm Password";
  String? textHolderUsername = "Username";
  String defaultPicture =
      "https://firebasestorage.googleapis.com/v0/b/test-d9a30.appspot.com/o/2022-08-04%2011%3A58%3A29.006437_scaled_image_picker781721152304704427.png?alt=media&token=7d5bbe4a-fee7-41e6-97bf-ff4c2ecb3706";

  saveForm(context, student_or_teacher_int) async {
    var student_or_teacher;
    // if teacher
    if (student_or_teacher_int == 1) {
      student_or_teacher = 'teacher';
    }
    // if student
    else {
      student_or_teacher = 'student';
    }
    FirestoreService fsService = FirestoreService();
    bool isValid = form.currentState!.validate();
    if (isValid) {
      form.currentState!.save();
      checkerUsername = await fsService.checkUsernameUnique(username!);
      checkerEmail = await fsService.checkUsernameUnique(email!);
      AuthService authService = AuthService();
      if (checkerUsername == true && checkerEmail == true) {
        if (profileTempImage == null) {
          return authService.register(email, password).then((user) async {
            await firestore.collection('users').doc(user.user?.uid).set({
              'email': email,
              'image': defaultPicture,
              'username': username,
              'role': student_or_teacher,
              'uid': user.user!.uid,
              'date': DateTime.now(),
              'emailType': "email"
            });
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
                (route) => false);
          });
        } else {
          String? base64;
          Reference ref = FirebaseStorage.instance.ref().child(
              DateTime.now().toString() +
                  '_' +
                  basename(profileTempImage!.path));
          UploadTask uploadTask = ref.putFile(profileTempImage!);

          var imageUrl = await (await uploadTask).ref.getDownloadURL();
          setState(() {
            base64 = imageUrl.toString();
          });
          return authService.register(email, password).then((user) async {
            await firestore.collection('users').doc(user.user?.uid).set({
              'email': email,
              'image': base64,
              'username': username,
              'role': student_or_teacher,
              'uid': user.user!.uid,
              'date': DateTime.now(),
              'emailType': "email"
            });
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MyApp()),
                (route) => false);
          });
        }
      } else {
        showDialog(
            context: context,
            builder: (context) {
              // let user know to input image
              return AlertDialog(
                title: Text('Username Taken'),
                content: Text("Please input another username"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('ok'))
                ],
              );
            });
      }
    }
  }

  Future<void> pickImage(mode) {
    ImageSource chosenSource =
        mode == 0 ? ImageSource.camera : ImageSource.gallery;
    return ImagePicker()
        .pickImage(
            source: chosenSource,
            maxWidth: 600,
            imageQuality: 100,
            maxHeight: 150)
        .then((value) {
      if (value != null) {
        setState(() {
          profileTempImage = File(value.path);
        });
      }
    });
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
                    Text("Register",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    Stack(
                      children: [
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  width: 4,
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor),
                              boxShadow: [
                                BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.1),
                                    offset: Offset(0, 10))
                              ],
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: profileTempImage == null
                                      ? NetworkImage(defaultPicture)
                                      : FileImage(profileTempImage!)
                                          as ImageProvider)),
                        ),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 4,
                                  color:
                                      Theme.of(context).scaffoldBackgroundColor,
                                ),
                                color: Colors.green,
                              ),
                              child: IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    pickImage(1);
                                  });
                                },
                              ),
                            )),
                      ],
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    ToggleSwitch(
                      minWidth: 90.0,
                      cornerRadius: 20.0,
                      activeBgColors: [
                        [Colors.green[800]!],
                        [Colors.red[800]!]
                      ],
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.grey,
                      inactiveFgColor: Colors.white,
                      initialLabelIndex: student_or_teacher,
                      totalSwitches: 2,
                      labels: ['Student', 'Teacher'],
                      radiusStyle: true,
                      onToggle: (index) {
                        // if 0 equals to student
                        // if 1 equals to teacher
                        student_or_teacher = index!;
                      },
                    ),
                    Form(
                        key: form,
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: textHolderEmail,
                                  hintText: textHolderEmail,
                                  hintStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                    width: 5,
                                    color: AppColors.kDarkblack,
                                    style: BorderStyle.solid,
                                  ))),
                              autofocus: true,
                              keyboardType: TextInputType.multiline,
                              validator: (value) {
                                if (value == null) {
                                  return "Please input an email address";
                                } else if (!value.contains('@')) {
                                  return "please input a valid email address";
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                email = value;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: textHolderPassword,
                                  hintText: textHolderPassword,
                                  hintStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                    width: 5,
                                    color: AppColors.kDarkblack,
                                    style: BorderStyle.solid,
                                  ))),
                              autofocus: true,
                              keyboardType: TextInputType.multiline,
                              validator: (value) {
                                if (value == null)
                                  return 'Please provide a password.';
                                else if (value.length < 6)
                                  return 'Password must be at least 6 characters.';
                                else
                                  return null;
                              },
                              onSaved: (value) {
                                password = value;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: textHolderCfmPassword,
                                  hintText: textHolderCfmPassword,
                                  hintStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                    width: 5,
                                    color: AppColors.kDarkblack,
                                    style: BorderStyle.solid,
                                  ))),
                              autofocus: true,
                              keyboardType: TextInputType.multiline,
                              validator: (value) {
                                if (value == null)
                                  return 'Please provide a password.';
                                else if (value.length < 6)
                                  return 'Password must be at least 6 characters.';
                                else
                                  return null;
                              },
                              onSaved: (value) {
                                confirmPassword = value;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              decoration: InputDecoration(
                                  labelText: textHolderUsername,
                                  hintText: textHolderUsername,
                                  hintStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                    width: 5,
                                    color: AppColors.kDarkblack,
                                    style: BorderStyle.solid,
                                  ))),
                              autofocus: true,
                              keyboardType: TextInputType.multiline,
                              validator: (value) {
                                if (value == null || value.length == 0) {
                                  return "please provide a username";
                                } else {
                                  return null;
                                }
                              },
                              onSaved: (value) {
                                username = value;
                              },
                            ),
                            const SizedBox(height: 20),
                            const SizedBox(height: 15),
                            InkWell(
                              child: SignUpContainer(st: "Register"),
                              onTap: () {
                                saveForm(context, student_or_teacher);
                              },
                            ),
                          ],
                        )),

                    const SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      child: RichText(
                        text: RichTextSpan(
                            one: "have an account ? ", two: "Login"),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>  LoginForm()));
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
    //   resizeToAvoidBottomInset: true,
    //   appBar: AppBar(
    //     title: Text('Registration Screen'),
    //   ),
    //   body: SingleChildScrollView(
    //     child: Center(
    //       child: Column(
    //         children: <Widget>[
    //           Center(
    //             child: Stack(
    //               children: [
    //                 Container(
    //                   width: 130,
    //                   height: 130,
    //                   decoration: BoxDecoration(
    //                       border: Border.all(
    //                           width: 4,
    //                           color: Theme.of(context).scaffoldBackgroundColor),
    //                       boxShadow: [
    //                         BoxShadow(
    //                             spreadRadius: 2,
    //                             blurRadius: 10,
    //                             color: Colors.black.withOpacity(0.1),
    //                             offset: Offset(0, 10))
    //                       ],
    //                       shape: BoxShape.circle,
    //                       image: DecorationImage(
    //                           fit: BoxFit.cover,
    //                           image: profileTempImage == null
    //                               ? NetworkImage(defaultPicture)
    //                               : FileImage(profileTempImage!)
    //                                   as ImageProvider)),
    //                 ),
    //                 Positioned(
    //                     bottom: 0,
    //                     right: 0,
    //                     child: Container(
    //                       height: 45,
    //                       width: 45,
    //                       decoration: BoxDecoration(
    //                         shape: BoxShape.circle,
    //                         border: Border.all(
    //                           width: 4,
    //                           color: Theme.of(context).scaffoldBackgroundColor,
    //                         ),
    //                         color: Colors.green,
    //                       ),
    //                       child: IconButton(
    //                         icon: Icon(
    //                           Icons.edit,
    //                           color: Colors.white,
    //                         ),
    //                         onPressed: () {
    //                           setState(() {
    //                             pickImage(1);
    //                           });
    //                         },
    //                       ),
    //                     )),
    //               ],
    //             ),
    //           ),
    //           SizedBox(
    //             height: 5,
    //           ),
    //           ToggleSwitch(
    //             minWidth: 90.0,
    //             cornerRadius: 20.0,
    //             activeBgColors: [
    //               [Colors.green[800]!],
    //               [Colors.red[800]!]
    //             ],
    //             activeFgColor: Colors.white,
    //             inactiveBgColor: Colors.grey,
    //             inactiveFgColor: Colors.white,
    //             initialLabelIndex: student_or_teacher,
    //             totalSwitches: 2,
    //             labels: ['Student', 'Teacher'],
    //             radiusStyle: true,
    //             onToggle: (index) {
    //               // if 0 equals to student
    //               // if 1 equals to teacher
    //               student_or_teacher = index!;
    //             },
    //           ),
    //           Form(
    //             key: form,
    //             child: Column(
    //               children: [
    //                 Padding(
    //                   padding: const EdgeInsets.only(
    //                       top: 10.0, bottom: 5.0, left: 30.0, right: 30.0),
    //                   child: TextFormField(
    //                     decoration: InputDecoration(label: Text('Email')),
    //                     keyboardType: TextInputType.emailAddress,
    //                     validator: (value) {
    //                       if (value == null) {
    //                         return "Please input an email address";
    //                       } else if (!value.contains('@')) {
    //                         return "please input a valid email address";
    //                       } else {
    //                         return null;
    //                       }
    //                     },
    //                     onSaved: (value) {
    //                       email = value;
    //                     },
    //                   ),
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.only(
    //                       top: 10.0, bottom: 5.0, left: 30.0, right: 30.0),
    //                   child: TextFormField(
    //                     decoration: InputDecoration(label: Text('Password')),
    //                     obscureText: true,
    //                     validator: (value) {
    //                       if (value == null)
    //                         return 'Please provide a password.';
    //                       else if (value.length < 6)
    //                         return 'Password must be at least 6 characters.';
    //                       else
    //                         return null;
    //                     },
    //                     onSaved: (value) {
    //                       password = value;
    //                     },
    //                   ),
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.only(
    //                       top: 10.0, bottom: 5.0, left: 30.0, right: 30.0),
    //                   child: TextFormField(
    //                     decoration:
    //                         InputDecoration(label: Text('Confirm Password')),
    //                     obscureText: true,
    //                     validator: (value) {
    //                       if (value == null)
    //                         return 'Please provide a password.';
    //                       else if (value.length < 6)
    //                         return 'Password must be at least 6 characters.';
    //                       else
    //                         return null;
    //                     },
    //                     onSaved: (value) {
    //                       confirmPassword = value;
    //                     },
    //                   ),
    //                 ),
    //                 Padding(
    //                   padding: const EdgeInsets.only(
    //                       top: 10.0, bottom: 5.0, left: 30.0, right: 30.0),
    //                   child: TextFormField(
    //                     decoration: InputDecoration(
    //                       label: Text("username"),
    //                     ),
    //                     // check if inputted student username
    //                     validator: (value) {
    //                       if (value == null || value.length == 0) {
    //                         return "please provide a username";
    //                       } else {
    //                         return null;
    //                       }
    //                     },
    //                     onSaved: (value) {
    //                       username = value;
    //                     },
    //                   ),
    //                 ),
    //                 FlatButton(
    //                     onPressed: () => saveForm(context, student_or_teacher),
    //                     child: Text('Register'))
    //               ],
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
