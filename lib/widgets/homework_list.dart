import 'package:chat_application/models/homework_detail.dart';
import 'package:chat_application/models/user_model.dart';
import 'package:chat_application/screens/edit_homework_detail_screen.dart';
import 'package:chat_application/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:chat_application/widgets/notification_api.dart';

class HomeworkList extends StatefulWidget {
  UserModel user;
  HomeworkList(this.user);

  @override
  State<HomeworkList> createState() => _HomeworkListState();
}

class _HomeworkListState extends State<HomeworkList> {
  FirestoreService fsService = FirestoreService();
  late final DateTime dateDue;

  void removeItem(String id) {
    showDialog<Null>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: Text('Are you sure you want to delete?'),
            actions: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      fsService.removeHomework(id);
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Yes')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('No')),
            ],
          );
        });
  }

  changeToDone(String id, bool isDone) {
    setState(() {
      fsService.changeToDone(id, isDone);
    });
  }

  in2Days(DateTime date, id, homework, isDone){
    var inDays2 = date.difference(DateTime.now()).inDays;
    if (inDays2 <= 2 && isDone == false){
      NotificationApi.showNotification(
        title: 'Homework',
        body: (homework +  " Due in :" +  inDays2.toString() +  " Days"),
        payload: homework
      );
      if( inDays2 <= -2){
        fsService.removeHomework(id);
      }
      return inDays2;
      // add local notification

    } 
    else{
      return inDays2;
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return StreamBuilder<List<HomeworkDetail>>(
        stream: widget.user.role == 'teacher'? fsService.getTeacherHomeworkDetail(widget.user.username) : fsService.getStudentHomeworkDetail(widget.user.username),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else {
            return ListView.separated(
                itemBuilder: (ctx, i) {
                  return ListTile(
                    onTap: widget.user.role == 'teacher'? () => Navigator.push(
                      context, new MaterialPageRoute(
                        builder: (context) => new EditHomeworkDetailScreen(),
                        settings: RouteSettings(
                          arguments: snapshot.data![i]
                        )
                      )
                    ) : null,
                    onLongPress: widget.user.role == 'teacher'? () => removeItem(snapshot.data![i].id) : null,
                    title: Text(
                      snapshot.data![i].homeworkDetail,
                      style: TextStyle(
                          decoration: snapshot.data![i].isDone
                              ? TextDecoration.lineThrough
                              : null),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 13),
                      child: Text("To :" + snapshot.data![i].studentUsername),
                    ),
                    trailing: Container(
                      width: 80.0,
                      height: 100,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Checkbox(
                                activeColor: Colors.lightBlueAccent,
                                value: snapshot.data![i].isDone,
                                onChanged: (checkboxState) => changeToDone(
                                    snapshot.data![i].id,
                                    snapshot.data![i].isDone)),
                            Text("Due in :" + in2Days(snapshot.data![i].dueDate, snapshot.data![i].id, snapshot.data![i].homeworkDetail, snapshot.data![i].isDone).toString() + " days, ",
                                style: TextStyle(
                                    color: in2Days(snapshot.data![i].dueDate, snapshot.data![i].id, snapshot.data![i].homeworkDetail, snapshot.data![i].isDone) <= 2
                                        ? Colors.red
                                        : Colors.black))
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: snapshot.data!.length,
                separatorBuilder: (ctx, i) {
                  return Divider(height: 3, color: Colors.blueGrey);
                });
          }
        });
  }
}


