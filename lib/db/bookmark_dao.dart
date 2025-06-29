import '../models/bookmark.dart';
import 'database_helper.dart';

class BookmarkDao {
  final dbHelper = DatabaseHelper.instance;

  Future<int> insertBookmark(Bookmark bookmark) async {
    return await dbHelper.insertBookmark(bookmark);
  }

  Future<List<Bookmark>> getBookmarksForBook(int bookId) async {
    return await dbHelper.getBookmarksForBook(bookId);
  }

  Future<int> updateBookmark(Bookmark bookmark) async {
    return await dbHelper.updateBookmark(bookmark);
  }

  Future<int> deleteBookmark(int id) async {
    return await dbHelper.deleteBookmark(id);
  }
}
