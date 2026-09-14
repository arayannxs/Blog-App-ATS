import 'package:flutter/material.dart';

class CreatePostPage extends StatelessWidget {
  const CreatePostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Koleksi Baru'),
        backgroundColor: const Color(0xFF003875),
      ),
      body: const Center(
        child: Text('Halaman Form Tambah Koleksi'),
      ),
    );
  }
}