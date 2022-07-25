import 'package:cloud_firestore/cloud_firestore.dart';

class HomeworkDetail{
  String id;
  final String homeworkDetail;
  bool isDone;
  String teacherUsername;
  DateTime dueDate;
  String studentUsername;

  HomeworkDetail({required this.id,required this.homeworkDetail, required this.isDone, required this.teacherUsername, required this.dueDate, required this.studentUsername});

  HomeworkDetail.fromMap(Map<String, dynamic> snapshot, String id)
      : id = id,
        homeworkDetail = snapshot['HomeworkDetail'] ?? '', 
        isDone = snapshot['isDone'] ?? '',
        teacherUsername = snapshot['teacherUsername'] ?? '',
        studentUsername = snapshot['studentUsername'] ?? '',
        dueDate =
            (snapshot['dueDate'] ?? Timestamp.now() as Timestamp).toDate();
}