import 'package:bouldering_sns/Model/Gym/Gym.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Grade{
  static const String COLLECTION_NAME = "grades";
  static CollectionReference collection = Firestore.instance.collection(COLLECTION_NAME);

  String key;
  String name;
  String place_id;
  String grade_id;
  DocumentReference grade_ref;

  Grade({this.key, this.name, this.place_id, this.grade_id, this.grade_ref});

  static CollectionReference gymCollection = Gym.collection;

  static Future create(Gym gym, String grade_name)async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    await Firestore.instance.runTransaction((Transaction transaction)async{
      DocumentReference newGradeRef = collection.document();
      DocumentReference gymRef = (await gymCollection.document(gym.place_id).get()).reference;
      await transaction.set(newGradeRef,{
        'name': grade_name,
        'gym_ref': gymRef,
      });
      await transaction.update(gymRef, {
        'grades': FieldValue.arrayUnion([{
          'name': grade_name,
          'ref': newGradeRef,
        }]),
      });
    });
  }

  static Future<List<Grade>> getGymGradeList(String place_id)async{
    return gymCollection.document(place_id).get().then((onValue){
      List<Grade> gradeList = List<Grade>();
      if(onValue.exists){
        if(onValue.data['grades'] != null){
          print(onValue.data['grades'].length);
          String key = onValue.documentID;
          for(int i=0;i<onValue.data['grades'].length;i++) {
            Map data = onValue.data['grades'][i];
            String name = data['name'];
            DocumentReference grade_ref = data['ref'] as DocumentReference;
            String grade_id = grade_ref.documentID;
            gradeList.add(Grade(
              key: key,
              name: name,
              place_id: key,
              grade_id: grade_id,
              grade_ref: grade_ref,
            ));
          }
        }
      }
      return gradeList;
    });
  }

}