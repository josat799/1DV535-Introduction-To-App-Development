import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_me_up/models/weather_content.dart';
import 'package:weather_me_up/models/weather_information.dart';

class TitleHeader extends StatelessWidget {
  final double opacity;
  const TitleHeader({
    super.key,
    required this.opacity,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      softWrap: true,
      text: TextSpan(
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: AnimatedOpacity(
              duration: const Duration(
                milliseconds: 1000,
              ),
              opacity: opacity,
              child: Consumer<WeatherContent>(
                builder: (_, fetchedWeather, __) {
                  Temperature temp =
                      fetchedWeather.weatherInformation!.temperatures;
                  return Text(
                    opacity == 1
                        ? "${temp.currentToString} (${temp.maxToString}/${temp.minToString})"
                        : "",
                    style: Theme.of(context).textTheme.titleLarge,
                  );
                },
              ),
            ),
          ),
          TextSpan(
            text: opacity == 1 ? '\n' : '',
            children: [
              WidgetSpan(
                child: Icon(
                  Icons.location_on_rounded,
                  size: Theme.of(context).textTheme.titleLarge!.fontSize,
                  color: Theme.of(context).textTheme.titleLarge!.color,
                ),
                style: Theme.of(context).textTheme.titleLarge,
                alignment: PlaceholderAlignment.middle,
              ),
              TextSpan(
                text: Provider.of<WeatherContent>(context)
                    .weatherInformation!
                    .cityName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
