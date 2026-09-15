import 'package:flutter/material.dart';
import '../models/post.dart';
import '../services/api_services.dart';
import 'detail_screen.dart';
import 'add_screen.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({super.key});

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  late Future<List<Post>> _futurePosts;

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  void _loadPosts() {
    setState(() {
      _futurePosts = ApiService.getPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => _loadPosts(),
        child: FutureBuilder<List<Post>>(
          future: _futurePosts,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.wifi_off_rounded,
                      size: 52,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Gagal memuat data',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text('${snapshot.error}', textAlign: TextAlign.center),
                  ],
                ),
              );
            }

            final posts = snapshot.data ?? [];
            if (posts.isEmpty) {
              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const SizedBox(height: 30),
                  _buildHeader(colorScheme),
                  const SizedBox(height: 120),
                  const Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.article_outlined,
                          size: 56,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 12),
                        Text('Belum ada artikel'),
                      ],
                    ),
                  ),
                ],
              );
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
              children: [
                _buildHeader(colorScheme),
                const SizedBox(height: 20),
                ...posts.map((post) => _buildPostCard(context, post)),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PostFormScreen()),
          );
          _loadPosts();
        },
        icon: const Icon(Icons.add),
        label: const Text('Artikel'),
      ),
    );
  }

  Widget _buildHeader(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [colorScheme.primary, colorScheme.secondary],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.25),
            blurRadius: 20,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.auto_stories_rounded,
                  color: Colors.white,
                ),
              ),
              const Spacer(),
              const Icon(Icons.notifications_none_rounded, color: Colors.white),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'Mobile ATS',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Kelola konten artikel dengan lebih cepat dan rapi',
            style: TextStyle(color: Color(0xFFE0E7FF), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(BuildContext context, Post post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PostDetailScreen(postId: post.id),
            ),
          );
          _loadPosts();
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.2),
                      Theme.of(
                        context,
                      ).colorScheme.secondary.withValues(alpha: 0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  Icons.article_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.categoryName,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      post.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      post.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 8, top: 8),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
