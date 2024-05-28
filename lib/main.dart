import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/screen/weather_app.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          // appBarTheme: const AppBarTheme(
          //   backgroundColor: Color(0xfff3da63),
          //   centerTitle: true,
          // ),|~
          colorScheme: ColorScheme.fromSeed(
        seedColor: Color(0xff5496b9),
        brightness: Brightness.light,
        // secondary: Color(0xff87a9c7),
      )),
      home: Splash(),
    );
  }
}

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

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
                nextScreen: const WeatherApp(),
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
