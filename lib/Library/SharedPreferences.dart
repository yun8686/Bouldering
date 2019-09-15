import 'dart:convert';

import 'package:bouldering_sns/Home/Widgets/GymRowData.dart';
import 'package:bouldering_sns/Library/SQLiteDatabase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

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

  static Future<bool> setNearGymList(List<GymRowData> gymRowDataList) async{
    List<String> strList = List<String>();
    Database database = await SQLiteDatabase.getDatabase();
    database.delete(Tables.NearGymList);
    gymRowDataList.forEach((GymRowData v){
      database.insert(Tables.NearGymList, {
        'name': v.name,
        'placeId': v.placeId,
      });
    });
  }

  static Future<List<GymRowData>> getNearGymList() async {
    Database database = await SQLiteDatabase.getDatabase();
    List<Map> list = await database.rawQuery("""
      SELECT 
        a.*, 
        case when (select count(1) from ${Tables.FavoriteGymList} where placeId = a.placeId)>0 then 1 else 0 end as favolite 
      FROM ${Tables.NearGymList} a;
    """);
    return list.map((data){
      return GymRowData.fromMap(data);
    }).toList();
  }

  static final String _FAVOLITEGYMLIST = "FAVOLITEGYMLIST";
  static Future<void> addFavoliteGymPlaceid(String placeId) async{
    Database database = await SQLiteDatabase.getDatabase();
    try{
      await database.rawQuery(
          "INSERT INTO ${Tables.FavoriteGymList} SELECT '${placeId}';"
      );
    }catch(e){}
  }
  static Future<void> removeFavoliteGymPlaceid(String placeId) async{
    Database database = await SQLiteDatabase.getDatabase();
    try{
      await database.rawQuery(
          "delete from ${Tables.FavoriteGymList} where placeId = '${placeId}';"
      );
    }catch(e){}
  }
  static Future<List<GymRowData>> getFavoriteGym() async{
    Database database = await SQLiteDatabase.getDatabase();
    List<Map> list = await database.rawQuery("""
      SELECT a.*, 1 as favolite
      FROM ${Tables.NearGymList} a join FavoriteGymList b on a.placeId = b.placeId;
    """);
    return list.map((data){
      return GymRowData.fromMap(data);
    }).toList();
  }
//  static
}