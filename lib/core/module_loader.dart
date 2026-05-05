import 'module_registry.dart';

class ModuleLoader {
  ModuleLoader._();

  static Future<void> initializeAll() async {
    for (final manager in ModuleRegistry.all) {
      await manager.init();
      await manager.load();
      await manager.ready();
    }
  }
}
