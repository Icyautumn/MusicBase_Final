import 'dart:io';

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
  var form = GlobalKey<FormState>();
  late List<bool> isSelected;
  String? Username;
  dynamic checker;

  saveForm(context) async {
    FirestoreService fsService = FirestoreService();
    bool isValid = form.currentState!.validate();
    if (isValid) {
      form.currentState!.save();
      checker = await fsService.checkUsernameUnique(Username!);
      if(checker == true){
        print("username not taken");
      } else{
        print("username is taken");
      }
    }
    
  }
  @override
  void initState() {
    isSelected = [true, false];
    super.initState();
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
            ToggleButtons(
              borderColor: Colors.black,
              fillColor: Colors.grey,
              borderWidth: 2,
              selectedBorderColor: Colors.black,
              selectedColor: Colors.white,
              borderRadius: BorderRadius.circular(0),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Student',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Teacher',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
              onPressed: (int index) {
                setState(() {
                  for (int i = 0; i < isSelected.length; i++) {
                    isSelected[i] = i == index;
                  }
                  print(isSelected);
                });
              },
              isSelected: isSelected,
            ),
            Form(
              key: form,
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: TextFormField(
                  decoration: InputDecoration(label: Text("Username"), suffixIcon: IconButton(
                  onPressed: () => {saveForm(context)},
                  icon: Icon(Icons.check_circle_outline),splashColor: Colors.green)),
                  // check if inputted student username
                  validator: (value) {
                    if (value == null || value.length == 0) {
                      return "please provide a username";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    Username = value;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
