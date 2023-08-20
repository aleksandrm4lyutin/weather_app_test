import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_test/pages/data_loader.dart';
import 'package:weather_app_test/pages/splash_screen.dart';

import 'home_page.dart';
import 'login_page.dart';




class AuthWrapper extends StatelessWidget{

  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    /// get user stream from main.dart
    final user = Provider.of<User?>(context);

    /// if user is authenticated return home page, else return auth page
    if (user != null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('REGISTERED'),
        ),
      );
    } else {
      return const DataLoader();
      return SplashScreen();
      return LoginPage();
    }
  }
}
