
import 'package:chat_application/models/homework_detail.dart';
import 'package:chat_application/models/lesson_detail.dart';
import 'package:chat_application/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirestoreService {
  AuthService authService = AuthService();

  addLessonScreen(lessonType, lessonDetail, lessonImage, dateCreated, studentUsername, teacherUsername) {
    return FirebaseFirestore.instance.collection('LessonDetail').add({
      'teacherUsername' : teacherUsername,
      'lessonType': lessonType,
      'LessonDetail': lessonDetail,
      'lessonImage': lessonImage,
      'dateCreated': dateCreated,
      'studentUsername': studentUsername,
    });
  }


  Stream<List<LessonDetail>> getTeacherLessonDetail(teacherUsername) {
    return FirebaseFirestore.instance.collection('LessonDetail')
    .where('teacherUsername', isEqualTo: teacherUsername).
    snapshots().map(
        (snapshot) => snapshot.docs
            .map<LessonDetail>((doc) => LessonDetail.fromMap(doc.data(), doc.id))
            .toList());
  }

  Stream<List<LessonDetail>> getStudentLessonDetail(studentUsername) {
    return FirebaseFirestore.instance.collection('LessonDetail')
    .where('studentUsername', isEqualTo: studentUsername).
    snapshots().map(
        (snapshot) => snapshot.docs
            .map<LessonDetail>((doc) => LessonDetail.fromMap(doc.data(), doc.id))
            .toList());
  }

  removeLesson(id) {
    return FirebaseFirestore.instance.collection('LessonDetail').doc(id).delete();
  }

  editLesson(id, dateCreated, lessonType, studentUsername, lessonImage, lessonDetail, teacherUsername) {
    return FirebaseFirestore.instance.collection('LessonDetail').doc(id).set({
      'teacherUsername' : teacherUsername,
      'lessonType': lessonType,
      'LessonDetail': lessonDetail,
      'lessonImage': lessonImage,
      'dateCreated': dateCreated,
      'studentUsername': studentUsername,
    });
  }



  Stream<List<HomeworkDetail>> getTeacherHomeworkDetail(teacherUsername) {
    return FirebaseFirestore.instance.collection('HomeworkDetail')
    .where('teacherUsername', isEqualTo: teacherUsername).
    snapshots().map(
        (snapshot) => snapshot.docs
            .map<HomeworkDetail>((doc) => HomeworkDetail.fromMap(doc.data(), doc.id))
            .toList());
  }

  Stream<List<HomeworkDetail>> getStudentHomeworkDetail(StudentUsername) {
    return FirebaseFirestore.instance.collection('HomeworkDetail')
    .where('studentUsername', isEqualTo: StudentUsername).
    snapshots().map(
        (snapshot) => snapshot.docs
            .map<HomeworkDetail>((doc) => HomeworkDetail.fromMap(doc.data(), doc.id))
            .toList());
  }

  addHomeworkScreen(homeworkDetail, studentUsername, datePicked, teacherUsername) {
    return FirebaseFirestore.instance.collection('HomeworkDetail').add({
      'teacherUsername' : teacherUsername,
      'HomeworkDetail': homeworkDetail,
      'dueDate': datePicked,
      'studentUsername': studentUsername,
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
  editHomework(id, homeworkDetail, studentUsername, datePicked) {
    return FirebaseFirestore.instance.collection('HomeworkDetail').doc(id).update({
      'HomeworkDetail': homeworkDetail,
      'dueDate': datePicked,
      'studentUsername': studentUsername,
    });
  }

  Future<bool> checkUsernameUnique(String username) async {
    final result = await FirebaseFirestore.instance.collection('users').where('username', isEqualTo: username).get();
     if(result.docs.isEmpty == true){
      return true;
     } else{
      return false;
     }
    
  }
}