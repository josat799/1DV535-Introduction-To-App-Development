import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:weather_me_up/models/weather_content.dart';
import 'package:weather_me_up/views/about_view.dart';
import 'package:weather_me_up/views/forecast_view.dart';
import 'package:weather_me_up/views/home_view.dart';
import 'package:weather_me_up/views/locator_error_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const weatherApiKey = String.fromEnvironment('WEATHER_API_KEY');
  if (weatherApiKey.isEmpty) {
    throw AssertionError('Unable to load environment keys');
  }

  bool isLocatorServiceEnabled = await Geolocator.isLocationServiceEnabled();
  int attemptsToGetPermission = 2;

  LocationPermission permission = LocationPermission.unableToDetermine;
  if (isLocatorServiceEnabled) {
    permission = await Geolocator.checkPermission();
    for (var i = 1; i <= attemptsToGetPermission; i++) {
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      } else {
        break;
      }
    }
  }
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(
    ChangeNotifierProvider(
      create: (context) => WeatherContent(),
      child: MaterialApp(
        onGenerateRoute: (settings) {
          Widget Function(BuildContext, Animation<double>, Animation<double>)
              pageBuilder;
          switch (settings.name) {
            case HomeView.ROUTENAME:
              pageBuilder =
                  (_, __, ___) => const HomeView(apiKey: weatherApiKey);
              break;
            case AboutView.ROUTENAME:
              pageBuilder = (_, __, ___) => AboutView();
              break;
            case LocatorError.ROUTENAME:
              pageBuilder =
                  (_, __, ___) => LocatorError(previousPermission: permission);
              break;
            case ForecastView.ROUTENAME:
              pageBuilder = (_, __, ___) => const ForecastView();
              break;
            default:
              pageBuilder =
                  (_, __, ___) => LocatorError(previousPermission: permission);
              break;
          }
          return PageRouteBuilder(
            pageBuilder: pageBuilder,
            transitionDuration: const Duration(milliseconds: 500),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1, 0);
              const end = Offset.zero;
              final tween = Tween(begin: begin, end: end);
              final offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
          );
        },
        // routes: {
        //   HomeView.ROUTENAME: (context) => const HomeView(
        //         apiKey: weatherApiKey,
        //       ),
        //   ForecastView.ROUTENAME: (context) => const ForecastView(),
        //   AboutView.ROUTENAME: (context) => AboutView(),
        //   LocatorError.ROUTENAME: (context) =>
        //       LocatorError(previousPermission: permission),
        // },
        initialRoute: permission == LocationPermission.whileInUse ||
                permission == LocationPermission.always
            ? HomeView.ROUTENAME
            : LocatorError.ROUTENAME,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blueGrey, brightness: Brightness.dark),
          useMaterial3: true,
          elevatedButtonTheme: const ElevatedButtonThemeData(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(Colors.transparent))),
          textTheme: const TextTheme()
              .apply(displayColor: Colors.white, bodyColor: Colors.white),
          cardTheme: const CardTheme(
              color: Colors.transparent,
              margin: EdgeInsets.symmetric(horizontal: 32.0)),
        ),
      ),
    ),
  );
}
