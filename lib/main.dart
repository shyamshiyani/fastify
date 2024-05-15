import 'package:flutter/material.dart';
import 'package:quotopia/screen/detailpage.dart';
import 'package:quotopia/screen/homePage.dart';
import 'package:quotopia/screen/splash.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "SplashScreen",
      routes: {
        'SplashScreen': (context) => const SplashScreen(),
        '/': (context) => const HomePage(),
        'DetailPage': (context) => const DetailPage(),
      },
    ),
  );
}
