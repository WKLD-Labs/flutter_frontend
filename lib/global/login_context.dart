import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:dio/dio.dart';

class LoginContext {
  static bool allowBiometrics = false;
  static bool isLogin = false;
  static const storage = FlutterSecureStorage();
  static final dio = Dio();

  static void changeAllowBiometrics() {
    allowBiometrics = !allowBiometrics;
  }

  static bool getAllowBiometrics() {
    return allowBiometrics;
  }

  static Future<void> login(String username, String password) async {
    try {
      final response = await dio.post(
        '${dotenv.env['API_SERVER']}/api/login',
        data: {
          'username':username,
          'password': password,
        },
      );
      if (response.statusCode == 200){
        final Map<String, dynamic> userData = await response.data;
        await storage.write(key: 'accessToken', value: userData['accessToken']);
        await storage.write(key: 'loginStatus', value: 'true');

      }
    } catch (e){
      print(e);
    }
  }

  static Future<bool> getIsLogin() async {
    return await storage.read(key: 'loginStatus') == 'true';
  }

  static Future<void> logout() async {
    await storage.write(key: 'loginStatus', value: 'false');
  }

  static Future<bool> isBiometricsAllowed() async {
    return await storage.containsKey(key: 'accessToken');
  }

  static Future<void> setToken(String token) async {
    await storage.write(key: 'accessToken', value: token);
  }

  static Future<void> biometricsLogin() async {
    await storage.write(key: 'loginStatus', value: 'true');
  }

  static Future<String?> getToken() async {
    return await storage.read(key: 'accessToken');
  }
}