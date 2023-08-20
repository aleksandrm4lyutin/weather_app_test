import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_app_test/pages/auth_wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'functions/auth_service.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) {
    runApp(InitApp());
  });
}


class InitApp extends StatelessWidget {
  InitApp({Key? key}) : super(key: key);

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {

        ///
        if (snapshot.connectionState == ConnectionState.done) {
          return const MyApp();
        }

        /// Check for errors
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
          home: Scaffold(
            body: Center(
              // child: SizedBox(
              //   width: 100,
              //   height: 100,
              //   child: CircularProgressIndicator(color: Colors.indigo,),
              // ),
            ),
          ),
        );
      },
    );
  }
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    ///
    return StreamProvider<User?>.value(
      value: AuthService().userStream,
      initialData: null,
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        //TODO
        title: '',
        home: AuthWrapper(),
      ),
    );
  }
}
