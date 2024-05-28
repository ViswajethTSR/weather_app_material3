import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/weather.dart';

class ForecastWeatherCard extends StatelessWidget {
  final Hour data;

  ForecastWeatherCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.primaryContainer,
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
          // ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 3,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        width: 150,
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