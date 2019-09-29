import 'package:bouldering_sns/Library/SQLiteDatabase.dart';
import 'package:bouldering_sns/Model/Gym/Gym.dart';
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

  static Future<bool> setNearGymList(List<Gym> gymList) async{
    List<String> strList = List<String>();
    Database database = await SQLiteDatabase.getDatabase();
    database.delete(Tables.NearGymList);
    gymList.forEach((Gym v){
      database.insert(Tables.NearGymList, {
        'name': v.name,
        'place_id': v.place_id,
        'distance': v.distance,
      });
    });
  }

  static Future<List<Gym>> getNearGymList() async {
    Database database = await SQLiteDatabase.getDatabase();
    List<Map> list = await database.rawQuery("""
      SELECT 
        a.*, 
        case when (select count(1) from ${Tables.FavoriteGymList} where place_id = a.place_id)>0 then 1 else 0 end as favorite 
      FROM ${Tables.NearGymList} a;
    """);
    return list.map((data){
      return Gym.fromDBMap(data);
    }).toList();
  }

  static final String _FAVORITEGYMLIST = "FAVORITEGYMLIST";
  static Future<void> addFavoriteGymPlaceid(String place_id) async{
    Database database = await SQLiteDatabase.getDatabase();
    await database.rawQuery(
        "INSERT INTO ${Tables.FavoriteGymList} SELECT '${place_id}';"
    );
  }
  static Future<void> removeFavoriteGymPlaceid(String place_id) async{
    Database database = await SQLiteDatabase.getDatabase();
    try{
      await database.rawQuery(
          "delete from ${Tables.FavoriteGymList} where place_id = '${place_id}';"
      );
    }catch(e){}
  }
  static Future<List<Gym>> getFavoriteGymList() async{
    Database database = await SQLiteDatabase.getDatabase();
    List<Map> list = await database.rawQuery("""
      SELECT a.*, 1 as favorite
      FROM ${Tables.NearGymList} a join FavoriteGymList b on a.place_id = b.place_id;
    """);
    return list.map((data){
      return Gym.fromDBMap(data);
    }).toList();
  }
//  static
}