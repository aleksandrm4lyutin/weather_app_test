import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:weather_app_test/functions/data_service.dart';
import '../abstracts/data_package.dart';
import '../abstracts/images.dart';


class HomePage extends StatefulWidget {

  final DataPackage data;

  const HomePage({Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int iconID = 0;
  DataService dataService = DataService();
  List<String> bIcons = Images.bIcons;
  List<String> sIcons = Images.sIcons;
  int selected = 0;


  @override
  void initState() {
    super.initState();

    initializeDateFormatting('ru_RU');
  }


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

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 0, 0),
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: Colors.white,
                  size: 27,
                ),
                const SizedBox(width: 10,),
                Text('${dataService.decodeCountry(widget.data.country)}, ',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontFamily: 'RobotoRegular'
                  ),
                ),
                Text(widget.data.city,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontFamily: 'RobotoRegular'
                  ),
                ),
              ],
            ),
          ),

          /// big icon
          Padding(
            padding: const EdgeInsets.only(top: 20),
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
                image: AssetImage('assets/images/${bIcons[dataService.decodeWeatherID(widget.data.weatherData[selected].weatherCode)]}'),
                // height: 100,
                // width: 100,
              ),
            ),
          ),

          ///
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              Center(
                child: Text('${widget.data.weatherData[selected].averageTemp}°',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 54,
                      fontFamily: 'RobotoRegular'
                  ),
                ),
              ),

              Center(
                child: Text(widget.data.weatherData[selected].name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontFamily: 'RobotoRegular'
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Макс.: ${widget.data.weatherData[selected].maxTemp}°',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontFamily: 'RobotoRegular'
                      ),
                    ),
                    const SizedBox(width: 5,),
                    Text('Мин.: ${widget.data.weatherData[selected].minTemp}°',
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontFamily: 'RobotoRegular'
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(dataService.decodeDay(widget.data.weatherData[selected].dt),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontFamily: 'RobotoBold'
                                  ),
                                ),

                                Text(DateFormat.MMMMd('ru_RU').format(DateTime.fromMillisecondsSinceEpoch(widget.data.weatherData[selected].dt)),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontFamily: 'RobotoRegular'
                                  ),
                                ),
                              ],
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20.0),
                              child: Container(
                                height: 2,
                                color: Colors.white60,
                              ),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(widget.data.weatherData.length, (index) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      selected = index;
                                    });
                                  },
                                  child: Container(
                                      decoration: selected == index ? BoxDecoration(
                                        color: Colors.white.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(width: 2, color: Colors.white30),
                                      ) : BoxDecoration(
                                        color: Colors.transparent,
                                        border: Border.all(width: 2, color: Colors.transparent),
                                      ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [

                                          Text(DateFormat.Hm('ru_RU').format(DateTime.fromMillisecondsSinceEpoch(widget.data.weatherData[index].dt)),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontFamily: 'RobotoRegular'
                                            ),
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                                            child: Image(
                                              image: AssetImage('assets/images/${sIcons[dataService.decodeWeatherID(widget.data.weatherData[index].weatherCode)]}'),
                                              // height: 100,
                                              // width: 100,
                                            ),
                                          ),

                                          Text('${widget.data.weatherData[index].temp}°',
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 22,
                                                fontFamily: 'RobotoRegular'
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.air_rounded,
                                      color: Colors.white,
                                      size: 27,
                                    ),
                                    const SizedBox(width: 10,),
                                    Text('${widget.data.weatherData[selected].windSpeed}м/с',
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 17,
                                          fontFamily: 'RobotoRegular'
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20,),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.water_drop_outlined,
                                      color: Colors.white,
                                      size: 27,
                                    ),
                                    const SizedBox(width: 10,),
                                    Text('${widget.data.weatherData[selected].humidity}%',
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 17,
                                          fontFamily: 'RobotoRegular'
                                      ),
                                    ),
                                  ],
                                ),

                              ],
                            ),

                            const SizedBox(width: 20,),

                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Ветер ${dataService.decodeWindDegrees(widget.data.weatherData[selected].windDir)}',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontFamily: 'RobotoRegular'
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20,),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('${dataService.decodeHumidity(widget.data.weatherData[selected].humidity)} влажность',
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontFamily: 'RobotoRegular'
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10,),

            ],
          ),
        ],
      ),
    );
  }
}
