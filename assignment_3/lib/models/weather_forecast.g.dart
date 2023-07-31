// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_forecast.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherForecast _$WeatherForecastFromJson(Map<String, dynamic> json) =>
    WeatherForecast(
      (json['list'] as List<dynamic>)
          .map((e) => WeatherInformation.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
