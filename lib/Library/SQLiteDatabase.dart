import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class Tables{
  static final String NearGymList = "NearGymList";
  static final String FavoriteGymList = "FavoriteGymList";

}

class SQLiteDatabase {
  static Database db;


  static void _init() async {
    if(db != null) return;
    print(await getDatabasesPath());
    final path = join(await getDatabasesPath(), "bouldering.db");


    // openDatabaseメソッドを使用することでDBインスタンスを取得することができます。
    db = await openDatabase(path, version: 1,
      onCreate: (Database newDb, int version) {


        // DBがpathに存在しなかった場合に onCreateメソッドが呼ばれます。
        // このタイミングでTableの生成などを行います。
        // db.executeでSQL文の実行を行うことができます。
        // なお、DBに指定できるプロパティは
        // INTEGER（int）、TEXT（String）、REAL（num）、BLOB（List<int>）のみになるため注意が必要です。
        newDb.execute("""
        CREATE TABLE ${Tables.NearGymList}
          (
            placeId TEXT PRIMARY KEY,
            name TEXT
          );
        """);
        newDb.execute("""
        CREATE TABLE ${Tables.FavoriteGymList}
          (
            placeId TEXT PRIMARY KEY
          );
        """);
      },
    );
  }

  static Future<Database> getDatabase()async{
    await _init();
    return db;
  }
}
