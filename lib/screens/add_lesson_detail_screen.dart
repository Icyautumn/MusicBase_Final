import 'dart:io';
import 'package:chat_application/models/user_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:chat_application/services/firestore_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AddLessonDetailScreen extends StatefulWidget {
  static String routeName = '/add-lesson';
  UserModel user;
  AddLessonDetailScreen(this.user);

  @override
  State<AddLessonDetailScreen> createState() => _AddLessonDetailScreenState();
}

class _AddLessonDetailScreenState extends State<AddLessonDetailScreen> {
  var form = GlobalKey<FormState>();
  String? lessonType;
  String? lessonDetail;
  DateTime? dateCreated = DateTime.now();

  String? studentUsername;
  File? lessonPhoto;

  void saveForm(context) async {
    bool isValid = form.currentState!.validate();
    if (dateCreated == null) {
      dateCreated = DateTime.now();
    }
    if (isValid) {
      form.currentState!.save();
      //using firestore services
      FirestoreService fsService = FirestoreService();
      // check if user input lessonPhoto
      if (lessonPhoto == null) {
        showDialog(
            context: context,
            builder: (context) {
              // let user know to input image
              return AlertDialog(
                title: Text('missing image'),
                content: Text("Please add an image"),
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
      // store photo the user inputted as base 64 string
      else {
        String? base64;
        Reference ref = FirebaseStorage.instance.ref().child(
            DateTime.now().toString() + '_' + basename(lessonPhoto!.path));
        UploadTask uploadTask = ref.putFile(lessonPhoto!);

        var imageUrl = await (await uploadTask).ref.getDownloadURL();
        setState(() {
          base64 = imageUrl.toString();
        });

        fsService.addLessonScreen(lessonType, lessonDetail, base64, dateCreated,
            studentUsername, widget.user.username);

        // Hide the keyboard
        FocusScope.of(context).unfocus();

        // Resets the form
        form.currentState!.reset();
        dateCreated = null;

        // Shows a SnackBar
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Lesson detail added successfully!'),
        ));
        Navigator.of(context).pop();
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
          lessonPhoto = File(value.path);
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
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Lesson Details'),
        actions: [
          IconButton(onPressed: () => saveForm(context), icon: Icon(Icons.save))
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Form(
            key: form,
            child: Column(
              children: [
                DropdownButtonFormField(
                  decoration: InputDecoration(
                    label: Text('Type of Lesson'),
                  ),
                  items: [
                    DropdownMenuItem(child: Text('Drum'), value: 'Drum'),
                    DropdownMenuItem(child: Text('Piano'), value: 'Piano'),
                    DropdownMenuItem(child: Text('Violin'), value: 'Violin'),
                    DropdownMenuItem(child: Text('Flute'), value: 'Flute'),
                  ],
                  validator: (value) {
                    if (value == null)
                      return "Please provide type of lesson";
                    else
                      return null;
                  },
                  onChanged: (value) {
                    lessonType = value as String;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(label: Text('Lesson Details')),
                  validator: (value) {
                    if (value == null || value.length == 0)
                      return "Please provide lesson Details.";
                    else
                      return null;
                  },
                  onSaved: (value) {
                    lessonDetail = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(label: Text('studentUsername')),
                  validator: (value) {
                    if (value == null || value.length == 0)
                      return 'Please provide student Username';
                    else
                      return null;
                  },
                  onSaved: (value) {
                    studentUsername = value;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(dateCreated == null
                        ? 'No Date Chosen'
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
                      child: lessonPhoto != null
                          ? FittedBox(
                              fit: BoxFit.fill, child: Image.file(lessonPhoto!))
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
      ),
    );
  }
}
