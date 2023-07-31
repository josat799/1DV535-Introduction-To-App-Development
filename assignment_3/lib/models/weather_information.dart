import 'package:weather_me_up/end_points.dart';
import 'package:json_annotation/json_annotation.dart';

part 'weather_information.g.dart';

@JsonSerializable(createToJson: false)
class WeatherInformation with EndPoints {
  @_NestedWeatherConverter()
  final Weather weather;

  @JsonKey(name: 'main')
  final Temperature temperatures;

  @JsonKey(name: 'name', includeIfNull: false)
  final String? cityName;

  @JsonKey(name: 'sys')
  final SunMetaData sunMetaInformation;

  @JsonKey(name: 'dt')
  late final DateTime calculatedFor;

  @JsonKey(name: 'rain', includeIfNull: false)
  ShortForecast? rainInformation;

  @JsonKey(name: 'snow', includeIfNull: false)
  ShortForecast? snowInformation;

  @JsonKey(name: 'wind')
  final WindMetaInformation windMetaInformation;

  @JsonKey(includeFromJson: false, includeToJson: false)
  late final Uri iconUrl;

  WeatherInformation(
      this.weather,
      this.cityName,
      this.temperatures,
      this.sunMetaInformation,
      int calculatedFor,
      this.rainInformation,
      this.snowInformation,
      this.windMetaInformation) {
    iconUrl = Uri.https(BASEURL, "$IMAGEICON/${weather.iconId}@4x.png");
    this.calculatedFor =
        DateTime.fromMillisecondsSinceEpoch(calculatedFor * 1000);
  }

  factory WeatherInformation.fromJson(Map<String, dynamic> json) =>
      _$WeatherInformationFromJson(json);

  @override
  String toString() {
    return "The weather for ${calculatedFor.toIso8601String()} is $weather. $temperatures. \n $sunMetaInformation \n $rainInformation \n $snowInformation \n $windMetaInformation";
  }
}

@JsonSerializable(createToJson: false)
class WindMetaInformation {
  final double speed;
  String get speedToString => "$speed m/s";
  final double deg;

  WindMetaInformation(this.speed, this.deg);

  factory WindMetaInformation.fromJson(Map<String, dynamic> json) =>
      _$WindMetaInformationFromJson(json);

  @override
  String toString() {
    return "Wind speed: $speed, deg: $deg";
  }
}

@JsonSerializable(includeIfNull: false, createToJson: false)
class ShortForecast {
  @JsonKey(name: "1h")
  final double? oneHour;
  @JsonKey(name: "3h")
  final double? threeHour;

  ShortForecast(this.oneHour, this.threeHour);

  factory ShortForecast.fromJson(Map<String, dynamic> json) =>
      _$ShortForecastFromJson(json);

  @override
  String toString() {
    return "1h: $oneHour, 3h: $threeHour";
  }
}

@JsonSerializable(createToJson: false)
class SunMetaData {
  @JsonKey(name: 'sunset')
  DateTime? sunset;
  @JsonKey(name: 'sunrise')
  DateTime? sunrise;

  SunMetaData(int? sunset, int? sunrise) {
    if (sunset == null || sunrise == null) {
      return;
    }
    this.sunset = DateTime.fromMillisecondsSinceEpoch(sunset * 1000);
    this.sunrise = DateTime.fromMillisecondsSinceEpoch(sunrise * 1000);
  }

  factory SunMetaData.fromJson(Map<String, dynamic> json) =>
      _$SunMetaDataFromJson(json);

  @override
  String toString() {
    return 'The sun will rise at: ${sunrise?.toLocal().toIso8601String()} and will set at: ${sunset?.toLocal().toIso8601String()}';
  }
}

@JsonSerializable(createToJson: false)
class Temperature {
  @JsonKey(name: 'temp')
  final double current;
  String get currentToString => "${current.round()}°C";

  @JsonKey(name: 'feels_like')
  final double feelsLike;
  String get feelsLikeToString => "${feelsLike.round()}°C";

  @JsonKey(name: 'temp_max')
  final double max;
  String get maxToString => "${max.round()}°C";

  @JsonKey(name: 'temp_min')
  final double min;
  String get minToString => "${min.round()}°C";

  @JsonKey(name: 'humidity')
  final double humidity;

  Temperature(this.current, this.feelsLike, this.max, this.min, this.humidity);

  factory Temperature.fromJson(Map<String, dynamic> json) =>
      _$TemperatureFromJson(json);

  @override
  String toString() {
    return "Current temp: $current, Feels Like: $feelsLike, Max: $max, Min: $min, humidity: $humidity";
  }
}

@JsonSerializable(createToJson: false)
class Weather {
  final String main;
  final String description;
  @JsonKey(name: 'icon')
  final String iconId;

  Weather(this.main, this.description, this.iconId);

  @override
  String toString() {
    return "$main ($description)";
  }
}

class _NestedWeatherConverter extends JsonConverter<Weather, List<dynamic>> {
  const _NestedWeatherConverter();

  @override
  Weather fromJson(List<dynamic> json) {
    var firstValue = json.first;

    return _$WeatherFromJson(firstValue);
  }

  @override
  List toJson(Weather object) {
    return [];
  }
}
