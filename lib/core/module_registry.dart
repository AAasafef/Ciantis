import 'module_lifecycle_manager.dart';

enum CiantisModule {
  calendar,
  tasks,
  routines,
  habits,
  clients,
  services,
  notifications,
  modes,
}

class ModuleRegistry {
  ModuleRegistry._();

  static final Map<CiantisModule, ModuleLifecycleManager> _modules = {};

  static void registerAll() {
    _modules.clear();
    for (final module in CiantisModule.values) {
      _modules[module] = ModuleLifecycleManager(module);
    }
  }

  static Iterable<ModuleLifecycleManager> get all => _modules.values;

  static ModuleLifecycleManager? get(CiantisModule module) => _modules[module];
}
