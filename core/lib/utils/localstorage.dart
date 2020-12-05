import 'package:shared_preferences/shared_preferences.dart';
import 'package:core/utils/global.dart';


///
/// 注意，为了保证缓存不因为域名冲突， key前需要关联global domain
/// "${Global.domain}_$key"
/// 
class DiscuzLocalStorage {
  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  /*
   * @description: set key string
   * @param {type} 
   * @return: 
   * @Author: virs
   * @Date: 2019-08-09 13:01:33
   */
  static Future<bool> setString(String key, String val) async {
    SharedPreferences prefs = await _prefs;
    return prefs.setString("${Global.domain}_$key", val);
  }

  /*
   * @description: remove key string
   * @param {type} 
   * @return: 
   * @Author: virs
   * @Date: 2019-08-09 13:01:45
   */
  static Future<bool> romove(String key) async {
    SharedPreferences prefs = await _prefs;
    return prefs.remove("${Global.domain}_$key");
  }

  /*
   * @description: clear all
   * @param {type} 
   * @return: 
   * @Author: virs
   * @Date: 2019-08-09 13:01:55
   */
  static Future<bool> clear() async {
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
  static Future<bool> setInt(String key, int val) async {
    SharedPreferences prefs = await _prefs;
    return prefs.setInt("${Global.domain}_$key", val);
  }

  /*
   * @description: get key string
   * @param {type} 
   * @return: 
   * @Author: virs
   * @Date: 2019-08-09 13:02:15
   */
  static Future<String> getString(String key) async {
    SharedPreferences prefs = await _prefs;
    String strValue = prefs.getString("${Global.domain}_$key");
    return Future.value(strValue);
  }

  /*
   * @description: get key int 
   * @param {type} 
   * @return: 
   * @Author: virs
   * @Date: 2019-08-09 13:02:23
   */
  static Future<int> getInt(String key) async {
    SharedPreferences prefs = await _prefs;
    int intValue = prefs.getInt("${Global.domain}_$key");
    return Future.value(intValue);
  }
}
