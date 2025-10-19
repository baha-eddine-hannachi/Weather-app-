import 'package:flutter/material.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/service/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherState();
}

class _WeatherState extends State<WeatherPage> {
  final weather_state = WeatherService(
    apiKey: "80ad578b287a53c86453160161d67ef4",
  );

  Weather? _weather;

  fetchWeather() async {
    String city = await weather_state.getCurrentCity();
    try {
      final weather = await weather_state.getWeather(city);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    fetchWeather();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_weather?.cityName ?? "Loading..."),
            Text('${_weather?.temperature?.round() ?? 0} °C'),
          ],
        ),
      ),
    );
  }
}
