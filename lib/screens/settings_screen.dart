import 'package:chat_application/models/user_model.dart';
import 'package:chat_application/screens/auth_screen.dart';
import 'package:chat_application/screens/in_app_browser.dart';
import 'package:chat_application/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
      if(newUsername != widget.user.username){
        checker = await fsService.checkUsernameUnique(newUsername!);
      }  
      
      if (checker == true) {
        await firestore.collection('users').doc(widget.user.uid).update({
        'username' : newUsername,
        'role': student_or_teacher,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Profile username and role changed successfully'),
    ));
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
    int student_or_teacher =  widget.user.role == 'teacher' ? 1 : 0 ;
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
              SizedBox(height: 20,),
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
                      onPressed: () =>saveForm(context, student_or_teacher),
                      child: Text('Save'))
                ],
              ),
            ),
              TextButton(
        onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => InAppBrowser())));
        },
        child: Center(child: Text("Google Profile settings")),
      ),
            ],
          )),
    );
  }
}
