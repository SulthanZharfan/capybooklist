import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class BookFormScreen extends StatefulWidget {
  const BookFormScreen({super.key});

  @override
  State<BookFormScreen> createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final List<String> books = List.generate(10, (index) => 'Book ${index + 1}');

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
    );

    if (result != null && result.files.isNotEmpty) {
      final file = result.files.first;
      debugPrint('Picked file: ${file.name} at ${file.path}');

      // Simpan ke list (contoh)
      setState(() {
        books.add(file.name);
      });

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added: ${file.name}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      debugPrint('User canceled file picker');
    }
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
                // APP BAR CUSTOM
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

                // LIST SCROLLABLE
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView.builder(
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.black.withOpacity(0.3),
                          child: ListTile(
                            leading: const Icon(Icons.book, color: Colors.white),
                            title: Text(
                              books[index],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // BUTTONS
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _pickFile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0x88262C4F),
                        ),
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text('Add Book'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (books.isNotEmpty) {
                            setState(() {
                              books.removeLast();
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Removed last book'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0x88262C4F),
                        ),
                        icon: const Icon(Icons.remove, color: Colors.white),
                        label: const Text('Remove Book'),
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
