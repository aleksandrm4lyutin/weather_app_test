import 'package:weather_app_test/abstracts/weather_data.dart';

class DataPackage {
  final String country;
  final String city;
  final List<WeatherData> weatherData;
  final int code;
  /// codes description:
  /// 0 - with data from the internet
  /// 1 - with locally saved data
  /// -1 - error 'no geo location permission'
  /// -2 - error 'no internet or saved data or geo location'
  /// -3 - error while getting data or general error

  DataPackage({
    required this.country,
    required this.city,
    required this.weatherData,
    required this.code,
  });

}