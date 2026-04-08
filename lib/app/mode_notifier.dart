import 'package:flutter/material.dart';
import '../data/services/mode_engine_service.dart';

class ModeNotifier extends InheritedNotifier<ModeEngineService> {
  const ModeNotifier({
    super.key,
    required ModeEngineService notifier,
    required Widget child,
  }) : super(notifier: notifier, child: child);

  static ModeEngineService of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<ModeNotifier>()!
        .notifier!;
  }
}
