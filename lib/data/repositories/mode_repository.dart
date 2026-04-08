import 'package:shared_preferences/shared_preferences.dart';

class ModeRepository {
  static const String _currentModeKey = 'current_mode';

  Future<void> saveCurrentMode(String modeId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_currentModeKey, modeId);
  }

  Future<String?> getCurrentMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_currentModeKey);
  }
}
