
// ignore_for_file: file_names

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class WeatherApi {
  final Dio dio;

  WeatherApi(this.dio);

  Future<Map<String, dynamic>?> fetchWeather(String city, String apiKey, String languageCode) async {
    try {
      final response = await dio.get(
        "https://api.openweathermap.org/data/2.5/weather",
        queryParameters: {
          'q': city,
          'appid': apiKey,
          'units': 'metric',
          'lang': languageCode,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return null;
    }
  }
}
