import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_app_test/pages/auth_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_test/pages/splash_screen.dart';
import 'functions/auth_service.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) {
    runApp(const InitApp());
  });
}


class InitApp extends StatelessWidget {
  const InitApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {

        /// when done initializing return the app
        if (snapshot.connectionState == ConnectionState.done) {
          return const MyApp();
        }

        /// Check for errors TODO
        if (snapshot.hasError) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: Text('ERROR WHILE INITIALIZING, PLEASE RELOAD THE APP'),
              ),
            ),
          );
        }

        ///Show something while waiting for initialization to complete
        return const MaterialApp(
          home: SplashScreen(),
        );
      },
    );
  }
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    /// setup the user stream
    return StreamProvider<User?>.value(
      value: AuthService().userStream,
      initialData: null,
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: AuthWrapper(),
      ),
    );
  }
}
