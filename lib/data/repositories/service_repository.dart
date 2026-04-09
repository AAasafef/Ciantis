import '../dao/service_dao.dart';
import '../models/service_category_model.dart';
import '../models/service_model.dart';

class ServiceRepository {
  final ServiceDao _dao = ServiceDao();

  // -----------------------------
  // CATEGORY METHODS
  // -----------------------------
  Future<void> addCategory(ServiceCategoryModel category) async {
    await _dao.insertCategory(category);
  }

  Future<void> updateCategory(ServiceCategoryModel category) async {
    await _dao.updateCategory(category);
  }

  Future<void> deleteCategory(String id) async {
    await _dao.deleteCategory(id);
  }

  Future<List<ServiceCategoryModel>> getAllCategories() async {
    return await _dao.getAllCategories();
  }

  // -----------------------------
  // SERVICE METHODS
  // -----------------------------
  Future<void> addService(ServiceModel service) async {
    await _dao.insertService(service);
  }

  Future<void> updateService(ServiceModel service) async {
    await _dao.updateService(service);
  }

  Future<void> deleteService(String id) async {
    await _dao.deleteService(id);
  }

  Future<List<ServiceModel>> getAllServices() async {
    return await _dao.getAllServices();
  }

  Future<List<ServiceModel>> getServicesByCategory(String categoryId) async {
    return await _dao.getServicesByCategory(categoryId);
  }

  Future<List<ServiceModel>> searchServices(String query) async {
    return await _dao.searchServices(query);
  }

  Future<List<ServiceModel>> sortByPrice({bool ascending = true}) async {
    return await _dao.sortByPrice(ascending: ascending);
  }

  Future<List<ServiceModel>> sortByDuration({bool ascending = true}) async {
    return await _dao.sortByDuration(ascending: ascending);
  }
}
