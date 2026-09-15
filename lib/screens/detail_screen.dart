import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_services.dart';
import 'add_screen.dart';

class PostDetailScreen extends StatefulWidget {
  final int postId;
  const PostDetailScreen({super.key, required this.postId});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late Future<Post> _futurePost;

  @override
  void initState() {
    super.initState();
    _futurePost = ApiService.getPostDetail(widget.postId);
  }

  Future<void> _handleDelete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus artikel?'),
        content: const Text('Artikel yang dihapus tidak bisa dikembalikan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await ApiService.deletePost(widget.postId);
        if (mounted) Navigator.pop(context);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('$e')));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Artikel'),
        actions: [
          IconButton(
            tooltip: 'Edit artikel',
            icon: const Icon(Icons.edit_rounded),
            onPressed: () async {
              final navigator = Navigator.of(context);
              final post = await _futurePost;
              if (!mounted) return;
              await navigator.push(
                MaterialPageRoute(
                  builder: (_) => PostFormScreen(existingPost: post),
                ),
              );
              if (!mounted) return;
              setState(() {
                _futurePost = ApiService.getPostDetail(widget.postId);
              });
            },
          ),
          IconButton(
            tooltip: 'Hapus artikel',
            icon: const Icon(Icons.delete_rounded),
            onPressed: _handleDelete,
          ),
        ],
      ),
      body: FutureBuilder<Post>(
        future: _futurePost,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final post = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (post.thumbnail != null && post.thumbnail!.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Image.network(
                      post.thumbnail!,
                      width: double.infinity,
                      height: 220,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 220,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              colorScheme.primary.withValues(alpha: 0.15),
                              colorScheme.secondary.withValues(alpha: 0.15),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: const Center(
                          child: Icon(Icons.image_not_supported_outlined),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    post.categoryName,
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  post.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Text(
                    post.content,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.75,
                      color: const Color(0xFF374151),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
