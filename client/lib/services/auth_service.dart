import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // Base URL penampung alamat utama API Auth Express (10.0.2.2 khusus Android Emulator)
  final String baseUrl = 'http://localhost:5000/api/v1/auth';

  // Fungsi Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true, 
          'data': data
        };
      } else {
        return {
          'success': false, 
          'message': data['message'] ?? 'Login gagal'
        };
      }
    } catch (e) {
      return {
        'success': false, 
        'message': 'Gagal terhubung ke server: $e'
      };
    }
  }
}