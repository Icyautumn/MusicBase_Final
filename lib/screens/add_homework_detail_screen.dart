import 'package:chat_application/models/user_model.dart';
import 'package:chat_application/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddHomeworkDetailScreen extends StatefulWidget {
  static String routeName = '/add-homework';
  UserModel user;
  AddHomeworkDetailScreen(this.user);

  @override
  State<AddHomeworkDetailScreen> createState() =>
      _AddHomeworkDetailScreenState();
}

class _AddHomeworkDetailScreenState extends State<AddHomeworkDetailScreen> {
  var form = GlobalKey<FormState>();
  dynamic homeworkDetail;
  String? studentUsername;
  DateTime? datePicked = DateTime.now();

  addHomework(context) {
    bool isValid = form.currentState!.validate();

    if (isValid) {
      form.currentState!.save();

      FirestoreService fsService = FirestoreService();

      fsService.addHomeworkScreen(
          homeworkDetail, studentUsername, datePicked, widget.user.username);
    }

    // Hide the keyboard
    FocusScope.of(context).unfocus();

    // Resets the form
    form.currentState!.reset();
    datePicked = null;

    // Shows a SnackBar
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Homework added successfully!'),
    ));
    Navigator.of(context).pop();
  }

  void presentDatePick(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 14)),
      lastDate: DateTime.now().add(Duration(days: 365)),
    ).then((value) {
      if (value == null) {
        return;
      } else {
        setState(() {
          datePicked = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Homework'),
        ),
        body: Container(
          color: Color(0xff757575),
          child: Form(
            key: form,
            child: Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "enter Homework"),
                    autofocus: true,
                    textAlign: TextAlign.center,
                    validator: (newText) {
                      if (newText == null || newText.length == 0) {
                        return;
                      } else {
                        homeworkDetail = newText;
                      }
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "enter student Username"),
                    autofocus: true,
                    textAlign: TextAlign.center,
                    validator: (newText) {
                      if (newText == null || newText.length == 0) {
                        return "please enter student name";
                      } else {
                        studentUsername = newText;
                      }
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(datePicked == null
                          ? 'No Date Chosen'
                          : "Picked date: " +
                              DateFormat('yyyy-MM-dd').format(datePicked!)),
                      TextButton(
                          child: Text('Choose Date',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          onPressed: () {
                            presentDatePick(context);
                          })
                    ],
                  ),
                  FlatButton(
                    child: Text(
                      'Add',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    color: Colors.lightBlueAccent,
                    onPressed: () {
                      addHomework(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
