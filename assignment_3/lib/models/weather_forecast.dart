import 'package:json_annotation/json_annotation.dart';
import 'package:weather_me_up/models/weather_information.dart';

part 'weather_forecast.g.dart';

@JsonSerializable(createToJson: false)
class WeatherForecast {
  int get amountOfweatherData => weathers.length;

  @JsonKey(name: 'list')
  final List<WeatherInformation> weathers;

  WeatherForecast(this.weathers);

  factory WeatherForecast.fromJson(Map<String, dynamic> json) =>
      _$WeatherForecastFromJson(json);

  @override
  String toString() {
    String result = "Amount of data $amountOfweatherData \n";

    for (WeatherInformation element in weathers) {
      result += "\n$element";
    }
    return result;
  }
}
