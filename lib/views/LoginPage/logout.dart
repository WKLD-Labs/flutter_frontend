import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../global/login_context.dart';

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      try {
        await LoginContext.logout();
        if (!context.mounted) return;
      } catch (error) {
        //
      }
      context.go('/');
    });
    return const Scaffold(
      body: SafeArea(
          child: Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Logging Out',
                  style: TextStyle(fontSize: 24),
                ),
              ))),
    );
  }
}
