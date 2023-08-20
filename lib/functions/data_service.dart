
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weather_app_test/abstracts/data_package.dart';
import '../abstracts/weather_data.dart';

class DataService {

  /// API Key for openweathermap.org
  ///
  static const String apiKey = '5273504e966bca97cff56a6e767a7eb9';
  ///

  /// --------------------------------------------------------------------------
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  int average(int d0, int d1) => (d0 + d1) ~/ 2;
  /// --------------------------------------------------------------------------


  /// --------------------------- loadData ------------------------------
  ///
  ///
  Future<DataPackage> loader() async {
    /// check internet connection
    final connectivityResult = await (Connectivity().checkConnectivity());
    /// check geolocation services
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    /// if geo services are disabled then return error
    if(!serviceEnabled) {
      return DataPackage(country: '', city: '', weatherData: [], code: -4);
    }
    /// check geolocation permission
    LocationPermission permission = await Geolocator.checkPermission();
    /// if no permission then ask for it
    if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      /// if no permission still then return error
      if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        return DataPackage(country: '', city: '', weatherData: [], code: -1);
      }
    }
    /// permission is granted - continue..
    /// get position
    Position? position;
    try {
      position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high, timeLimit: const Duration(minutes: 1));
    } catch(e) {
      position = await Geolocator.getLastKnownPosition();
    }
    /// check connection and position, if one of them is missing then try saved data
    if (connectivityResult == ConnectivityResult.none || position == null) {
      var localData = await checkLocalSave();
      /// if no data saved then return error
      if(localData == null) {
        return DataPackage(country: '', city: '', weatherData: [], code: -3);
      }
      /// if data is available - continue..
      /// convert String to Map
      Map<String, dynamic>? jsonMap = convert.jsonDecode(localData) as Map<String, dynamic>;
      /// check local data for relevance
      // for(var l in jsonMap['list']) {
      //
      // }
      print('++++++++++++=========== Got local data ==============++++++++++++++');
      print(localData);

      /// check for if saved data have today's weather forecast
      List<dynamic> list = jsonMap['list'];
      list.retainWhere((e) => DateTime.fromMillisecondsSinceEpoch(e['dt'] * 1000).month == DateTime.now().month
          && DateTime.fromMillisecondsSinceEpoch(e['dt'] * 1000).day == DateTime.now().day);
      /// if list is empty return error
      if(list.isEmpty) {
        return DataPackage(country: '', city: '', weatherData: [], code: -3);
      }
      /// if at least 1 data point is present then continue..





      return DataPackage(country: '', city: '', weatherData: [], code: 2);

      return DataPackage(country: '', city: '', weatherData: [], code: -2);
    }
    /// if both internet and geolocation available then load data from openweathermap.org
    var url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&lang=ru&units=metric'
    );
    var response = await http.get(url);
    /// if request is not successful then return error
    if (response.statusCode != 200) {
      return DataPackage(country: '', city: '', weatherData: [], code: -5);
    }
    /// got data, continue..
    String json = response.body;
    /// save data locally for future use
    save(json);
    /// convert String to Map
    Map<String, dynamic>? jsonMap = convert.jsonDecode(json) as Map<String, dynamic>;

    print('++++++++++++=========== Got internet data ==============++++++++++++++');
    print(json);

    List<WeatherData> wdList = [];
    try {
      wdList = List.generate(4, (i) {
        return WeatherData(
          dt: jsonMap['list'][i]['dt'] * 1000,
          minTemp: jsonMap['list'][i]['main']['temp_min'].toInt(),
          maxTemp: jsonMap['list'][i]['main']['temp_max'].toInt(),
          averageTemp: average(jsonMap['list'][i]['main']['temp_min'].toInt(), jsonMap['list'][i]['main']['temp_max'].toInt()),
          humidity: jsonMap['list'][i]['main']['humidity'],
          wind: jsonMap['list'][i]['wind']['speed'].toInt(),
          name: capitalize(jsonMap['list'][i]['weather'][0]['description']),
          weatherCode: jsonMap['list'][i]['weather'][0]['id'],
        );
      });
    } catch(e) {
      //print(e);
      wdList = [];
    }

    return DataPackage(country: jsonMap['city']['country'], city: jsonMap['city']['name'], weatherData: wdList, code: 1);
  }

  /// --------------------------------------------------------------------------
  ///
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/weather_app_forecast_json.txt');
  }
  Future<void> save(String json) async {
    final file = await _localFile;
    await file.writeAsString(json);
  }
  Future<String?> checkLocalSave() async {
    try {
      final file = await _localFile;
      final json = await file.readAsString();
      return json;
    } catch (e) {
      return null;
    }
  }
  ///





  /// ----------------------------- loadWeather --------------------------------
  /// Function responsible for loading data from openweathermap.org
  ///
  Future<List<WeatherData>> loadWeather() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);

    var url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=${position.latitude}&lon=${position.longitude}&cnt=10&appid=$apiKey&lang=ru&units=metric'
    );
    var response = await http.get(url);
    // String s = response.body;
    Map<String, dynamic>? jsonResponse;
    if (response.statusCode == 200) {
      jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      print('&&&&&&&&&& 200 &&&&&&&&&&');
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
        // print('DT DM: ${DateFormat.MMMMd('ru_RU').format(DateTime.fromMillisecondsSinceEpoch(l['dt'] * 1000))}');
        // print('DT HM: ${DateFormat.Hm('ru_RU').format(DateTime.fromMillisecondsSinceEpoch(l['dt'] * 1000))}');
        print('Humidity: ${l['main']['humidity']}%');
        print('Wind: ${l['wind']['speed'].toInt()}>>');
        print('Temp Average: ${((l['main']['temp_min'] + l['main']['temp_max']) * 0.5).toInt()}°');
        print('Temp Min_Max: ${l['main']['temp_min'].toInt()}° - ${l['main']['temp_max'].toInt()}°');
        print('Weather: ${l['weather'][0]['description']}');
        print('Weather1: ${l['weather'][0]['main']}');
        print(l);
      }

      //print('$jsonResponse');
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    //return jsonResponse;
    print('!#!#!#!#! continue... !#!#!#!#!#!');
    Map<String, dynamic>? result = jsonResponse;

    if(result != null) {

      int id;
      if(result['list'][1]['weather'][0]['id'] is int) {
        id = result['list'][1]['weather'][0]['id'];
      } else {
        id = int.tryParse(result['list'][1]['weather'][0]['id']) ?? 800;
      }

      var iconID;
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

      print('$iconID');
    }
    print('!#!#!#!#! END !#!#!#!#!#!');
    return [];
  }
  /// --------------------------------------------------------------------------

}