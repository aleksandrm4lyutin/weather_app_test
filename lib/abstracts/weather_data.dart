
class WeatherData {
  final int dt;
  final int temp;
  final int minTemp;
  final int maxTemp;
  final int averageTemp;
  final int humidity;
  final int windSpeed;
  final int windDir;
  final String name;
  final int weatherCode;

  WeatherData({
    required this.dt,
    required this.temp,
    required this.minTemp,
    required this.maxTemp,
    required this.averageTemp,
    required this.humidity,
    required this.windSpeed,
    required this.windDir,
    required this.name,
    required this.weatherCode,
  });

}