import 'dart:convert';

import 'package:bouldering_sns/Home/Widgets/GymRowData.dart';
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


  static final String _NEARGYMLIST = "NEARGYMLIST";
  static Future<bool> setNearGymList(List<GymRowData> gymRowDataList){
    List<String> strList = List<String>();
    gymRowDataList.forEach((GymRowData v){
      strList.add(json.encode(v));
    });
    prefs.setStringList(_NEARGYMLIST, strList);
  }

  static List<GymRowData> getNearGymList() {
    List<String> strs = prefs.getStringList(_NEARGYMLIST);
    if(strs == null) return null;
    List<GymRowData> nearGymList = List<GymRowData>();
    strs.forEach((str){
      print(str);
      nearGymList.add(GymRowData.fromJSON(str));
    });
    return nearGymList;
  }

  static final String _FAVOLITEGYMLIST = "FAVOLITEGYMLIST";
//  static
}