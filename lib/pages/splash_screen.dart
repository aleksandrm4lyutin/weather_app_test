
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          /// gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.indigoAccent.shade700,
                  Colors.black,
                ],
              )
            ),
          ),

          /// center title
          const Padding(
            padding: EdgeInsets.all(40.0),
            child: Center(
              child: Text(
                'WEATHER SERVICE',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 54,
                    fontFamily: 'RobotoBold'
                ),
              ),
            ),
          ),

          /// presumably this part should check sunset-sunrise data and
          /// compare it with current time and show different text, but..
          /// due to the lack of time it will be static text for now TODO
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 100.0),
              child: Text(
                'dawn is coming soon',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontFamily: 'RobotoRegular'
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
