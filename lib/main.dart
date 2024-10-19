//import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sns_app/pages/landing_page.dart';
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
      home: const LoginPage(),// Homepage(), 
      theme: ThemeData(
        fontFamily: 'Rubik',
        textTheme: const TextTheme(
          bodyLarge : TextStyle(fontFamily: 'Nunito'),
        ),
      ),
    );
  }
}
