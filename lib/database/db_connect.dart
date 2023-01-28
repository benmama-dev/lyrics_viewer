import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseConnection {
  String tableName = 'profileDB';

  setDatabase() async {
    var directory = await getDatabasesPath();
    var path = join(directory, 'db_profile');
    var database =
    await openDatabase(path, version: 1, onCreate: _onCreatingDatabase);
    return database;
  }

  _onCreatingDatabase(Database database, int version) async {
    // ignore: avoid_print
    print('set database');
    await database.execute('''CREATE TABLE $tableName(
          id INTEGER PRIMARY KEY,
          nameSoung TEXT,
          name TEXT,
          image TEXT,
          )''');
  }
}
