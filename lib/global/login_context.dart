import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginContext {
  static bool allowBiometrics = false;
  static bool isLogin = false;
  static const storage = FlutterSecureStorage();

  static void changeAllowBiometrics() {
    allowBiometrics = !allowBiometrics;
  }

  static bool getAllowBiometrics() {
    return allowBiometrics;
  }

  static void changeIsLogin() {
    isLogin = !isLogin;
  }

  static bool getIsLogin() {
    return isLogin;
  }

  static Future<void> setToken(String token) async {
    await storage.write(key: 'accessToken', value: token);
  }

  static Future<String?> getToken() async {
    return await storage.read(key: 'accessToken');
  }
}