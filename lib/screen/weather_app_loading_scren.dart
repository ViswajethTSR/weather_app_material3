import 'package:flutter/material.dart';

class WeatherAppLoadingScreen extends StatelessWidget {
  const WeatherAppLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      body: Center(
        child: Container(
          height: 200,
          width: 100,
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('lib/assets/images/weather_app_logo.png'),
              const SizedBox(height: 10),
              Text("Weather Forecast", style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary)),
              const SizedBox(height: 10),
              LinearProgressIndicator(color: Theme.of(context).colorScheme.primary)
            ],
          ),
        ),
      ),
    );
  }
}
