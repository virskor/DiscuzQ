import 'package:shared_preferences/shared_preferences.dart';

class ClodraLocalStorage {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  /*
   * @description: set key string
   * @param {type} 
   * @return: 
   * @Author: virs
   * @Date: 2019-08-09 13:01:33
   */
  Future<bool> setString(String key, String val) async {
    SharedPreferences prefs = await _prefs;
    return prefs.setString(key, val);
  }

  /*
   * @description: remove key string
   * @param {type} 
   * @return: 
   * @Author: virs
   * @Date: 2019-08-09 13:01:45
   */
  Future<bool> romove(String key) async {
    SharedPreferences prefs = await _prefs;
    return prefs.remove(key);
  }

  /*
   * @description: clear all
   * @param {type} 
   * @return: 
   * @Author: virs
   * @Date: 2019-08-09 13:01:55
   */
  Future<bool> clear() async {
    SharedPreferences prefs = await _prefs;
    return prefs.clear();
  }

  /*
   * @description: set key int
   * @param {type} 
   * @return: 
   * @Author: virs
   * @Date: 2019-08-09 13:02:03
   */
  Future<bool> setInt(String key, int val) async {
    SharedPreferences prefs = await _prefs;
    return prefs.setInt(key, val);
  }

  /*
   * @description: get key string
   * @param {type} 
   * @return: 
   * @Author: virs
   * @Date: 2019-08-09 13:02:15
   */
  Future<String> getString(String key) async {
    SharedPreferences prefs = await _prefs;
    String strValue = prefs.getString(key);
    return Future.value(strValue);
  }

  /*
   * @description: get key int 
   * @param {type} 
   * @return: 
   * @Author: virs
   * @Date: 2019-08-09 13:02:23
   */
  Future<int> getInt(String key) async {
    SharedPreferences prefs = await _prefs;
    int intValue = prefs.getInt(key);
    return Future.value(intValue);
  }
}
