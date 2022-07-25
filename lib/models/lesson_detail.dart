import 'package:cloud_firestore/cloud_firestore.dart';

class LessonDetail {
  String id;
  String teacherUsername;
  
  DateTime? dateCreated;
  String? lessonType;
  String? lessonDetail;
  String? lessonImages;
  String? studentUsername;

  LessonDetail(
      {
        required this.id,
      required this.teacherUsername,
      required this.lessonType,
      required this.lessonDetail,
      required this.lessonImages,
      required this.studentUsername,
      required this.dateCreated});

  LessonDetail.fromMap(Map<String, dynamic> snapshot, String id)
      : id = id,
        teacherUsername = snapshot['teacherUsername'] ?? '', 
        lessonType = snapshot['lessonType'] ?? '',
        lessonImages = snapshot['lessonImage'] ?? '',
        lessonDetail = snapshot['LessonDetail'] ?? '',
        studentUsername = snapshot['studentUsername'] ?? '',
        dateCreated =
            (snapshot['dateCreated'] ?? Timestamp.now() as Timestamp).toDate();
}
