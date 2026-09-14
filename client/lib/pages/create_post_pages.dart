import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/post_service.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isLoading = false;

  void _handleSubmit() async {
    String title = _titleController.text.trim();
    String content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul dan deskripsi wajib diisi!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Paste Token JWT asli (hasil login dari Postman)
    String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwidXNlcm5hbWUiOiJKb2huIERvZSIsImVtYWlsIjoiam9obmRvZUBnbWFpbC5jb20iLCJyb2xlIjoidXNlciIsImlhdCI6MTc4OTQxNDc0OSwiZXhwIjoxNzkwMDE5NTQ5fQ.P_GBR4YQvAqaRig_h710XmeCAsATUNkO1fXUI9KasEE';
    String userId = '2'; 

    // Panggil createPost dengan parameter yang sesuai dengan PostService kamu
    bool success = await PostService().createPost(
      token: token,       // Sesuaikan jika sudah ada sistem auth/token
      userId: userId,     // Sesuaikan ID user login
      title: title,
      content: content,
      categoryId: '1',   // ID kategori default
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Koleksi berhasil ditambahkan!')),
      );
      Navigator.pop(context, true); // Kembali dan trigging refresh di FeedPage
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menambahkan koleksi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyleWorkSans = GoogleFonts.workSans();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF003875),
        elevation: 0,
        title: Text(
          'Tambah Koleksi Baru',
          style: textStyleWorkSans.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Judul Koleksi',
              style: textStyleWorkSans.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF003875),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Contoh: Buku Literatur Riset #5',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Deskripsi / Detail Koleksi',
              style: textStyleWorkSans.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF003875),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _contentController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Masukkan deskripsi rinci koleksi digital ini...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF003875),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _isLoading ? null : _handleSubmit,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Simpan Koleksi',
                        style: textStyleWorkSans.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}