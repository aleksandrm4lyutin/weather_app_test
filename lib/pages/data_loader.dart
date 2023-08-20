import 'package:flutter/material.dart';
import 'package:weather_app_test/abstracts/data_package.dart';
import 'package:weather_app_test/pages/error_page.dart';
import 'package:weather_app_test/pages/splash_screen.dart';

import '../functions/data_service.dart';
import 'home_page.dart';

class DataLoader extends StatefulWidget {
  const DataLoader({Key? key}) : super(key: key);

  @override
  State<DataLoader> createState() => _DataLoaderState();
}

class _DataLoaderState extends State<DataLoader> {

  late Future<bool> geoPermission;
  late Future<DataPackage> dataPackage;
  DataService dataService = DataService();

  void getData() {
    dataPackage = dataService.loader();
  }

  @override
  void initState() {
    super.initState();

    getData();
  }


  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: dataPackage,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.done) {
          dynamic _data = snapshot.data;
          print('#@#@#@#');
          print('$_data');
          if(snapshot.data != null) {
            dynamic _dataPackage = snapshot.data;
            return HomePage(
              data: _dataPackage,
            );
          } else {
            /// Return error message with reload button
            return const ErrorPage();
          }
        } else {
          /// Return loading
          return const SplashScreen();
        }
      },
    );

  }
}
