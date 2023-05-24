// ignore_for_file: file_names

class WeatherModel {
  final double temp;
  final double feelsLike;
  final double low;
  final double high;
  final String description;
  final String name;
  final String icon;

  WeatherModel({
    required this.temp,
    required this.feelsLike,
    required this.low,
    required this.high,
    required this.description,
    required this.name,
    required this.icon,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      name: json['name'],
      temp: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      low: json['main']['temp_min'].toDouble(),
      high: json['main']['temp_max'].toDouble(),
      description: json['weather'][0]['description'],
      icon : "https://openweathermap.org/img/w/${json['weather'][0]['icon']}.png",
    );
  }
}