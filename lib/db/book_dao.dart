import '../models/book.dart';
import 'database_helper.dart';

class BookDao {
  final dbHelper = DatabaseHelper.instance;

  // UPDATE TITLE (existing)
  Future<int> updateBookTitle(int bookId, String newTitle) async {
    final db = await dbHelper.database;
    return await db.update(
      'books',
      {'title': newTitle},
      where: 'id = ?',
      whereArgs: [bookId],
    );
  }

  // NEW: Update lastOpenedAt
  Future<void> updateLastOpenedAt(int bookId) async {
    final db = await dbHelper.database;
    await db.update(
      'books',
      {'last_opened_at': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [bookId],
    );
  }

  // NEW: Get recently opened books
  Future<List<Book>> getRecentlyOpenedBooks({int limit = 10}) async {
    final db = await dbHelper.database;
    final maps = await db.query(
      'books',
      where: 'last_opened_at IS NOT NULL',
      orderBy: 'last_opened_at DESC',
      limit: limit,
    );

    return maps.map((map) => Book.fromMap(map)).toList();
  }
}