import 'package:shared_preferences/shared_preferences.dart';

class TokenService {

  static Future<void> saveToken(String token, String role, String userId)async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('token', token);
   await preferences.setString('role', role);
   await preferences.setString('id', userId);
  }

  static Future<String?> getToken()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('token');
  }

  static Future<String?> getRole()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('role');
  }

  static Future<String?> getUserId()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('id');
  }

  static Future<void> clearToken()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('token');
    await preferences.remove('role');
    await preferences.remove('id');
  }

}