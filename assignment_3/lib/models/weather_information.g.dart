// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_information.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherInformation _$WeatherInformationFromJson(Map<String, dynamic> json) =>
    WeatherInformation(
      const _NestedWeatherConverter().fromJson(json['weather'] as List),
      json['name'] as String?,
      Temperature.fromJson(json['main'] as Map<String, dynamic>),
      SunMetaData.fromJson(json['sys'] as Map<String, dynamic>),
      json['dt'] as int,
      json['rain'] == null
          ? null
          : ShortForecast.fromJson(json['rain'] as Map<String, dynamic>),
      json['snow'] == null
          ? null
          : ShortForecast.fromJson(json['snow'] as Map<String, dynamic>),
      WindMetaInformation.fromJson(json['wind'] as Map<String, dynamic>),
    );

WindMetaInformation _$WindMetaInformationFromJson(Map<String, dynamic> json) =>
    WindMetaInformation(
      (json['speed'] as num).toDouble(),
      (json['deg'] as num).toDouble(),
    );

ShortForecast _$ShortForecastFromJson(Map<String, dynamic> json) =>
    ShortForecast(
      (json['1h'] as num?)?.toDouble(),
      (json['3h'] as num?)?.toDouble(),
    );

SunMetaData _$SunMetaDataFromJson(Map<String, dynamic> json) => SunMetaData(
      json['sunset'] as int?,
      json['sunrise'] as int?,
    );

Temperature _$TemperatureFromJson(Map<String, dynamic> json) => Temperature(
      (json['temp'] as num).toDouble(),
      (json['feels_like'] as num).toDouble(),
      (json['temp_max'] as num).toDouble(),
      (json['temp_min'] as num).toDouble(),
      (json['humidity'] as num).toDouble(),
    );

Weather _$WeatherFromJson(Map<String, dynamic> json) => Weather(
      json['main'] as String,
      json['description'] as String,
      json['icon'] as String,
    );
