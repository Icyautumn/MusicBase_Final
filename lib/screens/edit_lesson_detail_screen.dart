import 'dart:io';
import 'package:chat_application/models/lesson_detail.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:chat_application/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';

class EditLessonDetailScreen extends StatefulWidget {
  static String routeName = '/edit-lesson';

  @override
  State<EditLessonDetailScreen> createState() => _EditLessonDetailScreenState();
}

class _EditLessonDetailScreenState extends State<EditLessonDetailScreen> {
  var form = GlobalKey<FormState>();

  String? lessonType;
  String? lessonDetail;
  DateTime? dateCreated;

  String? studentEmail;
  String? lessonImages;
  File? lessonImageTemp;

  void saveForm(String id, context, imageNotChanged, dateNotChanged) {
    bool isValid = form.currentState!.validate();
    if (dateCreated == null) dateCreated = DateTime.now();

    if (isValid) {
      form.currentState!.save();

      if (dateCreated == null) {
        dateCreated == dateNotChanged;
      }

      //using firestore services
      FirestoreService fsService = FirestoreService();
      if (lessonImageTemp != null) {
        FirebaseStorage.instance
            .ref()
            .child(DateTime.now().toString() +
                '_' +
                basename(lessonImageTemp!.path))
            .putFile(lessonImageTemp!)
            .then(
              (task) => task.ref.getDownloadURL().then(
                (lessonImage) {
                  fsService.editLesson(id, dateCreated, lessonType,
                      studentEmail, lessonImage, lessonDetail);
                  Navigator.of(context).pop();
                },
              ),
            );
      } else {
        fsService.editLesson(id, dateCreated, lessonType, studentEmail,
            imageNotChanged, lessonDetail);
      }

      // Hide the keyboard
      FocusScope.of(context).unfocus();

      // Resets the form
      form.currentState!.reset();
      dateCreated = null;

      // Shows a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Lesson Created'),
      ));
      Navigator.of(context).pop();
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
          lessonImageTemp = File(value.path);
        });
      }
    });
  }

  void presentDatePicker(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 14)),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) return;
      setState(() {
        dateCreated = value;
        print(dateCreated);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    LessonDetail selectedLessonDetail =
        ModalRoute.of(context)?.settings.arguments as LessonDetail;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Expense'),
        actions: [
          IconButton(
              onPressed: () => saveForm(
                  selectedLessonDetail.id,
                  context,
                  selectedLessonDetail.lessonImages!,
                  selectedLessonDetail.dateCreated),
              icon: Icon(Icons.save))
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: form,
          child: Column(
            children: [
              DropdownButtonFormField(
                decoration: InputDecoration(
                  label: Text('Lesson Type'),
                ),
                items: [
                  DropdownMenuItem(child: Text('Drum'), value: 'Drum'),
                  DropdownMenuItem(child: Text('Piano'), value: 'Piano'),
                  DropdownMenuItem(child: Text('Violin'), value: 'Violin'),
                  DropdownMenuItem(child: Text('Flute'), value: 'Flute'),
                ],
                value: selectedLessonDetail.lessonType,
                validator: (value) {
                  if (value == null)
                    return "Please provide type of lesson";
                  else
                    return null;
                },
                onChanged: (value) {
                  lessonType = value as String;
                },
                onSaved: (value) {
                  lessonType = value as String;
                },
              ),
              TextFormField(
                initialValue: selectedLessonDetail.lessonDetail,
                decoration: InputDecoration(label: Text('lesson Details')),
                validator: (value) {
                  if (value == null)
                    return "Please provide lesson Details.";
                  else
                    return null;
                },
                onSaved: (value) {
                  lessonDetail = value;
                },
              ),
              TextFormField(
                initialValue: selectedLessonDetail.studentEmail,
                decoration: InputDecoration(label: Text('StudentEmail')),
                validator: (value) {
                  if (value == null)
                    return 'Please provide a purpose.';
                  else
                    return null;
                },
                onSaved: (value) {
                  studentEmail = value;
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(dateCreated == null
                      ? "Picked date: " +
                          DateFormat('dd/MM/yyyy')
                              .format(selectedLessonDetail.dateCreated!)
                      : "Picked date: " +
                          DateFormat('dd/MM/yyyy').format(dateCreated!)),
                  TextButton(
                      child: Text('Choose Date',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      onPressed: () {
                        presentDatePicker(context);
                      })
                ],
              ),
              SizedBox(height: 20),
              Column(
                children: [
                  Container(
                    width: 180,
                    height: 300,
                    decoration: BoxDecoration(color: Colors.grey),
                    child: selectedLessonDetail.lessonImages != null
                        ? FittedBox(
                            fit: BoxFit.fill,
                            child: lessonImageTemp == null
                                ? Image.network(
                                    selectedLessonDetail.lessonImages!)
                                : Image.file(lessonImageTemp!))
                        : Center(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton.icon(
                        icon: Icon(Icons.camera_alt),
                        onPressed: () => pickImage(0),
                        label: Text('Take Photo'),
                      ),
                      TextButton.icon(
                        icon: Icon(Icons.image),
                        onPressed: () => pickImage(1),
                        label: Text('Add Image'),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
