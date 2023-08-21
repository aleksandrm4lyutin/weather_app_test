
import 'package:flutter/material.dart';
import 'package:weather_app_test/functions/data_service.dart';

class ErrorPage extends StatefulWidget {

  final int code;
  final Function() reload;

  const ErrorPage({Key? key,
    required this.code,
    required this.reload,
  }) : super(key: key);

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {

  final DataService dataService = DataService();


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
          ///
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// error text
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(dataService.errorMsg(widget.code),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontFamily: 'Ubuntu'
                  ),
                ),
              ),
              const SizedBox(height: 40,),
              /// reload button
              InkWell(
                onTap: widget.reload,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(widget.code == -1 ? 'Разрешить' : 'Повторить',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontFamily: 'RobotoRegular'
                      ),
                    ),
                    const Icon(Icons.refresh, color: Colors.white, size: 27,),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
