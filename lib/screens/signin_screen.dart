import 'package:flutter/material.dart';
import 'package:firstvisual/services/auth_services.dart';

class SignInScreen extends StatelessWidget {
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giriş Yap'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Giriş Yap'),
          onPressed: () async {
            bool result = authService.signIn();
            if (result) {
              Navigator.pushReplacementNamed(context, '/home');
            } else {
              // Hata mesajını göster
            }
          },
        ),
      ),
    );
  }
}
