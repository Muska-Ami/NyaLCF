// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

class PrefsInstance {
  static get instance => SharedPreferences.getInstance();

  static clear() async => (await instance).clear();
}
