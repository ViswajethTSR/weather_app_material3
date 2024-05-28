import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as GeoLocator;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/toast_manager.dart';
import 'package:weather_app/screen/weather_app_loading_scren.dart';
import '../custom_widgets/forecast_weather_card.dart';
import '../models/weather.dart';
import 'package:weather_app/custom_widgets/weather_graph_template.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import '../my_constants.dart';

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  LocationPermission? permission;
  String? _cityName;
  String _temperature = '';
  String _iconUrl = '';
  double _windSpeed = 0.0;
  int _humidity = 0;
  bool _isLoading = false;
  TextEditingController textEditingController = TextEditingController();
  Weather? weatherResponse;
  List<WeatherData> _timeVsTempList = [];
  List<WeatherData> _windSpeedList = [];
  final _scrollController = ScrollController();
  final now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _onInit();
  }

  Future<void> _onInit() async {
    await _locationPermissionCheck();
    await _getCurrentLocationAndCityName();
    await _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    setState(() {
      _isLoading = true;
      _timeVsTempList.clear();
      _windSpeedList.clear();
    });

    try {
      final response = await MyConst.dio.get(
        'https://weatherapi-com.p.rapidapi.com/forecast.json?q=${_cityName}&days=3',
        options: Options(
          headers: {
            'X-RapidAPI-Key': '1fe6d01ae5msh2559675af7836d9p12091bjsne9818efda569',
            'X-RapidAPI-Host': 'weatherapi-com.p.rapidapi.com'
          },
        ),
      );
      if (response.statusCode == 200) {
        weatherResponse = Weather.fromJson(response.data);

        final List<dynamic> list = weatherResponse!.forecast!.forecastday!;

        for (Forecastday forecastday in list) {
          for (Hour hour in forecastday.hour!) {
            final temperature = hour.tempC?.toStringAsFixed(1);
            final dateTime = DateTime.parse(hour.time ?? "");
            _timeVsTempList.add(WeatherData(DateFormat("MMM d / HH:mm").format(dateTime), double.parse(temperature!)));
          }
        }
        for (Forecastday forecastday in list) {
          for (Hour hour in forecastday.hour!) {
            final windSpeed = hour.windKph?.toStringAsFixed(1);
            final dateTime = DateTime.parse(hour.time ?? "");
            _windSpeedList.add(WeatherData(DateFormat("MMM d / HH:mm").format(dateTime), double.parse(windSpeed!)));
          }
        }

        setState(() {
          _temperature = weatherResponse!.current!.tempC.toString();
          _iconUrl = "https:" + weatherResponse!.current!.condition!.icon!;
          _windSpeed = weatherResponse!.current!.windKph!.toDouble();
          _humidity = weatherResponse!.current!.humidity!.toInt();
          _isLoading = false;
        });
        await _scrolltoCurrentTime();
      }
    } catch (e) {
      ToastManager.showToast(msg: "Weather Data is not available for your location");
      print(e);
    }
  }

  Future<void> _getCurrentLocationAndCityName() async {
    try {
      _isLoading = true;
      GeoLocator.Position position = await GeoLocator.Geolocator.getCurrentPosition(desiredAccuracy: GeoLocator.LocationAccuracy.high);

      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      _cityName = place.locality ?? "";
      ToastManager.showToast(msg: _cityName);

      _isLoading = false;
    } catch (e) {
      ToastManager.showToast(msg: e.toString());
      print('Error getting current location: $e');
    }
  }

  Future<void> _locationPermissionCheck() async {
    _isLoading = true;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      setState(() {
        _isLoading = false;
      });
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
  }

  Future<void> _scrolltoCurrentTime() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(now.hour * 158.5, duration: const Duration(milliseconds: 800), curve: Curves.bounceInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather Forecast"),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        actions: [
          IconButton(
              onPressed: () {
                _getCurrentLocationAndCityName();
                _fetchWeatherData();
              },
              icon: Icon(
                Icons.location_pin,
                color: Theme.of(context).appBarTheme.actionsIconTheme?.color,
              ))
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      body: _getBody(),
    );
  }

  Widget _getBody() {
    return Column(
      children: [
        _getNewSearchBar(),
        _isLoading
            ? const Expanded(child: WeatherAppLoadingScreen())
            : Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 20),
                      _getCurrentWeatherForecast(),
                      const SizedBox(height: 20),
                      Divider(
                        indent: 20,
                        endIndent: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 20),
                      _get3DaysForecastWidget(),
                      const SizedBox(height: 20),
                      Divider(
                        indent: 20,
                        endIndent: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      Center(
                        child: Text(
                          "Weather Stats",
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 32, color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Center(
                        child: Text(
                          "Temperature Graph",
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                      WeatherGraphTemplate(
                        padding: const EdgeInsets.all(20),
                        weatherData: _timeVsTempList,
                        title: "Temperature",
                        unit: "°C",
                      ),
                      const SizedBox(height: 15),
                      Center(
                        child: Text(
                          "WindSpeed Graph",
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Theme.of(context).colorScheme.primary),
                        ),
                      ),
                      WeatherGraphTemplate(
                        padding: const EdgeInsets.all(20),
                        weatherData: _windSpeedList,
                        title: "WindSpeed",
                        unit: "Kph",
                      ),
                    ],
                  ),
                ),
              ),
      ],
    );
  }

  Padding _getNewSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0, left: 15, bottom: 5, top: 20),
      child: SearchBar(
        hintText: _cityName,
        controller: textEditingController,
        leading: Icon(
          Icons.location_city_outlined,
          color: Theme.of(context).colorScheme.primary,
        ),
        backgroundColor:
            MaterialStatePropertyAll(MaterialStateColor.resolveWith((states) => Theme.of(context).colorScheme.secondaryContainer)),
        trailing: [
          IconButton(
              onPressed: () {
                _cityName = textEditingController.text;
                _fetchWeatherData();
              },
              icon: Icon(
                Icons.search,
                color: Theme.of(context).colorScheme.primary,
              ))
        ],
      ),
    );
  }

  Widget _getSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 20),
      child: TextField(
        controller: textEditingController,
        autocorrect: true,
        decoration: InputDecoration(
          hintText: _cityName ?? "",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(color: Colors.green, width: 2.0),
          ),
          filled: true,
          enabled: true,
          fillColor: Colors.grey.shade200,
          suffixIcon: IconButton(
            icon: Icon(Icons.search, color: Theme.of(context).colorScheme.secondary),
            onPressed: () {
              _cityName = textEditingController.text;
              _windSpeedList.clear();
              _timeVsTempList.clear();
              _fetchWeatherData();
              textEditingController.clear();
            },
          ),
        ),
      ),
    );
  }

  Widget _getCurrentWeatherForecast() {
    return Container(
      height: 150,
      width: 365,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        // gradient: LinearGradient(
        //   begin: Alignment.topCenter,
        //   end: Alignment.bottomCenter,
        //   colors: [Theme.of(context).colorScheme.primaryContainer, Theme.of(context).colorScheme.secondaryContainer],
        // ),
        color: Theme.of(context).colorScheme.primaryContainer,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [_getOverallCurrentTemp(), _getAdditionalWeatherInfo()],
      ),
    );
  }

  Widget _getOverallCurrentTemp() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            _temperature + '°C',
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          Center(
            child:
                Text("${weatherResponse!.current!.condition!.text}" ?? "", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          ),
          Text(
            _cityName ?? "",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  Widget _getAdditionalWeatherInfo() {
    return SizedBox(
      width: 100,
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
          children: [
            TableRow(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  alignment: Alignment.center,
                  child: _getFeelsLikeTemp(),
                ),
              ],
            ),
            TableRow(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  alignment: Alignment.center,
                  child: _getWindSpeed(),
                ),
              ],
            ),
            TableRow(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  alignment: Alignment.center,
                  child: _getHumidityValue(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _get3DaysForecastWidget() {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondaryContainer,
          border: Border(
              top: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
              bottom: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2))),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Center(
            child: Text(
              "Three days Forecast",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: 370,
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (Forecastday forecastDay in weatherResponse!.forecast!.forecastday!)
                    for (Hour hour in forecastDay.hour!) ForecastWeatherCard(data: hour)
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _getFeelsLikeTemp() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Icon(
          Icons.thermostat,
          size: 22,
          color: Theme.of(context).colorScheme.primary,
        ),
        Text(
          "${weatherResponse!.current!.feelslikeC} °C",
          style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.primary),
        ),
      ],
    );
  }

  Widget _getWindSpeed() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Icon(
          Icons.wind_power,
          color: Theme.of(context).colorScheme.primary,
          size: 22,
        ),
        Text(
          '${_windSpeed.toInt()} Kph',
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget _getHumidityValue() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Icon(
          Icons.water_drop,
          color: Theme.of(context).colorScheme.primary,
          size: 22,
        ),
        Text(
          '$_humidity %',
          style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.primary),
        ),
        const SizedBox(width: 0.1)
      ],
    );
  }

  Widget _getIconFromEndpoint(String iconUrl) {
    return Image.network(
      iconUrl,
      errorBuilder: (context, error, stackTrace) {
        return const CircularProgressIndicator();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
