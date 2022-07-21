import 'package:cloud_firestore/cloud_firestore.dart';

class LessonDetail {
  String id;
  String teacherEmail;
  
  DateTime? dateCreated;
  String? lessonType;
  String? lessonDetail;
  String? lessonImages;
  String? studentEmail;

  LessonDetail(
      {
        required this.id,
      required this.teacherEmail,
      required this.lessonType,
      required this.lessonDetail,
      required this.lessonImages,
      required this.studentEmail,
      required this.dateCreated});

  LessonDetail.fromMap(Map<String, dynamic> snapshot, String id)
      : id = id,
        teacherEmail = snapshot['teacherEmail'] ?? '', 
        lessonType = snapshot['lessonType'] ?? '',
        lessonImages = snapshot['lessonImage'] ?? '',
        lessonDetail = snapshot['LessonDetail'] ?? '',
        studentEmail = snapshot['studentEmail'] ?? '',
        dateCreated =
            (snapshot['dateCreated'] ?? Timestamp.now() as Timestamp).toDate();
}
