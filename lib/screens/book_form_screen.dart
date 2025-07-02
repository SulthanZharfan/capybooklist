import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../db/database_helper.dart';
import '../models/book.dart';
import 'book_detail_screen.dart';

class BookFormScreen extends StatefulWidget {
  const BookFormScreen({Key? key}) : super(key: key);

  @override
  State<BookFormScreen> createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final dbHelper = DatabaseHelper.instance;
  List<Book> _books = [];

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    final data = await dbHelper.getAllBooks();
    setState(() {
      _books = data;
    });
  }

  Future<void> _addBook() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;

      final newBook = Book(
        title: file.name,
        filePath: file.path ?? '',
        fileSize: file.size,
        fileType: file.extension,
      );

      await dbHelper.insertBook(newBook);
      await _loadBooks();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added: ${file.name}')),
        );
      }
    } else {
      debugPrint('User canceled file picker');
    }
  }

  Future<void> _removeLastBook() async {
    if (_books.isNotEmpty) {
      final lastBook = _books.last;
      await dbHelper.deleteBook(lastBook.id!);
      await _loadBooks();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Removed: ${lastBook.title}')),
        );
      }
    }
  }

  void _openBookDetail(Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookDetailScreen(book: book),
      ),
    ).then((_) {
      _loadBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/Picture1.png',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                  child: const Text(
                    'My Books',
                    style: TextStyle(
                      color: Color(0xFFEEEEEE),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Text(
                    'Your Uploaded Books 📚',
                    style: TextStyle(
                      color: Color(0xFFEEEEEE),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _books.isEmpty
                        ? Center(
                      child: Text(
                        'No books yet. Tap + Add Book!',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                        : ListView.builder(
                      itemCount: _books.length,
                      itemBuilder: (context, index) {
                        final book = _books[index];
                        return Card(
                          color: Colors.black.withOpacity(0.3),
                          child: ListTile(
                            leading: const Icon(Icons.book, color: Colors.white),
                            title: Text(
                              book.title,
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: book.author != null
                                ? Text(
                              book.author!,
                              style: const TextStyle(color: Colors.white70),
                            )
                                : null,
                            onTap: () => _openBookDetail(book),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _addBook,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB0B4D8), // lebih terang
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.add, color: Color(0xFF262C4F)), // warna gelap
                        label: const Text(
                          'Add Book',
                          style: TextStyle(color: Color(0xFF262C4F)),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _removeLastBook,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB0B4D8), // lebih terang
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.remove, color: Color(0xFF262C4F)), // warna gelap
                        label: const Text(
                          'Remove Book',
                          style: TextStyle(color: Color(0xFF262C4F)),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
