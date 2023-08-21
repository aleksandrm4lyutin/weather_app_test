
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:path_provider/path_provider.dart';
import 'package:weather_app_test/abstracts/data_package.dart';
import '../abstracts/weather_data.dart';


class DataService {

  /// API Key for openweathermap.org ===========================================
  ///
  static const String apiKey = '5273504e966bca97cff56a6e767a7eb9';
  ///===========================================================================


  /// ---------------------------- Load Data -------------------------------
  ///
  Future<DataPackage> loader() async {
    /// check internet connection
    final connectivityResult = await (Connectivity().checkConnectivity());
    /// check geolocation services
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    /// if geo services are disabled then return error (-1 no geolocation)
    if(!serviceEnabled) {
      return DataPackage(country: '', city: '', weatherData: [], code: -1);
    }
    /// check geolocation permission
    LocationPermission permission = await Geolocator.checkPermission();
    /// if no permission then ask for it
    if(permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      /// if no permission still then return error (-1 no geolocation)
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
    /// check connection and position, if one of them is missing then try to get saved data
    if (connectivityResult == ConnectivityResult.none || position == null) {
      var localData = await checkLocalSave();
      /// if no data saved then return error (-2 no internet or location and no saved data)
      if(localData == null) {
        return DataPackage(country: '', city: '', weatherData: [], code: -2);
      }
      /// if data is available - continue..
      /// convert String to Map
      Map<String, dynamic>? jsonMap = convert.jsonDecode(localData) as Map<String, dynamic>;
      /// check for if saved data have today's weather forecast
      List<Map<String, dynamic>> list = jsonMap['list'];
      list.retainWhere((e) => e['dt'] * 1000 >= DateTime.now().millisecondsSinceEpoch);
      /// if list is empty return error (-2 no internet or location and no saved data)
      if(list.isEmpty) {
        return DataPackage(country: '', city: '', weatherData: [], code: -2);
      }
      /// if at least 1 data point is present then continue..
      /// check number of data points to trim
      var c = list.length >= 4 ? list.length : 4;
      /// generate list of weather data
      List<WeatherData> wdList = generateList(list, c);
      /// return local data package
      return DataPackage(country: jsonMap['city']['country'], city: jsonMap['city']['name'], weatherData: wdList, code: 1);
    }
    /// if both internet and geolocation available then load data from openweathermap.org
    var url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&lang=ru&units=metric'
    );
    var response = await http.get(url);
    /// if request is not successful then return error (-2 no internet or location)
    if (response.statusCode != 200) {
      return DataPackage(country: '', city: '', weatherData: [], code: -2);
    }
    /// got data, continue..
    String json = response.body;
    /// save data locally for future use
    save(json);
    /// convert String to Map
    Map<String, dynamic>? jsonMap = convert.jsonDecode(json) as Map<String, dynamic>;
    /// generate list of weather data
    List<WeatherData> wdList = generateList(jsonMap['list'], 4);
    /// return internet data package
    return DataPackage(country: jsonMap['city']['country'], city: jsonMap['city']['name'], weatherData: wdList, code: 0);
  }
  /// --------------------------------------------------------------------------


  /// ------------------------- Misc functions ---------------------------------
  ///
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  /// --------------------------------------------------------------------------
  int average(int d0, int d1) => (d0 + d1) ~/ 2;
  /// --------------------------------------------------------------------------
  List<WeatherData> generateList(List<dynamic> list, int c) {
    List<WeatherData> wdList = [];
    try {
      wdList = List.generate(c, (i) {
        return WeatherData(
          dt: list[i]['dt'] * 1000,
          temp: list[i]['main']['temp'].toInt(),
          minTemp: list[i]['main']['temp_min'].toInt(),
          maxTemp: list[i]['main']['temp_max'].toInt(),
          averageTemp: average(list[i]['main']['temp_min'].toInt(), list[i]['main']['temp_max'].toInt()),
          humidity: list[i]['main']['humidity'],
          windSpeed: list[i]['wind']['speed'].toInt(),
          windDir: list[i]['wind']['deg'],
          name: capitalize(list[i]['weather'][0]['description']),
          weatherCode: list[i]['weather'][0]['id'],
        );
      });
    } catch(e) {
      //print(e);
      wdList = [];
    }
    return wdList;
  }
  ///---------------------------------------------------------------------------
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  ///---------------------------------------------------------------------------
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/weather_app_forecast_json.txt');
  }
  ///---------------------------------------------------------------------------
  Future<void> save(String json) async {
    final file = await _localFile;
    await file.writeAsString(json);
  }
  ///---------------------------------------------------------------------------
  Future<String?> checkLocalSave() async {
    try {
      final file = await _localFile;
      final json = await file.readAsString();
      return json;
    } catch (e) {
      return null;
    }
  }
  /// --------------------------------------------------------------------------
  int decodeWeatherID(int id) {
    int iconID;
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
    return iconID;
  }
  /// --------------------------------------------------------------------------
  String decodeWindDegrees(int deg) {
    String wind = '';
    if(deg >= 345 && deg < 30) {
      wind = 'северный';
    } else if(deg >= 30 && deg < 75) {
      wind = 'северо-восточный';
    }  else if(deg >= 75 && deg < 120) {
      wind = 'восточный';
    } else if(deg >= 120 && deg < 165) {
      wind = 'юго-восточный';
    } else if(deg >= 165 && deg < 210) {
      wind = 'южный';
    } else if(deg >= 210 && deg < 255) {
      wind = 'юго-западный';
    } else if(deg >= 255 && deg < 300) {
      wind = 'западный';
    } else if(deg >= 300 && deg < 345) {
      wind = 'северо-западный';
    } else {
      wind = 'северный';
    }
    return wind;
  }
  /// --------------------------------------------------------------------------
  String decodeHumidity(int hum) {
    String humidity = '';
    if(hum < 40) {
      humidity = 'Низкая';
    } else if(hum >= 40 && hum < 70) {
      humidity = 'Средняя';
    } else if(hum > 70) {
      humidity = 'Высокая';
    }
    return humidity;
  }
  /// --------------------------------------------------------------------------
  String decodeDay(int dt) {
    String day = '';
    if(DateTime.fromMillisecondsSinceEpoch(dt).day == DateTime.now().day) {
      day = 'Сегодня';
    } else if(DateTime.fromMillisecondsSinceEpoch(dt).day - DateTime.now().day > 1){
      day = 'Послезавтра';
    } else {
      day = 'Завтра';
    }
    return day;
  }
  /// --------------------------------------------------------------------------
  String decodeCountry(String code) {
    String countryName = '';
    /// just a temporary function TODO---!
    if(code == 'RU') {
      countryName = 'Россия';
    } else {
      countryName = code;
    }
    return countryName;
  }
  /// --------------------------------------------------------------------------
  String errorMsg(int code) {
    switch(code) {
      case -1:
        return 'Отсутствует разрешение на доступ к геолокации';
      case -2:
        return 'Пожалуйста, убедитетсь что Ваше устройство подключено к сети Интернет и службы геолокации включены';
      case -3:
        return 'Произошла ошибка при загрузке данных';
      default:
        return 'Произошла ошибкa';
    }
  }
/// --------------------------------------------------------------------------
}