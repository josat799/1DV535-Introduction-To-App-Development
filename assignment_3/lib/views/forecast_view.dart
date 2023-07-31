import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_me_up/models/weather_content.dart';
import 'package:weather_me_up/models/weather_information.dart';
import 'package:weather_me_up/widgets/forecast_list_tile.dart';

class ForecastView extends StatelessWidget {
  static const ROUTENAME = "/forecast";

  const ForecastView({super.key});

  @override
  Widget build(BuildContext context) {
    List<WeatherInformation> weatherNodes = [];
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      body: Consumer<WeatherContent>(
        builder: (context, WeatherContent value, _) {
          weatherNodes.addAll(value.forecast!.weathers);
          if (value.forecast!.amountOfweatherData < 41) {
            weatherNodes.insert(0, value.weatherInformation!);
          }

          if (value.forecast == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return CustomScrollView(
              primary: true,
              slivers: [
                SliverAppBar(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  pinned: true,
                  title: RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          child: Icon(
                            Icons.location_on_rounded,
                            size: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .fontSize,
                            color:
                                Theme.of(context).textTheme.titleLarge!.color,
                          ),
                          style: Theme.of(context).textTheme.titleLarge,
                          alignment: PlaceholderAlignment.middle,
                        ),
                        TextSpan(
                          text: value.weatherInformation!.cityName!,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                  ),
                ),
                SliverAnimatedList(
                  itemBuilder: (context, index, animation) {
                    WeatherInformation selectedWeather =
                        weatherNodes.elementAt(index);
                    return ForecastListTile(
                      selectedWeather,
                      key: Key(selectedWeather.calculatedFor.toIso8601String()),
                    );
                  },
                  initialItemCount: weatherNodes.length,
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
