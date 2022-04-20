import 'package:localstorage/costants.dart';
import 'package:localstorage/model/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//singleton pattern
class DataBaseHelper {
  DataBaseHelper._();
  static DataBaseHelper db =DataBaseHelper._();
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    return initDb();
  }

  Future<Database> initDb() async {
    String path = join(
        await getDatabasesPath(),
        'userData.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE $tableName ('
                '$userId INTEGER PRIMARY KEY, '
                '$userName TEXT NOT NULL, '
                '$userEmail TEXT NOT NULL, '
                '$userPhone TEXT NOT NULL)');
        _database = db;
      },
    );
  }

  Future<void> insert(UserModel user) async {
    var db = await database;
    db.insert(
      tableName,
      user.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> update(UserModel user) async {
    var db = await database;
    db.update(
      tableName,
      user.toJson(),
      where: '$userId=?',
      whereArgs: [user.id],
    );
  }

  Future<UserModel?> readUser(int id) async {
    var db = await database;
    List<Map<String, dynamic>> users = await db.query(
      tableName,
      where: '$userId=?',
      whereArgs: [id],
    );
    if (users.isEmpty) {
      return null;
    }
    return UserModel.fromJson(users.first);
  }

  Future<List<UserModel>?> readAllUsers() async {
    var db = await database;
    List<Map<String, dynamic>> users = await db.query(
      tableName,
    );

    if (users.isEmpty) {
      return [];
    }
    return users.map((user) => UserModel.fromJson(user)).toList();
  }

  Future<void> delete(int id) async {
    var db = await database;
    db.delete(
      tableName,
      where: '$userId=?',
      whereArgs: [id],
    );
  }
}
