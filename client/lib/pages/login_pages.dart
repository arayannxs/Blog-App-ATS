import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart'; // Impor AuthService untuk login
import 'register_pages.dart'; // Impor register_pages untuk navigasi
import 'feed_pages.dart'; // Impor feed_pages untuk navigasi setelah login berhasil

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  void _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email dan password wajib diisi')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final result = await AuthService().login(
      _emailController.text,
      _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (result['success']) {
      final prefs = await SharedPreferences.getInstance();

      // 1. Ambil token & userId secara aman (pake null check ??)
      final data = result['data'];
      final token = data?['token']?.toString() ?? '';

      // Cek apakah 'user' ada atau langsung 'userId' / 'id' dari data
      final userId =
          data?['user']?['id']?.toString() ?? data?['id']?.toString() ?? '';

      // 2. Simpan ke SharedPreferences
      await prefs.setString('token', token);
      await prefs.setString('userId', userId);

      if (!mounted) return;

      // 3. Tampilkan pesan sukses
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Login Berhasil!')));

      // 4. Pindah ke FeedPage
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const FeedPage()),
        (route) => false,
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Login Gagal')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Style teks Google Fonts Work Sans
    final textStyleWorkSans = GoogleFonts.workSans(color: Colors.white);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0066FF), // Biru terang atas
              Color(0xFF003366), // Biru tengah pekat
              Color(0xFF001F3F), // Biru gelap bawah
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Ratakan teks label ke kiri
            children: [
              const SizedBox(height: 50),
              // Ikon Kembali
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: 30,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              const SizedBox(height: 10),
              // Logo
              Center(
                child: Image.asset(
                  'assets/images/libsmart_logo.png',
                  width: 320,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 10),
              // Teks Sapaan
              Center(
                child: Text(
                  'Selamat Datang di LIBSMART APP!',
                  style: textStyleWorkSans.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // LABEL EMAIL
              Text(
                'Email:',
                style: textStyleWorkSans.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              // INPUT EMAIL (Username placeholder di gambar)
              TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.black), // Teks input hitam
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Masukkan Email....', // Teks placeholder
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    color: Colors.grey,
                  ),
                  contentPadding: const EdgeInsets.all(18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // LABEL PASSWORD
              Text(
                'Password:',
                style: textStyleWorkSans.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              // INPUT PASSWORD
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: '• • • • • • • •', // Teks placeholder password
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 18),
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: Colors.grey,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // TOMBOL LOG IN (Gradient Gold)
              Center(
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Container(
                        width: 250,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFFB58931), // Gold gelap kiri
                              Color(0xFFE9C874), // Gold terang tengah
                              Color(0xFFB58931), // Gold gelap kanan
                            ],
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: ElevatedButton(
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            'Log In',
                            style: GoogleFonts.workSans(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
              ),
              const SizedBox(height: 20),

              // TEKS NAVIGASI KE REGISTER
              Center(
                child: TextButton(
                  onPressed: () {
                    // Pindah ke halaman Register
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
                  child: Text(
                    'Belum Punya Akun? Register',
                    style: GoogleFonts.workSans(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
