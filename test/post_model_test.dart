import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_ats/models/post.dart';

void main() {
  test('Post parses MySQL API response', () {
    final post = Post.fromJson({
      'id': 7,
      'category_id': 2,
      'category_name': 'lifestyle',
      'title': 'Tips Produktif',
      'content': 'Isi artikel',
      'thumbnail': null,
    });

    expect(post.id, 7);
    expect(post.categoryId, 2);
    expect(post.categoryName, 'lifestyle');
    expect(post.title, 'Tips Produktif');
    expect(post.thumbnail, isNull);
  });

  test('Post serializes only fields accepted by the API', () {
    final json = Post(
      id: 0,
      categoryId: 1,
      categoryName: '',
      title: 'Judul',
      content: 'Konten artikel',
    ).toJson();

    expect(json, {
      'category_id': 1,
      'title': 'Judul',
      'content': 'Konten artikel',
    });
  });
}
