import 'dart:io';

import 'package:chat_application/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:chat_application/models/user_model.dart';
import 'package:chat_application/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class RegistrationScreen extends StatefulWidget {
  UserModel user;
  RegistrationScreen(this.user);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var form = GlobalKey<FormState>();
  int student_or_teacher = 0;
  String? username;
  dynamic checker;
  File? profileTempImage;

  saveForm(context, student_or_teacher_int) async {
    var student_or_teacher;
    // if teacher
    if(student_or_teacher_int == 1){
      student_or_teacher = 'teacher';
    }
    // if student 
    else{
      student_or_teacher = 'student';
    }
    FirestoreService fsService = FirestoreService();
    bool isValid = form.currentState!.validate();
    if (isValid) {
      form.currentState!.save();
      checker = await fsService.checkUsernameUnique(username!);
      if (checker == true) {
        if(profileTempImage == null){
          await firestore.collection('users').doc(widget.user.uid).update({
        'username' : username,
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
          'username' : username,
          'role': student_or_teacher,
          'image' : base64,
        });
        }
        
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>MyApp()), (route) => false);
      } else {
        showDialog(
          context: context, 
          builder: (context) {
            // let user know to input image
            return AlertDialog(
              title: Text('Username Taken'),
              content: Text("Please input another username"),
              actions: [
                TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text('ok'))
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Screen'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
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
                        username = value;
                      },
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () =>saveForm(context, student_or_teacher),
                      child: Text('Register'))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
