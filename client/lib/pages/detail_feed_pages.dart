import 'package:flutter/material.dart';
import '../models/post_model.dart'; 

class DetailPostPage extends StatelessWidget {
  final Post post;

  const DetailPostPage({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Warna background abu-abu sangat muda
      appBar: AppBar(
        title: const Text('Detail Artikel'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF003875),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Gambar Banner (Full Width)
            Container(
              width: double.infinity,
              height: 260,
              decoration: BoxDecoration(
                color: const Color(0xFF0066FF).withOpacity(0.1),
              ),
              child: post.imageUrl != null && post.imageUrl!.isNotEmpty
                  ? Image.network(
                      post.imageUrl!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Center(
                        child: Icon(
                          Icons.menu_book,
                          color: Color(0xFF003875),
                          size: 80,
                        ),
                      ),
                    )
                  : const Center(
                      child: Icon(
                        Icons.menu_book,
                        color: Color(0xFF003875),
                        size: 80,
                      ),
                    ),
            ),

            // 2. Area Konten Artikel
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tag Kategori & Status
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0066FF).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          post.category?.categoryName ?? 'Tanpa Kategori',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF003875),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          post.status, // Misal: "Tersedia"
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.amber.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Judul Artikel
                  Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003875),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Info Tambahan (Tanggal)
                  Text(
                    'Dibuat pada: ${post.createdAt}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(height: 1, thickness: 1),
                  ),

                  // Isi Artikel
                  Text(
                    post.content,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6, // Jarak antar baris teks biar nyaman dibaca
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}