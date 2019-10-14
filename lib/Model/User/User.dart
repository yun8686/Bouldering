import 'package:bouldering_sns/Library/SharedPreferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  static const String _COLLECTION_NAME = "users";
  static CollectionReference collection = Firestore.instance.collection(_COLLECTION_NAME);

  String key;
  String displayName;
  String notifyId;

  User({this.key, this.displayName, this.notifyId});
  User.fromDBMap(Map map){
    this.key = map["user_id"];
    this.displayName = map["displayName"];
    this.notifyId = map["notifyId"];

  }

  static Future<User> getLoginUser()async{
    String firebaseUid = await MySharedPreferences.getFirebaseUID();
    return collection.document(firebaseUid).get().then((onValue){
      if(onValue.exists){
        return User(
          key: onValue.data['uid'],
          displayName: onValue.data['displayName'],
          notifyId: onValue.data['notifyId'],
        );
      }
    });
  }

  static Future<List<User>> getFriendUserList(bool cache) async {
    List<User> users = List<User>();
    if(cache){
      // ローカルにある場合はローカルの値、ない場合はサーバーから取得
      users = await MySharedPreferences.getFriendUserList();
      if(users.length > 0){
        return users;
      }
    }
    await collection.limit(10).getDocuments().then((onValue){
      onValue.documents.forEach((value){
        users.add(User(
          key: value.data["uid"],
          displayName: value.data["displayName"].toString(),
          notifyId: value.data["notifyId"].toString(),
        ));
      });
    });
    MySharedPreferences.setFriendUserList(users);
    return users;
  }
  static Future<List<User>> nearUserList() async{
    List<User> users = List<User>();
    await collection.limit(10).getDocuments().then((onValue){
      onValue.documents.forEach((value){
        users.add(User(
          key: value.data["uid"],
          displayName: value.data["displayName"].toString(),
          notifyId: value.data["notifyId"].toString(),
        ));
      });
    });
    MySharedPreferences.setFriendUserList(users);
    return users;
  }


  Future<User> setNotifyId(String notifyId) async{
    if(this.notifyId != notifyId){
      await collection.document(this.key).updateData({
        'notifyId': notifyId,
      });
      this.notifyId = notifyId;
    }
    return this;
  }
}