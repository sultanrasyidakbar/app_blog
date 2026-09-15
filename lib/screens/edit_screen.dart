import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../constants.dart';

class EditPostScreen extends StatefulWidget {
  final Map post;
  const EditPostScreen({super.key, required this.post});

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  late final titleController = TextEditingController(
    text: widget.post['title'],
  );
  late final contentController = TextEditingController(
    text: widget.post['content'],
  );

  List categories = [];
  int? selectedCategoryId;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    selectedCategoryId = widget.post['category_id'];
    getCategories();
  }

  Future<void> getCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories'));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      setState(() => categories = body['data']);
    }
  }

  Future<void> updatePost() async {
    setState(() => isSaving = true);

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/posts/${widget.post['id']}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': titleController.text,
          'content': contentController.text,
          'category_id': selectedCategoryId,
        }),
      );

      setState(() => isSaving = false);

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Artikel berhasil diperbarui')),
          );
          Navigator.pop(context, true);
        }
      } else {
        final body = jsonDecode(response.body);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(body['message'] ?? 'Gagal memperbarui artikel'),
            ),
          );
        }
      }
    } catch (e) {
      setState(() => isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Terjadi kesalahan: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Artikel')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Judul Artikel'),
            ),
            TextField(
              controller: contentController,
              maxLines: 5,
              decoration: const InputDecoration(labelText: 'Isi Artikel'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              initialValue: selectedCategoryId,
              decoration: const InputDecoration(labelText: 'Kategori'),
              items: categories.map<DropdownMenuItem<int>>((category) {
                return DropdownMenuItem<int>(
                  value: category['id'],
                  child: Text(category['name']),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedCategoryId = value),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isSaving ? null : updatePost,
              child: isSaving
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Perbarui'),
            ),
          ],
        ),
      ),
    );
  }
}
