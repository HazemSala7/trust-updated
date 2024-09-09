import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trust_app_updated/Constants/constants.dart';

import '../../main.dart';
import '../home_screen/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  setLanguageOfTheApp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? myLanguage = await prefs.getString('language') ?? "english";
    if (myLanguage == "english") {
      setState(() {
        locale = Locale('en', '');
      });
      Trust.of(context)!.setLocale(Locale.fromSubtags(languageCode: 'en'));
    } else {
      setState(() {
        locale = Locale("ar", "AE");
      });
      Trust.of(context)!.setLocale(Locale.fromSubtags(languageCode: 'ar'));
    }
  }

  void initState() {
    super.initState();

    Timer(
        Duration(seconds: 2),
        () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(currentIndex: 0))));
    setLanguageOfTheApp();
  }

  Widget build(BuildContext context) {
    return Container(
      color: MAIN_COLOR,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            color: MAIN_COLOR,
            child: Center(
              child: Image.asset(
                'assets/images/logo_white.png',
                fit: BoxFit.cover,
                // height: 80,
                width: MediaQuery.of(context).size.width - 50,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
