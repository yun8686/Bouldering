import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences{
  static SharedPreferences prefs;
  static _init() async {
    if(MySharedPreferences.prefs == null){
      MySharedPreferences.prefs = await SharedPreferences.getInstance();
    }
  }

  // FirebaseUid
  static final String _FIREBASE_UID = "FIREBASE_UID";
  static Future<bool> setFirebaseUID(String firebaseUID) async {
    await _init();
    return prefs.setString(_FIREBASE_UID, firebaseUID);
  }
  static Future<String> getFirebaseUID() async {
    await _init();
    return prefs.getString(_FIREBASE_UID);
  }
}