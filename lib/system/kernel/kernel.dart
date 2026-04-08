import '../runtime/runtime.dart';

class CiantisKernel {
  CiantisKernel._internal();

  static final CiantisKernel instance = CiantisKernel._internal();

  bool _initialized = false;

  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    if (_initialized) return;

    // Ensure runtime is booted before kernel initializes
    await CiantisRuntime.instance.boot();

    // Simulate kernel initialization
    await Future.delayed(const Duration(milliseconds: 400
