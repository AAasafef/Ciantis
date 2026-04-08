import '../kernel/kernel.dart';

class CiantisEngine {
  CiantisEngine._internal();

  static final CiantisEngine instance = CiantisEngine._internal();

  bool _started = false;

  bool get isStarted => _started;

  Future<void> start() async {
    if (_started) return;

    // Ensure kernel is initialized before engine starts
    await CiantisKernel.instance.initialize();

    // Simulate engine startup
    await Future.delayed(const Duration(milliseconds: 500));

    _started = true;
  }
}
