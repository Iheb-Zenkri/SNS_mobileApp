//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sns_app/pages/login_page.dart';

/*/ ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:ui_web' as ui;

*///

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
     /* const userJson = {
          "id": 1,
          "username": "SABRINE BEN HLEL",
          "password": "0000",
          "picName": "1729105616131-432377465-sabrine.jpg",
          "phoneNumber": "25240471",
          "createdAt": "2024-10-16T17:35:34.000Z",
          "updatedAt": "2024-10-19T22:56:17.000Z"
      };

      User user = User.fromJson(userJson);
      user.savePrefrences();*/
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: Locale('fr', 'FR'),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('fr', 'TN'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const  LoginPage(),
      theme: ThemeData(
        fontFamily: 'Rubik',
        textTheme: const TextTheme(
          bodyLarge : TextStyle(fontFamily: 'Nunito'),
        ),
      ),
    );
  }
}
