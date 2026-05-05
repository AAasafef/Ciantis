import 'package:flutter/widgets.dart';

class GlobalStateBus extends InheritedWidget {
  const GlobalStateBus({
    super.key,
    required super.child,
  });

  static GlobalStateBus of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<GlobalStateBus>();
    assert(result != null, 'GlobalStateBus not found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
