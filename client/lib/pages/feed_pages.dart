import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/post_service.dart';
import '../models/post_model.dart';
import 'create_post_pages.dart';
import 'detail_feed_pages.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  // Fungsi fetch data dari API
  void _fetchPosts() {
    setState(() {
      _postsFuture = PostService().getPosts();
    });
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
          'LIBSMART FEEDS',
          style: textStyleWorkSans.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _fetchPosts(), // Fitur Tarik untuk Refresh
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. BANNER UTAMA
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/banner.png',
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),

              // 2. SEARCH BAR
              TextField(
                decoration: InputDecoration(
                  hintText: 'Cari buku, jurnal, atau artikel...',
                  hintStyle: textStyleWorkSans.copyWith(
                    color: Colors.grey.shade500,
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 3. JUDUL KATEGORI / FEED KOLEKSI
              Text(
                'Rekomendasi Koleksi',
                style: textStyleWorkSans.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF003875),
                ),
              ),
              const SizedBox(height: 12),

              // 4. DAFTAR FEED / BUKU (DINAMIS DARI API)
              FutureBuilder<List<Post>>(
                future: _postsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text('Gagal memuat data: ${snapshot.error}'),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(child: Text('Belum ada koleksi tersedia.')),
                    );
                  }

                  final posts = snapshot.data!;

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final item = posts[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () async {
                            // Navigasi ke halaman detail dengan data post
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailPostPage(post: item),
                              ),
                            );

                            // Jika menerima perintah delete dari Detail Page
                            if (result != null &&
                                result['action'] == 'delete') {
                              setState(() {
                                posts.remove(
                                  item,
                                ); // Menghapus item dari daftar postingan
                              });
                            }
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                // 1. Gambar Sampul / Icon Buku
                                Container(
                                  width: 65,
                                  height: 85,
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xFF0066FF,
                                    ).withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child:
                                        item.imageUrl != null &&
                                            item.imageUrl!.isNotEmpty
                                        ? Image.network(
                                            item.imageUrl!,
                                            width: 65,
                                            height: 85,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    const Icon(
                                                      Icons.menu_book,
                                                      color: Color(0xFF003875),
                                                      size: 30,
                                                    ),
                                          )
                                        : const Icon(
                                            Icons.menu_book,
                                            color: Color(0xFF003875),
                                            size: 30,
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // 2. Judul, Content, & Tag Status
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.title,
                                        style: textStyleWorkSans.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item.content,
                                        style: textStyleWorkSans.copyWith(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.amber.shade100,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Text(
                                          'Tersedia',
                                          style: textStyleWorkSans.copyWith(
                                            fontSize: 10,
                                            color: Colors.amber.shade900,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // 3. Panah Kanan
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      // 5. TOMBOL TAMBAH BUKU BARU (FLOATING ACTION BUTTON)
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF003875),
        onPressed: () async {
          // Pindah ke halaman CreatePostPage
          final refreshed = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreatePostPage()),
          );

          // Jika berhasil submit (mengembalikan true), refresh daftar postingan
          if (refreshed == true) {
            _fetchPosts(); // Refresh list otomatis setelah insert berhasil
          }
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
