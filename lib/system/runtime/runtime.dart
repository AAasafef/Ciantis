class CiantisRuntime {
  CiantisRuntime._internal();

  static final CiantisRuntime instance = CiantisRuntime._internal();

  bool _booted = false;

  bool get isBooted => _booted;

  Future<void> boot() async {
    if (_booted) return;

    // Simulate loading system modules
    await Future.delayed(const Duration(milliseconds: 600));

    _booted = true;
  }
}
