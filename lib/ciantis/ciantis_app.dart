import 'package:flutter/material.dart';
import '../core/app_providers.dart';
import '../core/global_state_bus.dart';
import 'ciantis_system_shell.dart';
import 'ciantis_theme.dart';

class CiantisApp extends StatelessWidget {
  const CiantisApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalStateBus(
      child: AppProviders(
        child: Builder(
          builder: (context) {
            final theme = CiantisTheme.buildTheme();
            return MaterialApp(
              title: 'Ciantis',
              debugShowCheckedModeBanner: false,
              theme: theme,
              onGenerateRoute: CiantisSystemShell.onGenerateRoute,
              initialRoute: CiantisSystemShell.initialRoute,
            );
          },
        ),
      ),
    );
  }
}
