
import 'package:chat_application/models/homework_detail.dart';
import 'package:chat_application/models/lesson_detail.dart';
import 'package:chat_application/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  AuthService authService = AuthService();

  addLessonScreen(lessonType, lessonDetail, lessonImage, dateCreated, studentEmail) {
    print(authService.getCurrentUser()!.email );
    return FirebaseFirestore.instance.collection('LessonDetail').add({
      'teacherEmail' : authService.getCurrentUser()!.email ,
      'lessonType': lessonType,
      'LessonDetail': lessonDetail,
      'lessonImage': lessonImage,
      'dateCreated': dateCreated,
      'studentEmail': studentEmail,
    });
  }


  Stream<List<LessonDetail>> getLessonDetail() {
    return FirebaseFirestore.instance.collection('LessonDetail')
    .where('teacherEmail', isEqualTo: authService.getCurrentUser()!.email).
    snapshots().map(
        (snapshot) => snapshot.docs
            .map<LessonDetail>((doc) => LessonDetail.fromMap(doc.data(), doc.id))
            .toList());
  }

  removeLesson(id) {
    return FirebaseFirestore.instance.collection('LessonDetail').doc(id).delete();
  }

  editLesson(id, dateCreated, lessonType, studentEmail, lessonImage, lessonDetail) {
    return FirebaseFirestore.instance.collection('LessonDetail').doc(id).set({
      'teacherEmail' : authService.getCurrentUser()!.email ,
      'lessonType': lessonType,
      'LessonDetail': lessonDetail,
      'lessonImage': lessonImage,
      'dateCreated': dateCreated,
      'studentEmail': studentEmail,
    });
  }



  Stream<List<HomeworkDetail>> getHomeworkDetail() {
    return FirebaseFirestore.instance.collection('HomeworkDetail')
    .where('teacherEmail', isEqualTo: authService.getCurrentUser()!.email).
    snapshots().map(
        (snapshot) => snapshot.docs
            .map<HomeworkDetail>((doc) => HomeworkDetail.fromMap(doc.data(), doc.id))
            .toList());
  }

  addHomeworkScreen(homeworkDetail, studentEmail, datePicked) {
    return FirebaseFirestore.instance.collection('HomeworkDetail').add({
      'teacherEmail' : authService.getCurrentUser()!.email ,
      'HomeworkDetail': homeworkDetail,
      'dueDate': datePicked,
      'studentEmail': studentEmail,
      'isDone' : false
    });
  }

  removeHomework(id) {
    return FirebaseFirestore.instance.collection('HomeworkDetail').doc(id).delete();
  }

  changeToDone(id, isDone){
    return FirebaseFirestore.instance.collection('HomeworkDetail').doc(id).update({
      'isDone' : !isDone,
  });
  }
  editHomework(id, homeworkDetail, studentEmail, datePicked) {
    return FirebaseFirestore.instance.collection('HomeworkDetail').doc(id).update({
      'HomeworkDetail': homeworkDetail,
      'dueDate': datePicked,
      'studentEmail': studentEmail,
    });
  }
}