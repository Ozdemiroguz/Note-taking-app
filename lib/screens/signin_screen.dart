import 'package:firstvisual/screens/getStartedPage.dart';
import 'package:flutter/material.dart';
import 'package:firstvisual/services/auth_services.dart';
import 'package:lottie/lottie.dart';

class SignInScreen extends StatelessWidget {
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giriş Yap'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              child: Lottie.asset('animations/Animation - 1707940217335.json'),
            ),
            ElevatedButton(
              child: Text('Giriş Yap'),
              onPressed: () async {
                bool result = authService.signIn();
                if (result) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FeaturePage(),
                    ),
                  );
                } else {
                  // Hata mesajını göster
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
