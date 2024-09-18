import 'package:shared_preferences/shared_preferences.dart';

class LocalSavedData {
  static const userkey = 'user';
  static const userCurrency = "uCurrency";
  static const userLocal = 'Ulocal';
  static const searchData = 'searchData';

  static late SharedPreferences _preferences;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future setUserdata(String json) async => await _preferences.setString(userkey, json);

  static String? getUserData() => _preferences.getString(userkey);

  static removeUserDate() => _preferences.remove(userkey);

  ////////// FOR Localization

  static Future setUserLocal(String val) async => _preferences.setString(userLocal, val);

  static String? getUserLocal() => _preferences.getString(userLocal);

  static removeUserLocal() => _preferences.remove(userLocal);

  ///////// FOR CURRENCY

  static Future setUserCurrency(String val) async => _preferences.setString(userCurrency, val);

  static String? getUserCurrency() => _preferences.getString(userCurrency);

  static removeUserCurrency() => _preferences.remove(userCurrency);

  /////////// FOR SEARCH

  static Future setSearchData(String val) async => _preferences.setString(searchData, val);

  static String? getSearchData() => _preferences.getString(searchData);

  static removeSearchData() => _preferences.remove(searchData);
}
