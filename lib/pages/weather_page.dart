import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:monday/models/weather_model.dart';
import 'package:monday/services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // free api key just for tryin out
  final _weatherService = WeatherService('39aa2ccd23b42316e8d41a9690d9a931');
  WeatherModel? _weatherModel;

  _fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();

    try {
      final weatherModel = await _weatherService.getWeatherModel(cityName);
      setState(() {
        _weatherModel = weatherModel;
      });
    } catch (e) {
      print(e);
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'sunny.json';

    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'rainy.json';
      case 'thunderstorm':
        return 'stormy.json';
      case 'clear':
      default:
        return 'sunny.json';
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_weatherModel?.cityName ?? "Loading city.."),

            Lottie.asset(
              'assets/${getWeatherAnimation(_weatherModel?.mainCondition)}',
            ),

            Text('${_weatherModel?.temperature.round()}°C'),
            ElevatedButton(
              onPressed: _fetchWeather,
              child: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }
}
