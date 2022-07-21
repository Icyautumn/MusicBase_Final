import 'package:chat_application/models/homework_detail.dart';
import 'package:chat_application/screens/add_homework_detail_screen.dart';
import 'package:chat_application/services/firestore_service.dart';
import 'package:chat_application/widgets/homework_list.dart';
import 'package:flutter/material.dart';

class HomeworkDetailListScreen extends StatefulWidget {
  // static String routeName = '/homework-list';

  @override
  State<HomeworkDetailListScreen> createState() => _HomeworkDetailListScreenState();
}

class _HomeworkDetailListScreenState extends State<HomeworkDetailListScreen> {
  @override
  Widget build(BuildContext context) {
    FirestoreService fsService = FirestoreService();

    return StreamBuilder<List<HomeworkDetail>>(
      stream: fsService.getHomeworkDetail(),
      builder: (context, snapshot) {
        return snapshot.connectionState == ConnectionState.waiting ? 
        Center(child: CircularProgressIndicator()) :
        Scaffold(
          appBar: AppBar(
            title: Text('My Homework Detail'),
          ),
          body: Container(
              alignment: Alignment.center,
              child: snapshot.data!.length> 0
                  ? HomeworkList()
                  : Column(
                      children: [
                        SizedBox(height: 20),
                        Image.asset('images/empty.png', width: 300),
                        Text('No Homework yet, add a new one today!',
                            style: Theme.of(context).textTheme.subtitle1),
                      ],
                    )),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => new AddHomeworkDetailScreen(),
                ),
                );
              },
              child: Icon(Icons.add)),
        );
      }
    );
  }
}
