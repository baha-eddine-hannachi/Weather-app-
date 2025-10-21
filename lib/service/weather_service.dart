import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/model/weather_model.dart';
import 'package:geocoding/geocoding.dart';

class WeatherService {
  static const BASE_url = "https://api.openweathermap.org/data/2.5/weather";
  final String apiKey;
  WeatherService({required this.apiKey});
  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(
      Uri.parse("$BASE_url?q=$cityName&appid=$apiKey&units=metric"),
    );
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load weather data");
    }
  }

  Future<String> getCurrentCity() async {
    try {
      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      // If permission is still denied, throw exception
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw Exception('Location permission denied');
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get placemarks from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      // Check if we got any placemarks
      if (placemarks.isEmpty) {
        throw Exception('No placemarks found');
      }

      // Try to get city name from locality
      String? city = placemarks[0].locality;

      // If locality is null, try other location fields
      if (city == null || city.isEmpty) {
        city =
            placemarks[0].subAdministrativeArea ??
            placemarks[0].administrativeArea;
      }

      // If still no city, throw exception
      if (city == null || city.isEmpty) {
        throw Exception('Could not determine city name');
      }
      print(city);

      return city;
    } catch (e) {
      print('Error in getCurrentCity: $e');
      // Return a default city instead of empty string
      return "London"; // Or throw the exception: throw e;
    }
  }
}
