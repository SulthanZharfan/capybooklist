import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/book.dart';
import '../models/bookmark.dart';
import 'reader_screen.dart';

class BookDetailScreen extends StatefulWidget {
  final Book book;

  const BookDetailScreen({Key? key, required this.book}) : super(key: key);

  @override
  _BookDetailScreenState createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final dbHelper = DatabaseHelper.instance;
  List<Bookmark> _bookmarks = [];

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final data = await dbHelper.getBookmarksForBook(widget.book.id!);
    setState(() {
      _bookmarks = data;
    });
  }

  Future<void> _addBookmark() async {
    final page = await _showPageInputDialog();
    final note = await _showNoteInputDialog();
    if (page != null && note != null) {
      final bookmark = Bookmark(
        bookId: widget.book.id!,
        pageNumber: page,
        note: note,
      );
      await dbHelper.insertBookmark(bookmark);
      await _loadBookmarks();
    }
  }

  Future<void> _editBookmark(Bookmark bookmark) async {
    final newPage = await _showPageInputDialog(initial: bookmark.pageNumber);
    final newNote = await _showNoteInputDialog(initial: bookmark.note);
    if (newPage != null && newNote != null) {
      final updated = Bookmark(
        id: bookmark.id,
        bookId: bookmark.bookId,
        pageNumber: newPage,
        note: newNote,
      );
      await dbHelper.updateBookmark(updated);
      await _loadBookmarks();
    }
  }

  Future<void> _deleteBookmark(int id) async {
    await dbHelper.deleteBookmark(id);
    await _loadBookmarks();
  }

  Future<void> _renameBook() async {
    final newTitle = await _showRenameDialog();
    if (newTitle != null && newTitle.isNotEmpty) {
      await dbHelper.updateBookTitle(widget.book.id!, newTitle);
      setState(() {
        widget.book.title = newTitle;
      });
    }
  }

  void _openBook() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReaderScreen(book: widget.book),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            tooltip: 'Rename Book',
            onPressed: _renameBook,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.book.title,
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Author: ${widget.book.author ?? "Unknown"}',
                      style: theme.textTheme.bodyMedium,
                    ),
                    if (widget.book.description != null && widget.book.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          widget.book.description!,
                          style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[700]),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Bookmarks',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            _bookmarks.isEmpty
                ? Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(
                child: Text(
                  'No bookmarks yet.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
              ),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _bookmarks.length,
              itemBuilder: (context, index) {
                final bm = _bookmarks[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.primary.withOpacity(0.15),
                      child: Icon(Icons.bookmark, color: theme.colorScheme.primary),
                    ),
                    title: Text('Page ${bm.pageNumber}'),
                    subtitle: Text(bm.note),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.amber),
                          tooltip: 'Edit',
                          onPressed: () => _editBookmark(bm),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          tooltip: 'Delete',
                          onPressed: () => _deleteBookmark(bm.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: 'openBook',
            onPressed: _openBook,
            icon: Icon(Icons.menu_book),
            label: Text('Open Book'),
          ),
          SizedBox(height: 12),
          FloatingActionButton.extended(
            heroTag: 'addBookmark',
            onPressed: _addBookmark,
            icon: Icon(Icons.bookmark_add),
            label: Text('Add Bookmark'),
          ),
        ],
      ),
    );
  }

  // ----------------- Dialogs -----------------

  Future<int?> _showPageInputDialog({int? initial}) async {
    final controller = TextEditingController(text: initial?.toString() ?? '');
    return showDialog<int>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Page Number'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'Enter page number'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                final value = int.tryParse(controller.text);
                Navigator.pop(context, value);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<String?> _showNoteInputDialog({String? initial}) async {
    final controller = TextEditingController(text: initial ?? '');
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Note / Footnote'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter note'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<String?> _showRenameDialog() async {
    final controller = TextEditingController(text: widget.book.title);
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Rename Book'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'Enter new title'),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
