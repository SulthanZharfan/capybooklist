import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import '../models/book.dart';

class ReaderScreen extends StatelessWidget {
  final Book book;

  const ReaderScreen({Key? key, required this.book}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // DEBUG LOG - biar pemula bisa lihat apa yang dikirim
    print('=== READER SCREEN ===');
    print('Judul Buku: ${book.title}');
    print('File Path: ${book.filePath}');
    print('File Type: ${book.fileType}');

    // ✅ CEK kalau path kosong
    if (book.filePath.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Reading: ${book.title}')),
        body: Center(
          child: Text(
            '⚠️ ERROR: Path file kosong!\n\nBook tidak punya path file PDF.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    // ✅ CEK kalau file benar-benar ada
    final file = File(book.filePath);
    if (!file.existsSync()) {
      return Scaffold(
        appBar: AppBar(title: Text('Reading: ${book.title}')),
        body: Center(
          child: Text(
            '⚠️ ERROR: File tidak ditemukan di path berikut:\n\n${book.filePath}',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    // ✅ Kalau path valid & file exist ➜ tampilkan PDF
    return Scaffold(
      appBar: AppBar(
        title: Text('Reading: ${book.title}'),
      ),
      body: PDFView(
        filePath: book.filePath,
        enableSwipe: true,
        swipeHorizontal: true,
        autoSpacing: false,
        pageFling: true,
        onRender: (_pages) {
          print('✅ PDF berhasil dirender!');
        },
        onError: (error) {
          print('❌ PDFView error: $error');
        },
        onPageError: (page, error) {
          print('❌ Error di halaman $page: $error');
        },
      ),
    );
  }
}
