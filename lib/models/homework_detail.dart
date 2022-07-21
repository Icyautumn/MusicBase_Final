import 'package:cloud_firestore/cloud_firestore.dart';

class HomeworkDetail{
  String id;
  final String homeworkDetail;
  bool isDone;
  String teacherEmail;
  DateTime dueDate;
  String studentEmail;

  HomeworkDetail({required this.id,required this.homeworkDetail, required this.isDone, required this.teacherEmail, required this.dueDate, required this.studentEmail});

  HomeworkDetail.fromMap(Map<String, dynamic> snapshot, String id)
      : id = id,
        homeworkDetail = snapshot['HomeworkDetail'] ?? '', 
        isDone = snapshot['isDone'] ?? '',
        teacherEmail = snapshot['teacherEmail'] ?? '',
        studentEmail = snapshot['studentEmail'] ?? '',
        dueDate =
            (snapshot['dueDate'] ?? Timestamp.now() as Timestamp).toDate();
}