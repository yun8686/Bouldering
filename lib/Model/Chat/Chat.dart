import 'package:bouldering_sns/Model/User/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Chat{
  static const String _COLLECTION_NAME = "chats";
  static CollectionReference collection = Firestore.instance.collection(_COLLECTION_NAME);

  User rightUser, leftUser;
  String key = "";
  Chat({this.rightUser, this.leftUser}){
    // keyはuidが小さい方 + "_" + 大きいほう
    if(this.rightUser.key.compareTo(this.leftUser.key) < 0){
      this.key = this.rightUser.key + "_" + this.leftUser.key;
    }else{
      this.key = this.leftUser.key + "_" + this.rightUser.key;
    }
    collection.document(this.key).get().then((onValue){
      if(!onValue.exists){
        collection.document(this.key).setData({
          'count': 0,
        });
      }
    });
  }

  Stream<QuerySnapshot> getChatStream(){
    return collection.document(this.key).collection("logs").orderBy("date", descending: true).limit(10).snapshots();
  }

  Future sendChat(String message){
    return collection.document(this.key).collection("logs").add({
      'date': DateTime.now(),
      'creator': rightUser.key,
      'creatorName': rightUser.displayName,
      'message': message,
    });
  }


}