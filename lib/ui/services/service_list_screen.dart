import 'package:flutter/material.dart';
import '../../data/services/service_service.dart';
import '../../data/models/service_model.dart';
import '../../data/models/service_category_model.dart';
import 'service_edit_screen.dart';

class ServiceListScreen extends StatefulWidget {
  const ServiceListScreen({super.key});

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  final ServiceService _serviceService = ServiceService();

  List<ServiceCategoryModel> _categories = [];
  List<ServiceModel> _services = [];
  List<ServiceModel> _filtered = [];

  bool _loading = true;
  String? _selectedCategoryId;

  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final cats = await _serviceService.getAllCategories();
    final serv = await _serviceService.getAllServices();

    setState(() {
      _categories = cats;
      _services = serv;
      _filtered = serv;
      _loading = false;
    });
  }

  void _filter() {
    List<ServiceModel> list = _services;

    // Category filter
    if (_selectedCategoryId != null) {
      list = list
          .where((s) => s.categoryId == _selectedCategoryId)
          .toList();
    }

    // Search filter
    final q = _searchCtrl.text.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((s) {
        return s.name.toLowerCase().contains(q) ||
            (s.notes ?? "").toLowerCase().contains(q);
      }).toList();
    }

    setState(() => _filtered = list);
  }

  Future<void> _sortPrice(bool ascending) async {
    final sorted = await _serviceService.sortByPrice(ascending: ascending);
    setState(() {
      _services = sorted;
    });
    _filter();
  }

  Future<void> _sortDuration(bool ascending) async {
    final sorted = await _serviceService.sortByDuration(ascending: ascending);
    setState(() {
      _services = sorted;
    });
    _filter();
  }

  Widget _categoryChip(ServiceCategoryModel c) {
    final selected = _selectedCategoryId == c.id;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCategoryId = selected ? null : c.id;
        });
        _filter();
      },
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? Color(int.parse(c.color.replaceFirst('#', '0xFF')))
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Color(int.parse(c.color.replaceFirst('#', '0xFF'))),
          ),
        ),
        child: Text(
          c.name,
          style: TextStyle(
            color: selected ? Colors.white : Color(int.parse(c.color.replaceFirst('#', '0xFF'))),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _serviceTile(ServiceModel s) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ServiceEditScreen(serviceId: s.id),
          ),
        );
        _loadData();
      },
      child: Container(
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
            // Left: name + notes
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF5A4A6A),
                    ),
                  ),
                  if (s.notes != null && s.notes!.trim().isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        s.notes!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF7A6F8F),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Right: price + duration
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "\$${s.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Color(0xFF8A4FFF),
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${s.duration} min",
                  style: const TextStyle(
                    color: Color(0xFF7A6F8F),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
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
          "Services",
          style: TextStyle(
            color: Color(0xFF8A4FFF),
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort, color: Color(0xFF8A4FFF)),
            onSelected: (v) {
              if (v == "price_asc") _sortPrice(true);
              if (v == "price_desc") _sortPrice(false);
              if (v == "duration_asc") _sortDuration(true);
              if (v == "duration_desc") _sortDuration(false);
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: "price_asc", child: Text("Price: Low → High")),
              const PopupMenuItem(value: "price_desc", child: Text("Price: High → Low")),
              const PopupMenuItem(value: "duration_asc", child: Text("Duration: Short → Long")),
              const PopupMenuItem(value: "duration_desc", child: Text("Duration: Long → Short")),
            ],
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Search bar
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (_) => _filter(),
                    decoration: InputDecoration(
                      hintText: "Search services...",
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.search,
                          color: Color(0xFF8A4FFF)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide:
                            const BorderSide(color: Color(0xFFE8E2F0)),
                      ),
                    ),
                  ),
                ),

                // Category chips
                SizedBox(
                  height: 48,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: _categories.map(_categoryChip).toList(),
                  ),
                ),

                const SizedBox(height: 10),

                // Service list
                Expanded(
                  child: _filtered.isEmpty
                      ? const Center(
                          child: Text(
                            "No services found",
                            style: TextStyle(
                              color: Color(0xFF7A6F8F),
                              fontSize: 16,
                            ),
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.all(20),
                          children: _filtered.map(_serviceTile).toList(),
                        ),
                ),
              ],
            ),
    );
  }
}
