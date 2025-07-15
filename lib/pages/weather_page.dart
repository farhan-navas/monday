import 'package:flutter/material.dart';
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
      print("${cityName} is here");
      final weatherModel = await _weatherService.getWeatherModel(cityName);
      setState(() {
        _weatherModel = weatherModel;
      });
    } catch (e) {
      print(e);
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
