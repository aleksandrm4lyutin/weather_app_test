import 'package:weather_app_test/abstracts/weather_data.dart';

class DataPackage {
  final String country;
  final String city;
  final List<WeatherData> weatherData;
  final int code;

  DataPackage({
    required this.country,
    required this.city,
    required this.weatherData,
    required this.code,
  });

}