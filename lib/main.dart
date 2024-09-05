import 'package:flutter/material.dart';
import 'package:words/pages/CamScanner.dart';
import 'pages/HomeScreen.dart';
import 'pages/settings.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(Sizer(builder: (context, orientation, deviceType) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Words Game",
      initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id: (context) => const HomeScreen(),
        Settings.id: (context) => const Settings(),
        CamScanner.id: (context) => const CamScanner()
      },
    );
  }));
}
