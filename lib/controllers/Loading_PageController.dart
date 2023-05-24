import 'dart:async';
// ignore_for_file: file_names
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../services/weatherApi.dart';
import '../services/weatherModel.dart';

class LoadingController extends GetxController
    with GetTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> animation;
  final Color backgroundColor = const Color.fromARGB(255, 253, 212, 1);
  final Color shadowColor = const Color.fromARGB(89, 255, 208, 0);
  final Key parallaxOne = GlobalKey();
  late double containersize;
  late int animationDuration;
  var messages = [
    "Nous téléchargeons les données...",
    "C'est presque fini...",
    "Veuillez patienter quelques secondes..."
  ].obs;
  bool isWeatherVisible = false;
  List<WeatherModel> weathersData = [];
  RxInt percent = 0.obs;
  RxInt messageIndex = 0.obs;
  double Screensize = 0.0;

  void goBack() {
    Get.back();
  }

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    animationController.repeat(reverse: true);
    animation = Tween(begin: 2.0, end: 15.0).animate(animationController);
    incrementer();
    displayMessage();
    showtable();
    fetchWeather();
    Screensize = Get.height;
    containersize = Screensize*0.5;
    animationDuration = 2000;
  }

  void showtable() {
    Timer.periodic(const Duration(minutes: 1), (timer) {
      isWeatherVisible = true;
      update();
    });
  }


  void incrementer() {
    Timer.periodic(const Duration(milliseconds: 600), (timer) {
      if (percent.value < 100) {
        percent.value++;
      } else {
        timer.cancel();
      }
      update();
    });
  }

  void reloadPage() {
    percent.value = 0;
    containersize = Screensize*0.5;
    animationDuration = 500;
    incrementer();
    weathersData.clear();
    showtable();
    fetchWeather();
    displayMessage();
  }

  void displayMessage() {
    messageIndex.value = 0;
    final int messagesLength = messages.length;

    Timer.periodic(const Duration(seconds: 6), (timer) {
      if (percent.value < 100) {
        messageIndex.value++;
        if (messageIndex.value >= messagesLength) {
          messageIndex.value = 0;
        }
      } else if (percent.value >= 100) {
        containersize = Screensize*0.3;
        timer.cancel();
      }

      update();
    });
    update();
  }

  Future<void> fetchWeather() async {
    List<String> cities = ["paris", "dakar", "new york", "venise", "miami"];
    String apiKey = "daf7f8250d4f11f19738163cb04d1337";
    String languageCode = "fr";

    try {
      final weatherApi = WeatherApi(Dio());
      final response =
          await weatherApi.fetchWeather(cities[0], apiKey, languageCode);
      if (response != null) {
        WeatherModel weather = WeatherModel.fromJson(response);
        weathersData.add(weather);
        update();
      } else {
        throw Exception("Impossible de récupérer la météo de ${cities[0]}");
      }
      for (int i = 1; i < cities.length; i++) {
        String city = cities[i];
        final response =
            await weatherApi.fetchWeather(city, apiKey, languageCode);
        if (response != null) {
          WeatherModel weather = WeatherModel.fromJson(response);
          weathersData.add(weather);
          update();
        } else {
          throw Exception("Impossible de récupérer la météo de $city");
        }
        await Future.delayed(const Duration(seconds: 10));
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
