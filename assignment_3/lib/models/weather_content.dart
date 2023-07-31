import 'dart:collection';

import 'package:weather_me_up/models/weather_information.dart';
import 'package:weather_me_up/models/weather_forecast.dart';

import 'package:flutter/material.dart';

class WeatherContent with ChangeNotifier {
  late double _currentLatitude;
  late double _currentLongitude;
  DateTime? _weatherInformationUpdated;
  DateTime? _forecastUpdated;
  final Set<String> _savedLocations = {};
  // TODO: Add position maybe?
  // TODO: Add language support?

  WeatherInformation? _currentWeather;
  WeatherForecast? _currentForecast;

  double get currentLatitude => _currentLatitude;
  double get currentLongitude => _currentLongitude;
  DateTime? get weatherInformationUpdated => _weatherInformationUpdated;
  DateTime? get forecastUpdated => _forecastUpdated;
  UnmodifiableListView<String> get savedLocations =>
      UnmodifiableListView(_savedLocations);

  WeatherInformation? get weatherInformation => _currentWeather;
  WeatherForecast? get forecast => _currentForecast;

  set forecast(WeatherForecast? forecast) {
    _currentForecast = forecast;
    notifyListeners();
  }

  set weatherInformation(WeatherInformation? weatherInformation) {
    _currentWeather = weatherInformation;
    notifyListeners();
  }

  set currentLatitude(double latitiude) {
    _currentLatitude = latitiude;
    notifyListeners();
  }

  set currentLongitude(double longitude) {
    _currentLongitude = longitude;
    notifyListeners();
  }

  set weatherInformationUpdated(DateTime? time) {
    _weatherInformationUpdated = time;
    notifyListeners();
  }

  set forecastUpdated(DateTime? time) {
    _forecastUpdated = time;
    notifyListeners();
  }

  removeLocation(String location) {
    _savedLocations.removeWhere((element) => element == location);
    notifyListeners();
  }

  addLocation(String location) {
    _savedLocations.add(location);
    notifyListeners();
  }

  setCoordinates(double longitude, double latitude) {
    _currentLatitude = latitude;
    _currentLongitude = longitude;
    _weatherInformationUpdated = _forecastUpdated = DateTime.now();
    notifyListeners();
  }
}
