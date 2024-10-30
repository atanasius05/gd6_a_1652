import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  // Database creation for 'employee' and 'gadget' tables
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""
      CREATE TABLE employee(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        email TEXT
      )
    """);

    await database.execute("""
      CREATE TABLE gadget(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        name TEXT,
        merk TEXT
      )
    """);
  }

  // Initialize the database
  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'app_database.db', 
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // CRUD operations for 'employee' table
  static Future<int> addEmployee(String name, String email) async {
    final db = await SQLHelper.db();
    final data = {'name': name, 'email': email};
    return await db.insert('employee', data);
  }

  static Future<List<Map<String, dynamic>>> getEmployee() async {
    final db = await SQLHelper.db();
    return db.query('employee');
  }

  static Future<int> editEmployee(int id, String name, String email) async {
    final db = await SQLHelper.db();
    final data = {'name': name, 'email': email};
    return await db.update('employee', data, where: "id = ?", whereArgs: [id]);
  }

  static Future<int> deleteEmployee(int id) async {
    final db = await SQLHelper.db();
    return await db.delete('employee', where: "id = ?", whereArgs: [id]);
  }

  // CRUD operations for 'gadget' table
  static Future<int> addGadget(String name, String merk) async {
    final db = await SQLHelper.db();
    final data = {'name': name, 'merk': merk};
    return await db.insert('gadget', data);
  }

  static Future<List<Map<String, dynamic>>> getGadget() async {
    final db = await SQLHelper.db();
    return db.query('gadget');
  }

  static Future<int> editGadget(int id, String name, String merk) async {
    final db = await SQLHelper.db();
    final data = {'name': name, 'merk': merk};
    return await db.update('gadget', data, where: "id = ?", whereArgs: [id]);
  }

  static Future<int> deleteGadget(int id) async {
    final db = await SQLHelper.db();
    return await db.delete('gadget', where: "id = ?", whereArgs: [id]);
  }
}
