class Weather{
  String cityName;
  double temperature;
  String weatherStateName;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.weatherStateName,
  });
  factory Weather.fromJson(Map<String, dynamic> json){
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      weatherStateName: json['weather'][0]['main'],
    );
  }

}