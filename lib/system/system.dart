import 'package:flutter/material.dart';
import 'runtime/runtime.dart';
import 'kernel/kernel.dart';
import 'engine/engine.dart';
import 'shell/system_shell.dart';

class CiantisSystem {
  CiantisSystem._internal();

  static final CiantisSystem instance = CiantisSystem._internal();

  bool _launched = false;

  bool get isLaunched => _launched;

  Future<void> launch() async {
    if (_launched) return;

    // Boot runtime
    await CiantisRuntime.instance.boot();

    // Initialize kernel
    await CiantisKernel.instance.initialize();

    // Start engine
    await CiantisEngine.instance.start();

    _launched = true;
  }

  Widget buildSystemShell() {
    return const CiantisSystemShell();
  }
}
