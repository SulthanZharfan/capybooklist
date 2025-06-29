import 'package:sqflite/sqflite.dart';
import 'package:capybooklist/db/database_helper.dart';
import 'package:capybooklist/models/user.dart';

class UserDao {
  static const String tableName = 'user';

  Future<void> insertOrUpdateUser(User user) async {
    final db = await DatabaseHelper.instance.database;

    if (user.id == null) {
      // INSERT
      await db.insert(
        tableName,
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } else {
      // UPDATE
      await db.update(
        tableName,
        user.toMap(),
        where: 'id = ?',
        whereArgs: [user.id],
      );
    }
  }

  Future<User?> getUser() async {
    final db = await DatabaseHelper.instance.database;

    final List<Map<String, dynamic>> maps = await db.query(tableName, limit: 1);

    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }
}
