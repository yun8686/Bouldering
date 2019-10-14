import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class Tables{
  static final String NearGymList = "NearGymList";
  static final String FavoriteGymList = "FavoriteGymList";
  static final String FriendUserList = "FriendUserList";
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
            place_id TEXT PRIMARY KEY,
            name TEXT,
            distance double,
            photo_url TEXT
          );
        """);
        newDb.execute("""
        CREATE TABLE ${Tables.FavoriteGymList}
          (
            place_id TEXT PRIMARY KEY
          );
        """);
        newDb.execute("""
        CREATE TABLE ${Tables.FriendUserList}
          (
            user_id TEXT PRIMARY KEY,
            displayName TEXT
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
