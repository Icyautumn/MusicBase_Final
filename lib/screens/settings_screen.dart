import 'dart:io';
import 'package:path/path.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_application/main.dart';
import 'package:chat_application/models/user_model.dart';
import 'package:chat_application/screens/auth_screen.dart';
import 'package:chat_application/screens/in_app_browser.dart';
import 'package:chat_application/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SettingScreen extends StatefulWidget {
  UserModel user;
  SettingScreen(this.user);

  @override
  State<SettingScreen> createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var form = GlobalKey<FormState>();
  String? newUsername;
  dynamic checker = false;
  File? profileTempImage;
  

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
      if(profileTempImage == null){
        
        await firestore.collection('users').doc(widget.user.uid).update({
          'role': student_or_teacher,
        });
      }else{
        String? base64;
      Reference ref =
            FirebaseStorage.instance.ref().child(DateTime.now().toString() + '_' + basename(profileTempImage!.path));
        UploadTask uploadTask = ref.putFile(profileTempImage!);

        var imageUrl = await (await uploadTask).ref.getDownloadURL();
        setState(() {
          base64 = imageUrl.toString();
        });
        await firestore.collection('users').doc(widget.user.uid).update({
          'role': student_or_teacher,
          'image' : base64,
        });
      }
      
      

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Role changed successfully'),
        ));
        
        Navigator.pushAndRemoveUntil(
  			context,
  			MaterialPageRoute(builder: (context) => MyApp()), // this mymainpage is your page to refresh
  			(Route<dynamic> route) => false,
		);
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
    int student_or_teacher = widget.user.role == 'teacher' ? 1 : 0;
    return Scaffold(
        appBar: AppBar(
          title: Text("Setting Screen"),
          centerTitle: true,
          backgroundColor: Colors.teal,
          actions: [
            IconButton(
                onPressed: () async {
                  await GoogleSignIn().signOut();
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => AuthScreen()),
                      (route) => false);
                },
                icon: Icon(Icons.logout))
          ],
        ),
        body: Container(
            child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                        border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor),
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
                            image: profileTempImage == null? NetworkImage(widget.user.image): FileImage(profileTempImage!) as ImageProvider)),
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
                            color: Theme.of(context).scaffoldBackgroundColor,
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
            ),
            SizedBox(
              height: 20,
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
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: TextFormField(
                      enabled: false,
                      initialValue: widget.user.username,
                      decoration: InputDecoration(
                        label: Text("username"),
                      ),
                      // check if inputted student username
                      validator: (value) {
                        if (value == null || value.length == 0) {
                          return "please provide a username";
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        newUsername = value!;
                      },
                    ),
                  ),
                  FlatButton(
                      onPressed: () => saveForm(context, student_or_teacher),
                      child: Text('Save'))
                ],
              ),
            ),
          ],
        )));
  }
}
