import 'package:flutter/material.dart';
import 'package:sns_app/pages/landing_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/*/ ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:ui_web' as ui;

*///

void main() {
/*
 if (kIsWeb) {
    ui.platformViewRegistry.registerViewFactory(
      'plugins.flutter.io/google_maps',
      (int? viewId) {
        final IFrameElement element = IFrameElement()
          ..src = 'https://maps.google.com/maps?q=Djerba&output=embed'  // Example URL
          ..style.border = 'none'  // Optional: remove iframe border
          ..style.height = '670px'
          ..style.width = '375px';
        return element;  // Return the created HTML iframe element
      },
    );
  }
*/
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
      home: const Homepage(),
      theme: ThemeData(
        fontFamily: 'Rubik',
        textTheme: const TextTheme(
          bodyLarge : TextStyle(fontFamily: 'Nunito'),
        ),
      ),
    );
  }
}
