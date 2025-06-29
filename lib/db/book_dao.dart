import '../models/book.dart';
import 'database_helper.dart';

class BookDao {
  final dbHelper = DatabaseHelper.instance;

  Future<int> updateBookTitle(int bookId, String newTitle) async {
    return await dbHelper.updateBookTitle(bookId, newTitle);
  }
}
