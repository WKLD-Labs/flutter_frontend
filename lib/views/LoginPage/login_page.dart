import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:wkldlabs_flutter_frontend/global/login_context.dart';
import '../../widgets/nav_drawer.dart';

final uri = dotenv.env['API_SERVER']!;
const storage = FlutterSecureStorage();

class LoginPage extends StatefulWidget{
  const LoginPage({super.key, required this.title});
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}
final LocalAuthentication _localAuthentication = LocalAuthentication();

class _LoginPageState extends State<LoginPage>{
  final _formKey = GlobalKey<FormState>();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isFormEmpty = true;
  bool isBiometricsAllowed = LoginContext.getAllowBiometrics();

  final dio = Dio();

  void login() async {
    try {
      final response = await dio.post(
        '$uri/api/login',
        data: {
          'username': usernameController.text,
          'password': passwordController.text,
        },
      );
      if (response.statusCode == 200){
        final Map<String, dynamic> userData = await response.data;
        LoginContext.setToken(userData['accessToken']);
        setAllowBiometrics();
        LoginContext.changeIsLogin();
        context.go('/');
      }
    } catch (e){
      print(e);
    }
  }

  void setAllowBiometrics() async {
    if (await storage.read(key: 'accessToken') != null){
      LoginContext.changeAllowBiometrics();
      setState(() {
        isBiometricsAllowed = LoginContext.getAllowBiometrics();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _updateFormEmptyStatus();
    setAllowBiometrics();
  }

  void _updateFormEmptyStatus(){
    setState(() {
      isFormEmpty = usernameController.text.isEmpty || passwordController.text.isEmpty;
    });
  }

  void _auth() async {
    bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticate(
          localizedReason: "Scan your finger to authenticate");
    } on PlatformException catch (e) {
      print(e);
    }
    if (authenticated){
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/images/HomePage/LogoASE-Text.png',
              width: 300,
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Username'
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty){
                            return 'Tolong masukan username';
                          }
                          return null;
                        },
                        onChanged: (_) => _updateFormEmptyStatus(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Password'
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty){
                            return 'Tolong masukan password';
                          }
                          return null;
                        },
                        onChanged: (_) => _updateFormEmptyStatus(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: isFormEmpty ? null : (){
                                if (_formKey.currentState!.validate()){
                                  login();
                                }
                              },
                              child: const Text('Submit'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ElevatedButton(
                                  onPressed: isBiometricsAllowed ? _auth : null,
                                child: const Icon(Icons.fingerprint),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      endDrawer: NavDrawer(context),
    );
  }

}