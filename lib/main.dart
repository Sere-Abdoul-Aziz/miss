import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:miss/splash.dart';

import 'home.dart';
import 'mainpage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: SplashScreen(),
    );
  }
}
