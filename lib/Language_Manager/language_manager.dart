import 'package:shared_preferences/shared_preferences.dart';

class LanguageManager {
  static Future<String> getLanguage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('language') ?? "english";
  }
}
