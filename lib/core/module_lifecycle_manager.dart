import 'module_registry.dart';

class ModuleLifecycleManager {
  final CiantisModule module;

  ModuleLifecycleManager(this.module);

  Future<void> init() async {
    // Hook for module-specific initialization if needed.
  }

  Future<void> load() async {
    // Hook for loading data, caches, etc.
  }

  Future<void> ready() async {
    // Hook for final readiness state.
  }
}
