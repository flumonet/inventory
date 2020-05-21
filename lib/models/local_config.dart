import 'package:shared_preferences/shared_preferences.dart';


class LocalConfig {
  static LocalConfig _singleton = new LocalConfig._internal();

  factory LocalConfig() {
    return _singleton;
  }

  LocalConfig._internal();

  Map<String, dynamic> appConfig = Map<String, dynamic>();


  Future<LocalConfig> readFromPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    appConfig['appearanceLight'] = prefs.getBool('appearanceLight') ?? true;
    return _singleton;
  }

  Future<void> saveToPrefs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('appearanceLight', appConfig['appearanceLight']);
  }

  bool getBool(String key) => appConfig[key];

  int getInt(String key) => appConfig[key];

  double getDouble(String key) => appConfig[key];

  String getString(String key) => appConfig[key];

  void updateValue(String key, dynamic value) {
    if (appConfig[key] != null &&
        value.runtimeType != appConfig[key].runtimeType) {
      throw ("The persistent type of ${appConfig[key].runtimeType} does not match the given type ${value.runtimeType}");
    }
    appConfig.update(key, (dynamic) => value);
    saveToPrefs();
  }
}