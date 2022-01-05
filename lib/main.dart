import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hd4kwallpaper/screens/homepage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dope Wallpapers!',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'GoogleSans',
          canvasColor: Colors.white,
          primaryIconTheme: const IconThemeData(color: Colors.black)),
      home: const LandingPage(),
    );
  }
}
