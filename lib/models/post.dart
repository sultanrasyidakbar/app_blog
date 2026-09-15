class Post {
  final int id;
  final int categoryId;
  final String categoryName;
  final String title;
  final String content;
  final String? thumbnail;

  Post({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.title,
    required this.content,
    this.thumbnail,
  });

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: _toInt(json['id']),
      categoryId: _toInt(json['category_id']),
      categoryName: (json['category_name'] ?? json['category'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      content: (json['content'] ?? '').toString(),
      thumbnail: json['thumbnail']?.toString(),
    );
  }

  // dipakai waktu kirim data create/update ke API
  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'title': title,
      'content': content,
      if (thumbnail != null && thumbnail!.isNotEmpty) 'thumbnail': thumbnail,
    };
  }
}
