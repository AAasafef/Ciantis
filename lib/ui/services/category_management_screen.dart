import 'package:flutter/material.dart';
import '../../data/services/service_service.dart';
import '../../data/models/service_category_model.dart';

class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({super.key});

  @override
  State<CategoryManagementScreen> createState() =>
      _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  final ServiceService _serviceService = ServiceService();

  List<ServiceCategoryModel> _categories = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final cats = await _serviceService.getAllCategories();
    setState(() {
      _categories = cats;
      _loading = false;
    });
  }

  Future<void> _openEditor({ServiceCategoryModel? category}) async {
    await showDialog(
      context: context,
      builder: (_) => _CategoryEditorDialog(category: category),
    );
    _load();
  }

  Future<void> _deleteCategory(String id) async {
    await _serviceService.deleteCategory(id);
    _load();
  }

  Widget _categoryTile(ServiceCategoryModel c) {
    final color = Color(int.parse(c.color.replaceFirst('#', '0xFF')));

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8E2F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Color preview
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(width: 16),

          // Name + description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.name,
                  style: const TextStyle(
                    color: Color(0xFF5A4A6A),
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                if (c.description != null && c.description!.trim().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      c.description!,
                      style: const TextStyle(
                        color: Color(0xFF7A6F8F),
                        fontSize: 13,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Edit button
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF8A4FFF)),
            onPressed: () => _openEditor(category: c),
          ),

          // Delete button
          IconButton(
            icon: const Icon(Icons.delete, color: Color(0xFFE57373)),
            onPressed: () => _deleteCategory(c.id),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Categories",
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF8A4FFF),
        onPressed: () => _openEditor(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _categories.isEmpty
              ? const Center(
                  child: Text(
                    "No categories yet",
                    style: TextStyle(
                      color: Color(0xFF7A6F8F),
                      fontSize: 16,
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: _categories.map(_categoryTile).toList(),
                ),
    );
  }
}

class _CategoryEditorDialog extends StatefulWidget {
  final ServiceCategoryModel? category;

  const _CategoryEditorDialog({this.category});

  @override
  State<_CategoryEditorDialog> createState() => _CategoryEditorDialogState();
}

class _CategoryEditorDialogState extends State<_CategoryEditorDialog> {
  final ServiceService _serviceService = ServiceService();

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final TextEditingController _sortCtrl = TextEditingController();

  String _color = "#8A4FFF";

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      final c = widget.category!;
      _nameCtrl.text = c.name;
      _descCtrl.text = c.description ?? "";
      _sortCtrl.text = c.sortOrder.toString();
      _color = c.color;
    }
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    final sort = int.tryParse(_sortCtrl.text.trim()) ?? 0;

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Name is required")),
      );
      return;
    }

    if (widget.category == null) {
      // CREATE
      await _serviceService.createCategory(
        name: name,
        description: _descCtrl.text.trim(),
        color: _color,
        sortOrder: sort,
      );
    } else {
      // UPDATE
      final updated = widget.category!.copyWith(
        name: name,
        description: _descCtrl.text.trim(),
        color: _color,
        sortOrder: sort,
        updatedAt: DateTime.now(),
      );
      await _serviceService.updateCategory(updated);
    }

    if (mounted) Navigator.pop(context);
  }

  Widget _colorOption(String hex) {
    return GestureDetector(
      onTap: () => setState(() => _color = hex),
      child: Container(
        margin: const EdgeInsets.only(right: 10, bottom: 10),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Color(int.parse(hex.replaceFirst('#', '0xFF'))),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _color == hex ? Colors.black : Colors.transparent,
            width: 2,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.category == null ? "New Category" : "Edit Category",
        style: const TextStyle(
          color: Color(0xFF5A4A6A),
          fontWeight: FontWeight.w700,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: _descCtrl,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            TextField(
              controller: _sortCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Sort Order"),
            ),
            const SizedBox(height: 20),

            // Color picker
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Color",
                style: TextStyle(
                  color: Color(0xFF5A4A6A),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              children: [
                _colorOption("#8A4FFF"),
                _colorOption("#B76EFF"),
                _colorOption("#E573B5"),
                _colorOption("#5A4A6A"),
                _colorOption("#D8C7F5"),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF8A4FFF),
          ),
          onPressed: _save,
          child: const Text("Save"),
        ),
      ],
    );
  }
}
