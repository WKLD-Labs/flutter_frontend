import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

import '../../widgets/nav_drawer.dart';

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

  @override
  void initState() {
    super.initState();
    _updateFormEmptyStatus();
  }

  void _updateFormEmptyStatus(){
    setState(() {
      isFormEmpty = usernameController.text.isEmpty || passwordController.text.isEmpty;
    });
  }

  void _auth() async {
    if (await _localAuthentication.authenticate(localizedReason: 'Login dengan biometrics')){
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
                                context.go('/');
                              },
                              child: const Text('Submit'),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: ElevatedButton(
                                  onPressed: (){
                                    _auth();
                                  },
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