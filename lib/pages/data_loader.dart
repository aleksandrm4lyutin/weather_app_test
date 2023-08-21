
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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
  void openSettings() {
    Geolocator.openLocationSettings();
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
          if(snapshot.data != null) {
            if(snapshot.data!.code >= 0) {
              /// Return home page
              return HomePage(data: snapshot.data!);
            } else if(snapshot.data!.code == -1) {
              /// Return error page with open settings then reload button
              return ErrorPage(code: snapshot.data!.code,
                reload: () {
                  openSettings();
                  setState(() => getData());
                },
              );
            } else {
              /// Return error page with reload button
              return ErrorPage(code: snapshot.data!.code, reload: () => setState(() => getData()));
            }
          } else {
            /// Return error page with reload button
            return ErrorPage(code: -3, reload: () => setState(() => getData()));
          }
        } else {
          /// Return loading
          return const SplashScreen();
        }
      },
    );

  }
}
