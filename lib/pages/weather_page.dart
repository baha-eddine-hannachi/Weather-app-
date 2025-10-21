import 'package:flutter/material.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/service/weather_service.dart';
import 'package:lottie/lottie.dart';

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
      final weather = await weather_state.getWeather("portugal");
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

  String getWeatherIcon(Weather weather) {
    if (weather.weatherStateName == 'Clear') {
      return "assets/Weather-sunny.json";
    } else if (weather.weatherStateName == 'Rain') {
      return "assets/Weather-mist.json";
    } else if (weather.weatherStateName == 'Clouds') {
      return "assets/Weather-partly cloudy.json";
    }

    // default icon if no known weather state matches
    return "assets/Weather-sunny.json";
  }

  @override
  Widget build(BuildContext context) {
    // show loader while weather is null
    if (_weather == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // safe to use _weather! here because we've checked for null
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          
          children: [
          Container(
            child: Column(
              children: [
            Text('${_weather!.temperature.round()} °C'),
            const Icon(Icons.location_on),]),),
            Lottie.asset(
              getWeatherIcon(_weather!),
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            Text(_weather!.cityName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 28),)
          ],
        ),
      ),
    );
  }
}
