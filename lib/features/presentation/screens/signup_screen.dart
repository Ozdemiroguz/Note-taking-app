import 'package:flutter/material.dart';
import 'package:firstvisual/features/data/services/auth_services.dart';

class SignupScreen extends StatelessWidget {
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Sign Up'),
          onPressed: () {
            authService.signUp();
          },
        ),
      ),
    );
  }
}
