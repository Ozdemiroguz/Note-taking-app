import 'package:firstvisual/screens/getStartedPage.dart';
import 'package:firstvisual/screens/homeScreen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyappScreenState createState() => _MyappScreenState();
}

class _MyappScreenState extends State<MyApp> {
  final String isLoggedInKey = 'isLoggedIn';
  bool isSignedIn = false;
  late bool isLoggedIn = false;

  Future<bool> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs.getBool(isLoggedInKey) ?? false;
    print('isLoggedIn:sdsdsdsdsdsdsdsdswdsdsdsdsdsdsd $isLoggedIn');

    if (!isLoggedIn) {
      // Kullanıcı giriş yapmadıysa, giriş yapması için yönlendir.

      // Kullanıcı giriş yaptıktan sonra giriş durumunu kaydet.
      await prefs.setBool(isLoggedInKey, true);
      return false;
    }
    return true;
  }

  @override

  //sayfa açılmadan önce giriş durumunu kontrol et

  @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Uygulama',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: FutureBuilder<bool>(
        future: _checkLoginStatus(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // Yükleniyor ekranı
          } else {
            if (snapshot.hasError)
              return Text('Hata: ${snapshot.error}');
            else
              return snapshot.data!
                  ? HomeScreen()
                  : FeaturePage(); // Kontrole göre yönlendirme
          }
        },
      ),
    );
  }
}
