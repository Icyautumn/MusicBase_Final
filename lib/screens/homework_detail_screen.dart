import 'package:chat_application/models/homework_detail.dart';
import 'package:chat_application/models/user_model.dart';
import 'package:chat_application/screens/add_homework_detail_screen.dart';
import 'package:chat_application/services/firestore_service.dart';
import 'package:chat_application/widgets/homework_list.dart';
import 'package:flutter/material.dart';

class HomeworkDetailListScreen extends StatefulWidget {
  // static String routeName = '/homework-list';
  UserModel user;
  HomeworkDetailListScreen(this.user);

  @override
  State<HomeworkDetailListScreen> createState() => _HomeworkDetailListScreenState();
}

class _HomeworkDetailListScreenState extends State<HomeworkDetailListScreen> {
  @override
  Widget build(BuildContext context) {
    FirestoreService fsService = FirestoreService();

    return StreamBuilder<List<HomeworkDetail>>(
      stream: widget.user.role == 'teacher' ? fsService.getTeacherHomeworkDetail(widget.user.username) : fsService.getStudentHomeworkDetail(widget.user.username),
      builder: (context, snapshot) {
        return snapshot.connectionState == ConnectionState.waiting ? 
        Center(child: CircularProgressIndicator()) :
        Scaffold(
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
              child: snapshot.data!.length> 0
                  ? HomeworkList(widget.user)
                  : Column(
                      children: [
                        SizedBox(height: 20),
                        Image.asset('images/empty.png', width: 300),
                        Text('No Homework yet, add a new one today!',
                            style: Theme.of(context).textTheme.subtitle1),
                      ],
                    )),
          floatingActionButton:  widget.user.role == 'teacher' ? FloatingActionButton(
              onPressed: () {
                Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => new AddHomeworkDetailScreen(widget.user),
                ),
                );
              },
              child: Icon(Icons.add)) : null
        );
      }
    );
  }
}
