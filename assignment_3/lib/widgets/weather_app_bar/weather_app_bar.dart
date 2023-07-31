import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:weather_me_up/models/weather_information.dart';
import 'package:weather_me_up/widgets/weather_app_bar/extended_header_widget.dart';

// ignore: must_be_immutable
class WeatherAppBar extends SliverAppBar {
  final WeatherInformation weatherInformation;
  final DateTime lastfetched;
  final double opacity;
  final TextTheme textTheme;

  final List<Widget> actions = [];
  final Widget title;
  final Color backgroundColor;
  final double toolbarHeight = 120;
  final double expandedHeight = 300;
  final bool automaticallyImplyLeading = false;
  final bool pinned = true;
  final bool primary = true;
  @override
  Widget? flexibleSpace;

  WeatherAppBar({
    required this.lastfetched,
    required this.weatherInformation,
    required this.textTheme,
    required this.opacity,
    required this.title,
    required this.backgroundColor,
    super.key,
  }) {
    flexibleSpace = ExpandedHeader(
      temperatures: weatherInformation.temperatures,
      iconUrl: weatherInformation.iconUrl,
    );
    actions.addAll(
      [
        AnimatedOpacity(
          opacity: opacity,
          duration: const Duration(milliseconds: 1000),
          child: FadeInImage.memoryNetwork(
            imageScale: 4,
            placeholder: kTransparentImage,
            image: weatherInformation.iconUrl.toString(),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          margin: const EdgeInsets.only(right: 16.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                    child: Icon(
                      Icons.sync_outlined,
                      color: Colors.white,
                      size: textTheme.labelSmall!.fontSize,
                    ),
                    alignment: PlaceholderAlignment.middle),
                TextSpan(
                  text: DateFormat.Hm().format(lastfetched),
                  style: textTheme.labelSmall,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
