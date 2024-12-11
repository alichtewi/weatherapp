import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'weather_service.dart';
import 'weather_model.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('816870ff64ac82bfb86ca61db92c8937');
  Weather? _weather;

  Future<void> fetchWeather() async {
    String cityName = await _weatherService.getCurrentCity();
    print("City fetched: $cityName");

    if (cityName == 'Unknown') {
      setState(() {
        _weather = null;
      });
      return;
    }

    try {
      final weather = await _weatherService.getWeather(cityName);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print("Error fetching weather: $e");
      setState(() {
        _weather = null;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather();
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return 'assets/cloudy.json';
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        return 'assets/rainy.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _weather?.cityName ?? "Loading city...",
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            Lottie.asset(getWeatherAnimation(_weather?.mainCondition)),
            Text(
              _weather?.temperature.round().toString() ?? "0°C",
              style: const TextStyle(color: Colors.white, fontSize: 32),
            ),
            Text(
              _weather?.mainCondition ?? "Unknown",
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

