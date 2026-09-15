import 'dart:convert';
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;
import 'package:http/http.dart' as http;
import '../models/post.dart';
import '../models/category.dart';

class ApiService {
  // HP dan laptop harus berada pada jaringan Wi-Fi yang sama.
  static const String _androidBaseUrl = 'http://192.168.1.21:3000/api';

  static String get baseUrl {
    if (kIsWeb) {
      return 'http://localhost:3000/api';
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return _androidBaseUrl;
    }

    return 'http://localhost:3000/api';
  }

  // untuk ambil semua artikel
  static Future<List<Post>> getPosts() async {
    final response = await http
        .get(Uri.parse('$baseUrl/posts'))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List data = body['data'];
      return data.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception(
        'gagal mengambil daftar artikel (${response.statusCode})',
      );
    }
  }

  // untuk mengambil detail 1 artikel
  static Future<Post> getPostDetail(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/posts/$id'));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return Post.fromJson(body['data']);
    } else {
      throw Exception(
        'gagal mengambil detail artikel (${response.statusCode})',
      );
    }
  }

  // untuk membuat artikel baru
  static Future<void> createPost(Post post) async {
    final response = await http.post(
      Uri.parse('$baseUrl/posts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(post.toJson()),
    );

    if (response.statusCode != 201) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'gagal membuat artikel');
    }
  }

  // mengedit artikel
  static Future<void> updatePost(int id, Post post) async {
    final response = await http.put(
      Uri.parse('$baseUrl/posts/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(post.toJson()),
    );

    if (response.statusCode != 200) {
      final body = jsonDecode(response.body);
      throw Exception(body['message'] ?? 'gagal update artikel');
    }
  }

  // menghapus artikel
  static Future<void> deletePost(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/posts/$id'));

    if (response.statusCode != 200) {
      throw Exception('gagal menghapus artikel (${response.statusCode})');
    }
  }

  // untuk mengambil semua kategori (dipakai buat dropdown di form)
  static Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories'));

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List data = body['data'];
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception(
        'gagal mengambil daftar kategori (${response.statusCode})',
      );
    }
  }
}
