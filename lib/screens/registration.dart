import 'package:chat_application/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:chat_application/models/user_model.dart';
import 'package:chat_application/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
        await firestore.collection('users').doc(widget.user.uid).update({
        'username' : username,
        'role': student_or_teacher,
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToggleButtons'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                        "assets/musicBase_logo.png"))),
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
                  FlatButton(
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
