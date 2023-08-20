import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../abstracts/data_package.dart';
import '../abstracts/weather_data.dart';


class HomePage extends StatefulWidget {

  final DataPackage data;

  const HomePage({Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String apiKey = '5273504e966bca97cff56a6e767a7eb9';
  String urlLink = 'https://api.openweathermap.org/data/3.0/onecall?lat=33.44&lon=-94.04&appid={API key}';
  String response = '';
  List<String> images = [
    'icon_0.png',
    'icon_1.png',
    'icon_2.png',
    'icon_3.png',
    'icon_4.png',
    'icon_5.png',
  ];
  int iconID = 0;

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  Future<Map<String, dynamic>?> makeRequest(double lat, double lon) async {
    var url = Uri.parse(
      'https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&cnt=10&appid=$apiKey&lang=ru&units=metric'
    );
    var response = await http.get(url);
    // String s = response.body;
    Map<String, dynamic>? jsonResponse;
    if (response.statusCode == 200) {
      jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      print('&&&&&&&&&&&&&&&&&&&&&&');
      print('$jsonResponse');
      print('&&&&&&&&&&&&&&&&&&&&&&');
      print('');
      print('City: ${jsonResponse['city']}');
      print('Country: ${jsonResponse['city']['country']}');
      print('City: ${jsonResponse['city']['name']}');
      for(var l in jsonResponse['list']) {
        print('+++++++++++++++');
        print('DT -> now: ${l['dt']} -> ${DateTime.now().millisecondsSinceEpoch~/1000}');
        print('Diff: ${ DateTime.fromMillisecondsSinceEpoch(l['dt'] * 1000).difference(DateTime.now()).inDays }');
        print('===============');
        print('DT DM: ${DateFormat.MMMMd('ru_RU').format(DateTime.fromMillisecondsSinceEpoch(l['dt'] * 1000))}');
        print('DT HM: ${DateFormat.Hm('ru_RU').format(DateTime.fromMillisecondsSinceEpoch(l['dt'] * 1000))}');
        print('Humidity: ${l['main']['humidity']}%');
        print('Wind: ${l['wind']['speed'].toInt()}>>');
        print('Temp Average: ${((l['main']['temp_min'] + l['main']['temp_max']) * 0.5).toInt()}°');
        print('Temp Min_Max: ${l['main']['temp_min'].toInt()}° - ${l['main']['temp_max'].toInt()}°');
        print('Weather: ${capitalize(l['weather'][0]['description'])}');
        print('Weather1: ${capitalize(l['weather'][0]['main'])}');
        print(l);
      }

      //print('$jsonResponse');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return jsonResponse;
  }



  @override
  void initState() {
    super.initState();

    initializeDateFormatting('ru_RU');
    print('WIDGET DATA:');
    print('city: ${widget.data.city}');
    print('country: ${widget.data.country}');
    print('wd.length: ${widget.data.weatherData.length}');
    for(var wd in widget.data.weatherData) {
      print('dt: ${wd.dt}');
      print('dt m: ${DateTime.fromMillisecondsSinceEpoch(wd.dt).month}');
      print('dt d: ${DateTime.fromMillisecondsSinceEpoch(wd.dt).day}');
    }

  }

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
            padding: const EdgeInsets.only(top: 40),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  radius: 0.4,
                  stops: const [0.1, 1],
                  colors: [
                    Colors.purpleAccent.shade100,
                    Colors.transparent
                  ],
                ),
              ),
              child: Image(
                image: AssetImage('assets/images/${images[iconID]}'),
                // height: 100,
                // width: 100,
              ),
            ),
          ),

          Column(
            children: [
              SizedBox(height: 500,),

              Center(
                child: TextButton(
                  onPressed: () async {
                    LocationPermission permission = await Geolocator.checkPermission();
                    print('$permission');
                    if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
                      Geolocator.requestPermission();
                    } else {
                      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
                      print('${position.latitude} ${position.longitude}');

                      Map<String, dynamic>? result = await makeRequest(position.latitude, position.longitude);
                      if(result != null) {

                        int id;
                        if(result['list'][1]['weather'][0]['id'] is int) {
                          id = result['list'][1]['weather'][0]['id'];
                        } else {
                          id = int.tryParse(result['list'][1]['weather'][0]['id']) ?? 800;
                        }

                        if(id < 300) {
                          iconID = 0;
                        } else if(id > 299 && id < 500) {
                          iconID = 1;
                        } else if(id > 499 && id < 600) {
                          iconID = 2;
                        } else if(id > 599 && id < 701) {
                          iconID = 3;
                        } else if(id > 700 && id < 801) {
                          iconID = 4;
                        } else if(id > 800) {
                          iconID = 5;
                        } else {
                          iconID = 4;
                        }

                        setState(() {

                        });
                        print('$iconID');
                      }
                    }
                  },
                  child: Text('get ${widget.data.code}'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
