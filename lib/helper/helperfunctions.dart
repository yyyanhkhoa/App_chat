import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{
  static String sharedPreferenceUserLoggedInKey = 'ISLOGGIN';
  static String sharedPreferenceUserNameKey = "USERNAMEKEY";
  static String sharedPreferenceUserEmailKey = 'USEREMAILkey';

  //lưu dữ liệu vào sharedPreferences
  static Future<bool> saveUserLoggedInsharedPreference(bool isUserLoggIn) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setBool(sharedPreferenceUserLoggedInKey, isUserLoggIn);
  }
  static Future<bool> saveUserNamesharedPreference(String userName) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setString(sharedPreferenceUserNameKey, userName);
  }
  static Future<bool> saveUserEmailsharedPreference(String userEmail) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    return await pref.setString(sharedPreferenceUserEmailKey, userEmail);
  }

  //lấy dữ liệu từ sharedPreferences
  static Future<bool?> getUserLoggedInsharedPreference() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getBool(sharedPreferenceUserLoggedInKey);
  }
  static Future<String?> getUserNamesharedPreference() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(sharedPreferenceUserNameKey);
  }
  static Future<String?> getUserEmailsharedPreference() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString(sharedPreferenceUserEmailKey);
  }
}