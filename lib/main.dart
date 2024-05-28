import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/screen/weather_app.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color seedColor = Color(0xfd09bfe8);
  void changeColor(Color color) {
    setState(() {
      seedColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness.name == "light";
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: isLightMode ? Brightness.light : Brightness.dark,
        ),
      ),
      home: Splash(onColorChanged: changeColor),
    );
  }
}

class Splash extends StatelessWidget {
  final Function(Color) onColorChanged;

  const Splash({required this.onColorChanged, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 300),
            SizedBox(
              height: 200,
              width: 300,
              // color: Theme.of(context).colorScheme.secondaryContainer,
              child: FlutterSplashScreen(
                splashScreenBody: Center(
                  child: Image.asset("lib/assets/images/weather_app_logo.png"),
                ),
                nextScreen: WeatherApp(onColorChanged: onColorChanged),
                backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                duration: const Duration(milliseconds: 3000),
                onInit: () async {
                  await Future.delayed(const Duration(milliseconds: 2000));
                },
                onEnd: () async {},
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Weather Forecast",
              style:
                  TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Nunito', fontSize: 30, color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}
