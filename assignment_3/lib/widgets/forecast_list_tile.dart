import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:weather_me_up/models/weather_information.dart';

class ForecastListTile extends StatelessWidget {
  final WeatherInformation weatherInformation;

  final double minLeadingWidth = 50;
  final titleAlignment = ListTileTitleAlignment.center;

  late final trailing = FadeInImage.memoryNetwork(
    placeholder: kTransparentImage,
    image: weatherInformation.iconUrl.toString(),
  );

  late final leading = RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      text: DateFormat('EEEE\nd/M\nHH:mm')
          .format(weatherInformation.calculatedFor),
    ),
  );

  ForecastListTile(
    this.weatherInformation, {
    required super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: key,
      minLeadingWidth: minLeadingWidth,
      titleAlignment: titleAlignment,
      trailing: trailing,
      leading: leading,
      title: createListTileTitle(context, weatherInformation),
    );
  }

  RichText createListTileTitle(
      BuildContext context, WeatherInformation selectedWeather) {
    return RichText(
      softWrap: true,
      textAlign: TextAlign.center,
      text: TextSpan(
        style: Theme.of(context).textTheme.titleSmall,
        children: [
          TextSpan(
            text: selectedWeather.weather.main,
            children: [
              TextSpan(
                  text:
                      '\n${selectedWeather.temperatures.currentToString} (${selectedWeather.temperatures.maxToString}/${selectedWeather.temperatures.minToString})'),
              TextSpan(
                text: "\n",
                children: [
                  if (selectedWeather.rainInformation != null &&
                      selectedWeather.rainInformation!.threeHour != null) ...[
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Icon(
                        Icons.water_drop_outlined,
                        size: Theme.of(context).textTheme.titleSmall!.fontSize,
                      ),
                    ),
                    TextSpan(
                      text: "${selectedWeather.rainInformation!.threeHour}mm ",
                    ),
                  ],
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Icon(
                      Icons.air_outlined,
                      size: Theme.of(context).textTheme.titleSmall!.fontSize,
                    ),
                  ),
                  TextSpan(
                    text: selectedWeather.windMetaInformation.speedToString,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
