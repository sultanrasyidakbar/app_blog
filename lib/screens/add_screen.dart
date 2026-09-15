import 'package:flutter/material.dart';
import '../models/post.dart';
import '../models/category.dart';
import '../services/api_services.dart';

class PostFormScreen extends StatefulWidget {
  final Post? existingPost;
  const PostFormScreen({super.key, this.existingPost});

  @override
  State<PostFormScreen> createState() => _PostFormScreenState();
}

class _PostFormScreenState extends State<PostFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _thumbnailController = TextEditingController();

  late Future<List<Category>> _futureCategories;
  int? _selectedCategoryId;
  bool _isSaving = false;

  bool get isEditMode => widget.existingPost != null;

  @override
  void initState() {
    super.initState();
    _futureCategories = ApiService.getCategories();

    if (isEditMode) {
      final post = widget.existingPost!;
      _titleController.text = post.title;
      _contentController.text = post.content;
      _thumbnailController.text = post.thumbnail ?? '';
      _selectedCategoryId = post.categoryId;
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pilih kategori dulu')));
      return;
    }

    setState(() => _isSaving = true);

    final post = Post(
      id: widget.existingPost?.id ?? 0,
      categoryId: _selectedCategoryId!,
      categoryName: '',
      title: _titleController.text,
      content: _contentController.text,
      thumbnail: _thumbnailController.text.isEmpty
          ? null
          : _thumbnailController.text,
    );

    try {
      if (isEditMode) {
        await ApiService.updatePost(widget.existingPost!.id, post);
      } else {
        await ApiService.createPost(post);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Artikel' : 'Tambah Artikel'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colorScheme.primary.withValues(alpha: 0.12),
                        colorScheme.secondary.withValues(alpha: 0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: colorScheme.primary,
                        child: Icon(
                          isEditMode
                              ? Icons.edit_note_rounded
                              : Icons.post_add_rounded,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          isEditMode ? 'Perbarui artikel' : 'Buat artikel baru',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Judul artikel',
                    prefixIcon: Icon(Icons.title_rounded),
                  ),
                  validator: (value) =>
                      (value == null || value.trim().length < 3)
                      ? 'Judul minimal 3 karakter'
                      : null,
                ),
                const SizedBox(height: 16),
                FutureBuilder<List<Category>>(
                  future: _futureCategories,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: LinearProgressIndicator(),
                      );
                    }

                    final categories = snapshot.data!;
                    final uniqueCategories = categories.fold<List<Category>>(
                      <Category>[],
                      (list, category) {
                        final exists = list.any(
                          (item) =>
                              item.id == category.id ||
                              item.name.toLowerCase() ==
                                  category.name.toLowerCase(),
                        );
                        if (!exists) {
                          list.add(category);
                        }
                        return list;
                      },
                    );
                    final displayCategories = uniqueCategories.take(3).toList();

                    if (_selectedCategoryId == null &&
                        displayCategories.isNotEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted && _selectedCategoryId == null) {
                          setState(
                            () => _selectedCategoryId =
                                displayCategories.first.id,
                          );
                        }
                      });
                    }

                    final selectedCategory = displayCategories.firstWhere(
                      (item) => item.id == _selectedCategoryId,
                      orElse: () => Category(id: 0, name: 'Pilih kategori'),
                    );

                    return InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                          ),
                          builder: (sheetContext) {
                            return SafeArea(
                              child: SizedBox(
                                height: 420,
                                child: Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Text(
                                        'Pilih Kategori',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.separated(
                                        itemCount: displayCategories.length,
                                        separatorBuilder: (_, _) =>
                                            const Divider(height: 1),
                                        itemBuilder: (context, index) {
                                          final category =
                                              displayCategories[index];
                                          final isSelected =
                                              category.id ==
                                              _selectedCategoryId;

                                          return ListTile(
                                            title: Text(category.name),
                                            trailing: isSelected
                                                ? const Icon(Icons.check)
                                                : null,
                                            onTap: () {
                                              setState(
                                                () => _selectedCategoryId =
                                                    category.id,
                                              );
                                              Navigator.pop(sheetContext);
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Kategori',
                          prefixIcon: Icon(Icons.category_rounded),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                selectedCategory.id == 0
                                    ? 'Pilih kategori'
                                    : selectedCategory.name,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    labelText: 'Konten artikel',
                    prefixIcon: Icon(Icons.notes_rounded),
                  ),
                  maxLines: 7,
                  validator: (value) =>
                      (value == null || value.trim().length < 10)
                      ? 'Konten minimal 10 karakter'
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _thumbnailController,
                  decoration: const InputDecoration(
                    labelText: 'URL Thumbnail (opsional)',
                    prefixIcon: Icon(Icons.image_rounded),
                  ),
                ),
                const SizedBox(height: 28),
                SizedBox(
                  height: 56,
                  child: FilledButton.icon(
                    onPressed: _isSaving ? null : _handleSubmit,
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    icon: _isSaving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save_rounded),
                    label: Text(
                      _isSaving
                          ? 'Menyimpan...'
                          : (isEditMode
                                ? 'Simpan Perubahan'
                                : 'Simpan Artikel'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
