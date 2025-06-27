import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Capybooklist'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Belum ada buku ditambahkan',
          style: TextStyle(fontSize: 16),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigasi ke BookFormScreen
        },
        tooltip: 'Tambah Buku',
        child: const Icon(Icons.add),
      ),
    );
  }
}
