import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';
import 'dart:typed_data';

class PostService {
  // Gunakan 10.0.2.2 untuk Android Emulator
  final String baseUrl = 'http://localhost:5000/api/v1/posts';

  // Get All Posts
  Future<List<Post>> getPosts() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> postsJson = body['data']['posts'];
        return postsJson.map((json) => Post.fromJson(json)).toList();
      } else {
        throw Exception('Gagal mengambil data postingan');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Create Post (Multipart)
  // Create Post (Multipart)
  Future<bool> createPost({
    required String token,
    required String userId,
    required String title,
    required String content,
    required String categoryId,
    Uint8List? imageBytes, // <--- Ganti imagePath jadi imageBytes
    String? imageName,     // <--- Tambahkan imageName
  }) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
      request.headers['Authorization'] = 'Bearer $token';

      request.fields['userId'] = userId;
      request.fields['title'] = title;
      request.fields['content'] = content;
      request.fields['categoryId'] = categoryId;

      // Logika Upload Gambar via Bytes (Aman untuk Flutter Web & Mobile)
      if (imageBytes != null && imageName != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'image', // Sesuaikan dengan key multer backend (biasanya 'image' atau 'file')
            imageBytes,
            filename: imageName,
          ),
        );
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // Print untuk debug respons backend di Console
      print('STATUS CODE: ${response.statusCode}');
      print('RESPONSE BODY: ${response.body}');

      return response.statusCode == 201 || response.statusCode == 200;
    } catch (e) {
      print('ERROR CREATE POST: $e');
      return false;
    }
  }
}