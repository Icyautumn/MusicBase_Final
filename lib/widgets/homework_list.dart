import 'package:chat_application/models/homework_detail.dart';
import 'package:chat_application/screens/edit_homework_detail_screen.dart';
import 'package:chat_application/services/firestore_service.dart';
import 'package:flutter/material.dart';
import 'package:chat_application/widgets/notification_api.dart';

class HomeworkList extends StatefulWidget {

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

  in2Days(DateTime date, id, homework){
    var inDays2 = date.difference(DateTime.now()).inDays;
    if (inDays2 <= 2){
      NotificationApi.showNotification(
        title: 'Homework',
        body: ('your homework is due in :' + inDays2.toString()),
        payload: homework
      );
      if( inDays2 <= -4){
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
        stream: fsService.getHomeworkDetail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else {
            return ListView.separated(
                itemBuilder: (ctx, i) {
                  return ListTile(
                    onTap: () => Navigator.push(
                      context, new MaterialPageRoute(
                        builder: (context) => new EditHomeworkDetailScreen(),
                        settings: RouteSettings(
                          arguments: snapshot.data![i]
                        )
                      )
                    ),
                    onLongPress: () => removeItem(snapshot.data![i].id),
                    title: Text(
                      snapshot.data![i].homeworkDetail,
                      style: TextStyle(
                          decoration: snapshot.data![i].isDone
                              ? TextDecoration.lineThrough
                              : null),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 13),
                      child: Text("To :" + snapshot.data![i].studentEmail),
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
                            Text("Due in :" + in2Days(snapshot.data![i].dueDate, snapshot.data![i].id, snapshot.data![i].homeworkDetail).toString() + " days, ",
                                style: TextStyle(
                                    color: in2Days(snapshot.data![i].dueDate, snapshot.data![i].id, snapshot.data![i].homeworkDetail) <= 2
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


