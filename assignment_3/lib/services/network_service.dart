import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:weather_me_up/end_points.dart';
import 'package:weather_me_up/models/weather_content.dart';
import 'package:weather_me_up/models/weather_information.dart';
import 'package:weather_me_up/models/weather_forecast.dart';

class NetworkService with EndPoints {
  final String _apiKey;
  final BuildContext? context;
  late final http.Client _client;
  late final Map<String, dynamic> _baseParameter;

  // TODO: Maybe add language support
  NetworkService(this._apiKey, this.context) {
    _client = http.Client();
    _baseParameter = {'appid': _apiKey, 'units': 'metric'};
  }

  Future<void> fetchCurrentweather(
      {String? cityName, double? lat, double? long}) async {
    if (cityName == null && (lat == null || long == null)) {
      throw NetworkException(
          "You need to either specify cityName or latitude and latitude");
    }
    Map<String, dynamic> parameters = _baseParameter;

    if (cityName != null && cityName.isNotEmpty) {
      parameters['q'] = cityName;
    } else {
      parameters['lat'] = "$lat";
      parameters['lon'] = "$long";
    }

    Uri url = Uri.https(BASEAPIURL, WEATHER, parameters);

    Response response = await _client.get(url);

    if (response.statusCode != 200) {
      throw NetworkException(response.body, code: response.statusCode);
    }
    WeatherInformation currentWeather =
        WeatherInformation.fromJson(json.decode(response.body));
    // Uncomment these lines to enforce some rain or snow in the forecast
    //currentWeather.rainInformation = ShortForecast(12, 1);

    _updateViewModel(currentWeather: currentWeather);
  }

  Future<void> fetchForecast(
      {String? cityName, double? lat, double? long}) async {
    if (cityName == null && (lat == null || long == null)) {
      throw NetworkException(
          "You need to either specify cityName or latitude and latitude");
    }
    Map<String, dynamic> parameters = _baseParameter;

    if (cityName != null && cityName.isNotEmpty) {
      parameters['q'] = cityName;
    } else {
      parameters['lat'] = "$lat";
      parameters['lon'] = "$long";
    }

    Uri url = Uri.https(BASEAPIURL, FORECAST, parameters);

    Response response = await _client.get(url);

    if (response.statusCode != 200) {
      throw NetworkException(response.body, code: response.statusCode);
    }

    WeatherForecast weatherForecast =
        WeatherForecast.fromJson(json.decode(response.body));

    // Uncomment these lines to enforce some rain or snow in the forecast
    // weatherForecast.weathers.first.rainInformation = ShortForecast(12, null);
    // weatherForecast.weathers.elementAt(1).snowInformation =
    //     ShortForecast(12, 1);
    _updateViewModel(weatherForecast: weatherForecast);
  }

  void _updateViewModel(
      {WeatherInformation? currentWeather, WeatherForecast? weatherForecast}) {
    if (currentWeather != null) {
      Provider.of<WeatherContent>(context!, listen: false).weatherInformation =
          currentWeather;
    }
    if (weatherForecast != null) {
      Provider.of<WeatherContent>(context!, listen: false).forecast =
          weatherForecast;
    }
  }
}

class NetworkException implements Exception {
  final String message;
  final int? code;

  NetworkException(this.message, {this.code});

  @override
  String toString() {
    return "${code != null ? '[$code]' : null} $message";
  }
}
