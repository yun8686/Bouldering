import 'package:bouldering_sns/Model/Gym/Grade.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Problem{
  static String COLLECTION_NAME = "problems";

  String key;

  DateTime date;
  String creator;
  String title;
  String comment;
  String gym;
  String grade;
  String image;

  Problem({this.key, this.date, this.creator, this.title, this.comment, this.gym, this.grade, this.image});

  Future create(){
    return FirebaseAuth.instance.currentUser().then((user){
      return Firestore.instance.collection(COLLECTION_NAME).document().setData({
        'date': date,
        'creator': user.uid,
        'title': title,
        'comment': comment,
        'gym': gym,
        'grade': grade,
        'image': image,
        'gymsref': this.gym,
      });
    });
  }


  static Stream<QuerySnapshot> stream() => Firestore.instance.collection(COLLECTION_NAME).snapshots();

  static Future<List<Problem>> getGradeProblemList(Grade grade) {
    return grade.grade_ref.get().then((onValue){
      List<Problem> problemList = List<Problem>();
      if(onValue.data.isNotEmpty && onValue.data['problems'] != null){
        (onValue.data['problems'] as List).forEach((map){
          problemList.add(
              Problem(
                  key: map['key'],
                  date: map['date'],
                  creator: map['creator'],
                  title: map['title'],
                  comment: map['comment'],
                  gym: map['gym'],
                  grade: map['grade'],
                  image: map['image'],
              )
          );
        });
      }
      return problemList;
    });
  }

}