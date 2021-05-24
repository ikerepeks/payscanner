import 'package:path/path.dart';
import 'package:payscanner/Model/Vendor.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  Future<Database> initializaDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'vendor.db'),
      onCreate: (db, version) async {
        await db
            .execute("CREATE TABLE vendor(email TEXT, pw TEXT, token TEXT)");
      },
      version: 1,
    );
  }

  Future<int> insertVendor(Vendor vendor) async {
    int result = 0;
    final Database db = await initializaDB();
    var checker = await db
        .rawQuery('SELECT * FROM vendor WHERE email = ?', [vendor.email]);
    if (checker.isEmpty) {
      result = await db.insert('vendor', vendor.toMap());
      return result;
    } else {
      return 0;
    }
  }

  Future<List<Vendor>> retrieveVendor() async {
    final Database db = await initializaDB();
    final List<Map<String, Object>> queryResult = await db.query('vendor');
    return queryResult.map((e) => Vendor.fromMap(e)).toList();
  }

  Future<int> editVendor(String token, String email) async {
    final Database db = await initializaDB();
    int updateCount = await db.rawUpdate('''UPDATE vendor
    set token = ?, where email = ?''', [token, email]);
    return updateCount;
  }
}
