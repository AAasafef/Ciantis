import 'package:flutter/material.dart';
import '../../data/services/service_service.dart';
import '../../data/models/service_model.dart';
import '../../data/models/service_category_model.dart';

class ServiceEditScreen extends StatefulWidget {
  final String? serviceId;

  const ServiceEditScreen({super.key, this.serviceId});

  @override
  State<ServiceEditScreen> createState() => _ServiceEditScreenState();
}

class _ServiceEditScreenState extends State<ServiceEditScreen> {
  final ServiceService _serviceService = ServiceService();

  bool _loading = true;
  bool _saving = false;

  List<ServiceCategoryModel> _categories = [];
  ServiceModel? _service;

  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _priceCtrl = TextEditingController();
  final TextEditingController _durationCtrl = TextEditingController();
  final TextEditingController _notesCtrl = TextEditingController();

  String? _selectedCategoryId;
  String? _overrideColor;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final cats = await _serviceService.getAllCategories();

    ServiceModel? service;
    if (widget.serviceId != null) {
      final all = await _serviceService.getAllServices();
      service = all.firstWhere((s) => s.id == widget.serviceId);
    }

    setState(() {
      _categories = cats;
      _service = service;
      _loading = false;
    });

    if (service != null) {
      _nameCtrl.text = service.name;
      _priceCtrl.text = service.price.toStringAsFixed(2);
      _durationCtrl.text = service.duration.toString();
      _notesCtrl.text = service.notes ?? "";
      _selectedCategoryId = service.categoryId;
      _overrideColor = service.color;
    }
  }

  Future<void> _save() async {
    if (_saving) return;

    final name = _nameCtrl.text.trim();
    final price = double.tryParse(_priceCtrl.text.trim()) ?? 0;
    final duration = int.tryParse(_durationCtrl.text.trim()) ?? 0;

    if (name.isEmpty || price <= 0 || duration <= 0 || _selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields")),
      );
      return;
    }

    setState(() => _saving = true);

    if (_service == null) {
      // CREATE
      await _serviceService.createService(
        categoryId: _selectedCategoryId!,
        name: name,
        price: price,
        duration: duration,
        notes: _notesCtrl.text.trim(),
        overrideColor: _overrideColor,
      );
    } else {
      // UPDATE
      final updated = _service!.copyWith(
        categoryId: _selectedCategoryId,
        name: name,
        price: price,
        duration: duration,
        notes: _notesCtrl.text.trim(),
        color: _overrideColor,
      );
      await _serviceService.updateService(updated);
    }

    if (mounted) Navigator.pop(context);
  }

  Widget _categoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCategoryId,
      decoration: InputDecoration(
        labelText: "Category",
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE8E2F0)),
        ),
      ),
      items: _categories.map((c) {
        return DropdownMenuItem(
          value: c.id,
          child: Text(c.name),
        );
      }).toList(),
      onChanged: (v) {
        setState(() => _selectedCategoryId = v);
      },
    );
  }

  Widget _colorPreview() {
    final colorHex = _overrideColor ??
        (_selectedCategoryId == null
            ? "#8A4FFF"
            : _categories.firstWhere((c) => c.id == _selectedCategoryId!).color);

    final color = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));

    return GestureDetector(
      onTap: () {
        // Simple color override picker
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Override Color"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _colorOption("#8A4FFF"),
                _colorOption("#B76EFF"),
                _colorOption("#E573B5"),
                _colorOption("#5A4A6A"),
                _colorOption("#D8C7F5"),
              ],
            ),
          ),
        );
      },
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Center(
          child: Text(
            "Tap to change color",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _colorOption(String hex) {
    return GestureDetector(
      onTap: () {
        setState(() => _overrideColor = hex);
        Navigator.pop(context);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        height: 40,
        decoration: BoxDecoration(
          color: Color(int.parse(hex.replaceFirst('#', '0xFF'))),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  Widget _recommendedPriceBanner() {
    if (_service == null) return const SizedBox.shrink();

    final recommended = _serviceService.recommendedPrice(_service!);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF8A4FFF).withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        "Recommended price: \$${recommended.toStringAsFixed(2)}",
        style: const TextStyle(
          color: Color(0xFF5A4A6A),
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF7F4F9),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF7F4F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          _service == null ? "New Service" : "Edit Service",
          style: const TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _recommendedPriceBanner(),

            _categoryDropdown(),
            const SizedBox(height: 20),

            TextField(
              controller: _nameCtrl,
              decoration: _input("Service Name"),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _priceCtrl,
              keyboardType: TextInputType.number,
              decoration: _input("Price (\$)"),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _durationCtrl,
              keyboardType: TextInputType.number,
              decoration: _input("Duration (minutes)"),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _notesCtrl,
              maxLines: 3,
              decoration: _input("Notes (optional)"),
            ),
            const SizedBox(height: 20),

            _colorPreview(),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8A4FFF),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  _saving ? "Saving..." : "Save",
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _input(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE8E2F0)),
      ),
    );
  }
}
