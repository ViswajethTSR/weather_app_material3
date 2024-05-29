import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/weather.dart';

class ForecastWeatherCard extends StatelessWidget {
  final Hour data;

  ForecastWeatherCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(5),
      color: Theme.of(context).colorScheme.primaryContainer,
      // padding: const EdgeInsets.all(16),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(20),
      //   color: Theme.of(context).colorScheme.secondaryContainer,
      //   gradient: LinearGradient(
      //     begin: Alignment.topCenter,
      //     end: Alignment.bottomCenter,
      //     colors: [Theme.of(context).colorScheme.primaryContainer, Theme.of(context).colorScheme.secondaryContainer],
      //   ),
      //   boxShadow: [
      //     BoxShadow(color: Theme.of(context).colorScheme.tertiary, blurRadius: 2, spreadRadius: 0.1),
      //   ],
      // ),
      // width: 150,
      child: SizedBox(
        width: 130,
        height: 170,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(
              'https:${data.condition!.icon}',
              width: 48,
              height: 48,
              errorBuilder: (context, error, stackTrace) {
                return const CircularProgressIndicator();
              },
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat("dd.MM.yyyy").format(DateTime.parse(data.time!)),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat.jm().format(DateTime.parse(data.time!)),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 8),
            Text(
              '${data.tempC}°C',
              style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 4),
            Text(
              '${data.condition!.text}',
              style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}
