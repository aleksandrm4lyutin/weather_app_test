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

          Padding(
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

          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              '',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 54,
                  fontFamily: 'RobotoBold'
              ),
            ),
          ),
        ],
      ),
    );
  }
}
