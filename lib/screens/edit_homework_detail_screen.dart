import 'package:chat_application/models/homework_detail.dart';
import 'package:chat_application/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditHomeworkDetailScreen extends StatefulWidget {
  static String routeName = '/edit-homework';

  @override
  State<EditHomeworkDetailScreen> createState() => _EditHomeworkDetailScreenState();
}

class _EditHomeworkDetailScreenState extends State<EditHomeworkDetailScreen> {
  var form = GlobalKey<FormState>();
  dynamic homeworkDetail;
  String? studentUsername;
  DateTime? datePicked;


  editHomework(context, id, dateNotChanged){
    bool isValid = form.currentState!.validate();
    
    if(isValid){
      form.currentState!.save();
      FirestoreService fsService = FirestoreService();

      if(datePicked == null){
        fsService.editHomework(id, homeworkDetail, studentUsername, dateNotChanged);
      }else{
        fsService.editHomework(id, homeworkDetail, studentUsername, datePicked);
      }
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
    HomeworkDetail selectedHomeworkDetail =
        ModalRoute.of(context)?.settings.arguments as HomeworkDetail;
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
                initialValue: selectedHomeworkDetail.homeworkDetail,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "enter Homework"),
                autofocus: true,
                textAlign: TextAlign.center,
                onSaved: (newText) {
                  homeworkDetail = newText;
                },
              ), 
              TextFormField(
                initialValue: selectedHomeworkDetail.studentUsername,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "enter student Username"),
                autofocus: true,
                textAlign: TextAlign.center,
                onSaved: (newText) {
                  studentUsername = newText;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(datePicked == null? "Picked date: " +
                          DateFormat('dd/MM/yyyy').format(selectedHomeworkDetail.dueDate) :
                          "Picked date: " +
                          DateFormat('dd/MM/yyyy').format(datePicked!),),
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
                  'Edit',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                color: Colors.lightBlueAccent,
                onPressed: () {
                  editHomework(context, selectedHomeworkDetail.id, selectedHomeworkDetail.dueDate);
                },
              ),
            ],
          ),
              ),
        ),
    )
    );
  }
}