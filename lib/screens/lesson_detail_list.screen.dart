import 'package:chat_application/models/lesson_detail.dart';
import 'package:chat_application/models/user_model.dart';
import 'package:chat_application/screens/add_lesson_detail_screen.dart';
import 'package:chat_application/services/firestore_service.dart';
import 'package:chat_application/widgets/lesson_detail_list.dart';
import 'package:flutter/material.dart';

class LessonDetailListScreen extends StatefulWidget {
  UserModel user;
  LessonDetailListScreen(this.user);

  @override
  State<LessonDetailListScreen> createState() => _LessonDetailListScreenState();
}

class _LessonDetailListScreenState extends State<LessonDetailListScreen> {
  @override
  Widget build(BuildContext context) {
    FirestoreService fsService = FirestoreService();
    return StreamBuilder<List<LessonDetail>>(
        stream: widget.user.role == 'teacher' ? fsService.getTeacherLessonDetail(widget.user.username) : fsService.getStudentLessonDetail(widget.user.username),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? Center(child: CircularProgressIndicator())
              : Scaffold(
                  appBar: AppBar(
                    iconTheme: IconThemeData(color: Colors.black),
                    centerTitle: true,
                    title: Text(
                      widget.user.role,
                      style: TextStyle(color: Colors.black),
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0.0,
                  ),
                  body: Container(
                      alignment: Alignment.center,
                      child: snapshot.data!.length > 0
                          ? LessonList(widget.user)
                          : Column(
                              children: [
                                SizedBox(height: 20),
                                Image.asset('images/empty.png', width: 300),
                                Text('No lessons yet, add a new one today!',
                                    style:
                                        Theme.of(context).textTheme.subtitle1),
                              ],
                            )),
                  floatingActionButton: widget.user.role == 'teacher' ? FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(
                            builder: (context) => new AddLessonDetailScreen(widget.user),
                          ),
                        );
                      },
                      child: Icon(Icons.add)) : null
                );
        });
  }
}
