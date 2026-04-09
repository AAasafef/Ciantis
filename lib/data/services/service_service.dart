import 'package:uuid/uuid.dart';
import '../models/service_category_model.dart';
import '../models/service_model.dart';
import '../repositories/service_repository.dart';

class ServiceService {
  final ServiceRepository _repo = ServiceRepository();
  final Uuid _uuid = const Uuid();

  // -----------------------------
  // CATEGORY CREATION
  // -----------------------------
  Future<String> createCategory({
    required String name,
    String? description,
    required String color,
    required int sortOrder,
  }) async {
    final now = DateTime.now();
    final id = _uuid.v4();

    final category = ServiceCategoryModel(
      id: id,
      name: name,
      description: description,
      color: color,
      sortOrder: sortOrder,
      createdAt: now,
      updatedAt: now,
    );

    await _repo.addCategory(category);
    return id;
  }

  // -----------------------------
  // CATEGORY UPDATE
  // -----------------------------
  Future<void> updateCategory(ServiceCategoryModel category) async {
    final updated = category.copyWith(
      updatedAt: DateTime.now(),
    );
    await _repo.updateCategory(updated);
  }

  // -----------------------------
  // CATEGORY DELETE
  // -----------------------------
  Future<void> deleteCategory(String id) async {
    await _repo.deleteCategory(id);
  }

  // -----------------------------
  // GET ALL CATEGORIES
  // -----------------------------
  Future<List<ServiceCategoryModel>> getAllCategories() async {
    return await _repo.getAllCategories();
  }

  // -----------------------------
  // SERVICE CREATION
  // -----------------------------
  Future<String> createService({
    required String categoryId,
    required String name,
    required double price,
    required int duration,
    String? notes,
    String? overrideColor,
  }) async {
    final now = DateTime.now();
    final id = _uuid.v4();

    // Inherit color from category if not overridden
    final categories = await _repo.getAllCategories();
    final category = categories.firstWhere((c) => c.id == categoryId);
    final color = overrideColor ?? category.color;

    final service = ServiceModel(
      id: id,
      categoryId: categoryId,
      name: name,
      price: price,
      duration: duration,
      notes: notes,
      color: color,
      createdAt: now,
      updatedAt: now,
    );

    await _repo.addService(service);
    return id;
  }

  // -----------------------------
  // SERVICE UPDATE
  // -----------------------------
  Future<void> updateService(ServiceModel service) async {
    final updated = service.copyWith(
      updatedAt: DateTime.now(),
    );
    await _repo.updateService(updated);
  }

  // -----------------------------
  // SERVICE DELETE
  // -----------------------------
  Future<void> deleteService(String id) async {
    await _repo.deleteService(id);
  }

  // -----------------------------
  // GET ALL SERVICES
  // -----------------------------
  Future<List<ServiceModel>> getAllServices() async {
    return await _repo.getAllServices();
  }

  // -----------------------------
  // GET SERVICES BY CATEGORY
  // -----------------------------
  Future<List<ServiceModel>> getServicesByCategory(String categoryId) async {
    return await _repo.getServicesByCategory(categoryId);
  }

  // -----------------------------
  // SEARCH SERVICES
  // -----------------------------
  Future<List<ServiceModel>> searchServices(String query) async {
    return await _repo.searchServices(query);
  }

  // -----------------------------
  // SORTING
  // -----------------------------
  Future<List<ServiceModel>> sortByPrice({bool ascending = true}) async {
    return await _repo.sortByPrice(ascending: ascending);
  }

  Future<List<ServiceModel>> sortByDuration({bool ascending = true}) async {
    return await _repo.sortByDuration(ascending: ascending);
  }

  // -----------------------------
  // RECOMMENDED PRICING ADJUSTMENT
  // -----------------------------
  double recommendedPrice(ServiceModel service) {
    // Simple heuristic:
    // - Longer services → higher recommended price
    // - Jewel-tone categories (purple, sapphire, ruby) → premium multiplier
    // - Notes containing "advanced" or "specialty" → add premium

    double base = service.price;

    // Duration factor
    if (service.duration >= 120) base *= 1.30;
    else if (service.duration >= 90) base *= 1.20;
    else if (service.duration >= 60) base *= 1.10;

    // Color premium (luxury jewel tones)
    final jewelTones = ["#8A4FFF", "#B76EFF", "#E573B5", "#5A4A6A"];
    if (jewelTones.contains(service.color)) {
      base *= 1.15;
    }

    // Notes premium
    if (service.notes != null) {
      final n = service.notes!.toLowerCase();
      if (n.contains("advanced") || n.contains("specialty")) {
        base *= 1.20;
      }
    }

    return double.parse(base.toStringAsFixed(2));
  }
}
