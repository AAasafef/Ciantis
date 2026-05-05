import 'package:flutter/material.dart';
import '../core/module_loader.dart';
import '../core/module_registry.dart';
import 'ciantis_router.dart';

class CiantisSystemShell extends StatefulWidget {
  const CiantisSystemShell({super.key});

  static const String initialRoute = CiantisRouter.homeRoute;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return CiantisRouter.buildRoute(settings);
  }

  @override
  State<CiantisSystemShell> createState() => _CiantisSystemShellState();
}

class _CiantisSystemShellState extends State<CiantisSystemShell> {
  @override
  void initState() {
    super.initState();
    ModuleRegistry.registerAll();
    ModuleLoader.initializeAll();
  }

  @override
  Widget build(BuildContext context) {
    // This shell can later host global HUD, drawers, etc.
    return const _CiantisRootNavigator();
  }
}

class _CiantisRootNavigator extends StatelessWidget {
  const _CiantisRootNavigator();

  @override
  Widget build(BuildContext context) {
    // MaterialApp is created in CiantisApp; here we just rely on routing.
    return const SizedBox.shrink();
  }
}
