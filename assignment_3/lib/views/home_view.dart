import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:weather_me_up/extensions/string_extension.dart';
import 'package:weather_me_up/models/weather_content.dart';
import 'package:weather_me_up/models/weather_information.dart';
import 'package:weather_me_up/services/network_service.dart';
import 'package:weather_me_up/views/about_view.dart';
import 'package:weather_me_up/views/forecast_view.dart';
import 'package:weather_me_up/widgets/weather_app_bar/header_widget.dart';
import 'package:weather_me_up/widgets/weather_app_bar/weather_app_bar.dart';

class HomeView extends StatefulWidget {
  static const ROUTENAME = "/home";
  final String apiKey;
  const HomeView({super.key, required this.apiKey});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final scrollController = ScrollController();
  late final NetworkService _networkService;

  double _opacity = 0;

  Future<void> fetchAndSetWeatherForecast({bool force = false}) async {
    WeatherContent weatherContent =
        Provider.of<WeatherContent>(context, listen: false);

    if (force || weatherContent.forecastUpdated == null) {
      await Geolocator.getCurrentPosition().then((newPosition) async {
        weatherContent.setCoordinates(
            newPosition.longitude, newPosition.latitude);

        await _networkService.fetchForecast(
            lat: weatherContent.currentLatitude,
            long: weatherContent.currentLongitude);
      });
    } else if (weatherContent.forecast != null &&
        DateTime.now().difference(
                weatherContent.forecast!.weathers.first.calculatedFor) <
            const Duration(minutes: 5)) {
      weatherContent.forecastUpdated = DateTime.now();
      return;
    }
  }

  Future<void> fetchAndSetCurrentWeather({bool force = false}) async {
    WeatherContent weatherContent =
        Provider.of<WeatherContent>(context, listen: false);

    if (force || weatherContent.weatherInformationUpdated == null) {
      await Geolocator.getCurrentPosition().then((newPosition) async {
        weatherContent.setCoordinates(
            newPosition.longitude, newPosition.latitude);

        await _networkService.fetchCurrentweather(
            lat: weatherContent.currentLatitude,
            long: weatherContent.currentLongitude);
      });
    } else if (weatherContent.weatherInformation != null &&
        DateTime.now()
                .difference(weatherContent.weatherInformation!.calculatedFor) <
            const Duration(minutes: 5)) {
      weatherContent.weatherInformationUpdated = DateTime.now();
      return;
    }
  }

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.offset > 180) {
        setState(() {
          _opacity = 1;
        });
      } else {
        setState(() {
          _opacity = 0;
        });
      }
    });

    _networkService = NetworkService(widget.apiKey, context);
    fetchAndSetCurrentWeather(force: false);
    fetchAndSetWeatherForecast(force: false);

    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Widget addForecastCard(List<WeatherInformation> shortWeatherForecast) {
    return Card(
      child: Column(
        children: [
          Center(
            child: Text(
              "Upcomming weather",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          SizedBox(
            height: 150,
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: shortWeatherForecast.length + 1,
              itemBuilder: (_, index) {
                if (index == shortWeatherForecast.length) {
                  return Container(
                    margin: const EdgeInsets.all(8.0),
                    child: IconButton(
                      style: IconButton.styleFrom(
                        padding: const EdgeInsets.all(8.0),
                        backgroundColor:
                            Theme.of(context).colorScheme.inversePrimary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      icon: const Icon(Icons.arrow_right_alt_outlined),
                      onPressed: () => Navigator.of(context)
                          .pushNamed(ForecastView.ROUTENAME),
                    ),
                  );
                } else {
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RichText(
                        softWrap: true,
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text:
                                    "${DateFormat('dd/M\nHH:mm').format(shortWeatherForecast.elementAt(index).calculatedFor)}\n",
                                style: Theme.of(context).textTheme.labelLarge),
                            TextSpan(
                              children: [
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: FadeInImage.memoryNetwork(
                                    imageScale: 8.0,
                                    placeholder: kTransparentImage,
                                    image: shortWeatherForecast
                                        .elementAt(index)
                                        .iconUrl
                                        .toString(),
                                  ),
                                ),
                                TextSpan(
                                    text: shortWeatherForecast
                                        .elementAt(index)
                                        .temperatures
                                        .currentToString,
                                    style:
                                        Theme.of(context).textTheme.labelSmall),
                                TextSpan(
                                  style: Theme.of(context).textTheme.labelSmall,
                                  text: "\n",
                                  children: [
                                    if (shortWeatherForecast
                                                .elementAt(index)
                                                .rainInformation !=
                                            null &&
                                        shortWeatherForecast
                                                .elementAt(index)
                                                .rainInformation
                                                ?.threeHour !=
                                            null) ...[
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Icon(
                                          Icons.water_drop_outlined,
                                          size: Theme.of(context)
                                              .textTheme
                                              .labelSmall!
                                              .fontSize,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            "${shortWeatherForecast.elementAt(index).rainInformation!.threeHour}mm",
                                      )
                                    ]
                                  ],
                                ),
                                TextSpan(
                                  style: Theme.of(context).textTheme.labelSmall,
                                  text: "\n",
                                  children: [
                                    if (shortWeatherForecast
                                                .elementAt(index)
                                                .snowInformation !=
                                            null &&
                                        shortWeatherForecast
                                                .elementAt(index)
                                                .snowInformation
                                                ?.threeHour !=
                                            null) ...[
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Icon(
                                          Icons.cloudy_snowing,
                                          size: Theme.of(context)
                                              .textTheme
                                              .labelSmall!
                                              .fontSize,
                                        ),
                                      ),
                                      TextSpan(
                                          text:
                                              "${shortWeatherForecast.elementAt(index).snowInformation!.threeHour}mm"),
                                    ]
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget addInformationCard(Set<TextSpan> texts, {TextSpan? title}) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Center(
          heightFactor: 1.5,
          child: Column(
            children: [
              if (title != null)
                Column(
                  children: [
                    RichText(text: title),
                    const SizedBox(height: 16.0),
                  ],
                )
              else
                Container(),
              if (texts.length == 1)
                RichText(
                  text: texts.first,
                  textAlign: TextAlign.center,
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ...texts
                        .map((e) =>
                            RichText(text: e, textAlign: TextAlign.center))
                        .toList()
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      body: Consumer<WeatherContent>(
        builder: (_, value, __) {
          if (value.weatherInformation == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            WeatherInformation weatherInformation = value.weatherInformation!;
            return RefreshIndicator(
              onRefresh: () async {
                await fetchAndSetCurrentWeather(force: true);
                await fetchAndSetWeatherForecast(force: true);
              },
              child: CustomScrollView(
                controller: scrollController,
                primary: false,
                slivers: [
                  WeatherAppBar(
                    lastfetched: value.weatherInformationUpdated!,
                    weatherInformation: weatherInformation,
                    textTheme: Theme.of(context).textTheme,
                    opacity: _opacity,
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    title: TitleHeader(opacity: _opacity),
                  ),
                  SliverList.list(
                    children: [
                      addInformationCard(
                        {
                          TextSpan(
                            text: "Right now you can expect \n",
                            style: Theme.of(context).textTheme.bodyLarge,
                            children: [
                              TextSpan(
                                text: weatherInformation.weather.description
                                    .capitalize(),
                              ),
                            ],
                          ),
                        },
                      ),
                      const SizedBox(height: 16),
                      if (value.forecast != null) ...[
                        addForecastCard(
                            value.forecast!.weathers.sublist(0, 10)),
                        const SizedBox(height: 16),
                      ],
                      addInformationCard(
                        title: TextSpan(
                            text: "Humidity",
                            style: Theme.of(context).textTheme.headlineSmall),
                        {
                          TextSpan(
                            style: Theme.of(context).textTheme.bodyLarge,
                            children: [
                              const WidgetSpan(
                                  child: Icon(Icons.water_drop_outlined,
                                      size: 32.0)),
                              TextSpan(
                                  text:
                                      "\n${weatherInformation.temperatures.humidity}%"),
                            ],
                          )
                        },
                      ),
                      const SizedBox(height: 16),
                      addInformationCard(
                        title: TextSpan(
                            text: "Sunrise/Sunset",
                            style: Theme.of(context).textTheme.headlineSmall),
                        {
                          TextSpan(
                            style: Theme.of(context).textTheme.bodyLarge,
                            children: [
                              const WidgetSpan(
                                  child: Icon(Icons.wb_twilight_outlined,
                                      size: 32.0)),
                              TextSpan(
                                  text:
                                      "\n${DateFormat.Hm().format(weatherInformation.sunMetaInformation.sunrise!)}"),
                            ],
                          ),
                          TextSpan(
                            style: Theme.of(context).textTheme.bodyLarge,
                            children: [
                              WidgetSpan(
                                child: Transform.flip(
                                  flipY: true,
                                  child: const Icon(
                                    Icons.wb_twilight_outlined,
                                    size: 32.0,
                                  ),
                                ),
                              ),
                              TextSpan(
                                text:
                                    "\n${DateFormat.Hm().format(weatherInformation.sunMetaInformation.sunset!)}",
                              ),
                            ],
                          ),
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      addInformationCard(
                        title: TextSpan(
                            text: "Wind",
                            style: Theme.of(context).textTheme.headlineSmall),
                        {
                          TextSpan(
                            style: Theme.of(context).textTheme.bodyLarge,
                            children: [
                              const WidgetSpan(
                                child: Icon(
                                  Icons.air_outlined,
                                  size: 32.0,
                                ),
                              ),
                              TextSpan(
                                  text:
                                      '\n${weatherInformation.windMetaInformation.speedToString}')
                            ],
                          ),
                          TextSpan(
                            style: Theme.of(context).textTheme.bodyLarge,
                            children: [
                              WidgetSpan(
                                child: Transform.rotate(
                                  angle: weatherInformation
                                          .windMetaInformation.deg +
                                      90,
                                  child: const Icon(
                                    Icons.arrow_upward_outlined,
                                    size: 32.0,
                                  ),
                                ),
                              ),
                              TextSpan(
                                  text:
                                      "\n${weatherInformation.windMetaInformation.deg.round()}°")
                            ],
                          ),
                        },
                      ),
                      const SizedBox(height: 16.0),
                      addInformationCard(
                        title: TextSpan(
                          text: "Rain",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        {
                          if (weatherInformation.rainInformation == null)
                            TextSpan(
                              style: Theme.of(context).textTheme.bodyLarge,
                              text:
                                  "There is no rain within the upcomming 3 hours",
                            ),
                          if (weatherInformation.rainInformation?.oneHour !=
                              null)
                            TextSpan(
                              style: Theme.of(context).textTheme.bodyLarge,
                              text: "Current\n",
                              children: [
                                WidgetSpan(
                                    child: Icon(
                                      Icons.water_drop_outlined,
                                      size: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .fontSize,
                                    ),
                                    alignment: PlaceholderAlignment.middle),
                                TextSpan(
                                    text:
                                        "\n${weatherInformation.rainInformation!.oneHour}mm")
                              ],
                            ),
                          if (weatherInformation.rainInformation?.threeHour !=
                              null)
                            TextSpan(
                              style: Theme.of(context).textTheme.bodyLarge,
                              text: "Within 3h\n",
                              children: [
                                WidgetSpan(
                                    child: Icon(
                                      Icons.water_drop_outlined,
                                      size: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .fontSize,
                                    ),
                                    alignment: PlaceholderAlignment.middle),
                                TextSpan(
                                    text:
                                        "\n${weatherInformation.rainInformation!.threeHour}mm")
                              ],
                            )
                        },
                      ),
                      const SizedBox(height: 16.0),
                      addInformationCard(
                        title: TextSpan(
                          text: "Snow",
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        {
                          if (weatherInformation.snowInformation == null)
                            TextSpan(
                                style: Theme.of(context).textTheme.bodyLarge,
                                text:
                                    "There is no snow within the upcomming 3 hours"),
                          if (weatherInformation.snowInformation?.oneHour !=
                              null)
                            TextSpan(
                              style: Theme.of(context).textTheme.bodyLarge,
                              text: "Current\n",
                              children: [
                                WidgetSpan(
                                    child: Icon(
                                      Icons.cloudy_snowing,
                                      size: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .fontSize,
                                    ),
                                    alignment: PlaceholderAlignment.middle),
                                TextSpan(
                                    text:
                                        "\n${weatherInformation.snowInformation!.oneHour}mm")
                              ],
                            ),
                          if (weatherInformation.snowInformation?.threeHour !=
                              null)
                            TextSpan(
                              style: Theme.of(context).textTheme.bodyLarge,
                              text: "Within 3h\n",
                              children: [
                                WidgetSpan(
                                    child: Icon(
                                      Icons.snowing,
                                      size: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .fontSize,
                                    ),
                                    alignment: PlaceholderAlignment.middle),
                                TextSpan(
                                    text:
                                        "\n${weatherInformation.snowInformation!.threeHour}mm")
                              ],
                            ),
                        },
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 16.0),
                        padding: const EdgeInsets.symmetric(horizontal: 64.0),
                        child: ElevatedButton.icon(
                          label: const Text("About"),
                          onPressed: () {
                            Navigator.pushNamed(context, AboutView.ROUTENAME);
                          },
                          icon: const Icon(Icons.help_center_rounded),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
