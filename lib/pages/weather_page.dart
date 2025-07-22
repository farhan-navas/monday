import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  void _fetchWeather() async {
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
      // backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),
            Text(
              _weatherModel?.cityName ?? "Loading city...",
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Lottie.asset(
                'assets/${getWeatherAnimation(_weatherModel?.mainCondition)}',
                height: 300,
              ),
            ),
            Text(
              _weatherModel != null
                  ? '${_weatherModel!.temperature.round()}°C'
                  : '',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}
