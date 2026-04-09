import 'dart:convert';

import 'package:attendance_system/services/api_service/token_service.dart';
import 'package:http/http.dart' as http;

class ApiHelper {

  ApiHelper._();

  static final ApiHelper apiHelper = ApiHelper._();

  /// ================= COMMON HEADERS =================
  Future<Map<String,String>> headers()async{

    String? token = await TokenService.getToken();
    print("TOKEN =====> $token");

    return {
      "Content-Type": "application/json",
      if(token != null) "Authorization" : "Bearer $token"
    };
  }

  /// ================= GET =================
   Future<dynamic> get(String url)async{
    try{
      final response = await http.get(
        Uri.parse(url),
        headers: await headers(),
      ).timeout(Duration(seconds: 30));

      return handleResponse(response);

    }catch(e){
      throw "ERROR: $e";
    }
  }

  /// ================= POST =================
   Future<dynamic> post(String url, Map<String,dynamic> body)async{
    try{
      final response = await http.post(
        Uri.parse(url),
        headers: await headers(),
        body: jsonEncode(body),
      ).timeout(Duration(seconds: 30));

      return handleResponse(response);

    }catch(e){
      throw "ERROR: $e";
    }
  }

  /// ================= PUT =================
   Future<dynamic> put(String url, Map<String,dynamic> body)async{
    try{
      final response = await http.put(
          Uri.parse(url),
          headers: await headers(),
          body: jsonEncode(body)
      ).timeout(Duration(seconds: 30));

      return handleResponse(response);

    }catch(e){
      throw "ERROR: $e";
    }
  }

  /// ================= PATCH =================
  Future<dynamic> patch(String url, Map<String, dynamic> body) async {
    try {
      final response = await http.patch(
        Uri.parse(url),
        headers: await headers(), // must include auth token
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 30));

      return handleResponse(response);
    } catch (e) {
      throw "ERROR: $e";
    }
  }

  /// ================= DELETE =================
   Future<dynamic> delete(String url)async{
    try{
      final response = await http.delete(
        Uri.parse(url),
        headers: await headers(),
      ).timeout(Duration(seconds: 30));

      return handleResponse(response);

    }catch(e){
      throw "ERROR: $e";
    }
  }

  /// ================= LOGOUT =================
  Future<void> logOut(String url)async{
    try{
      final response = await http.post(
        Uri.parse(url),
        headers: await headers()
      ).timeout(Duration(seconds: 30));

      if(response.statusCode == 200){
        await TokenService.clearToken();
      }

      return handleResponse(response);

    }catch(e){
      throw "Logout failed: $e";
    }
  }

  /// ================= RESPONSE HANDLER =================
   dynamic handleResponse(http.Response response)async{

    final data = jsonDecode(response.body);

    switch(response.statusCode){

      case 200:

      case 201:
        return data;

      case 400:
        throw data['error'] ?? "Bad Request";

      case 401:
        throw "Unauthorized user";

      case 403:
        throw "Access forbidden";

      case 404:
        throw "Api not found";

      case 500:
        throw "Internal server error";

      default:
        throw "Something went wrong";
    }
  }
}