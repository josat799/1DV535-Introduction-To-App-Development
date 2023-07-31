import 'package:flutter/material.dart';

class AboutView extends StatelessWidget {
  static const ROUTENAME = '/about';
  AboutView({super.key});

  void showLicensePage({
    required BuildContext context,
    String? applicationName,
    String? applicationVersion,
    Widget? applicationIcon,
    String? applicationLegalese,
    bool useRootNavigator = false,
  }) {
    Navigator.of(context, rootNavigator: useRootNavigator)
        .push(MaterialPageRoute<void>(
      builder: (BuildContext context) => LicensePage(
        applicationName: applicationName,
        applicationVersion: applicationVersion,
        applicationIcon: applicationIcon,
        applicationLegalese: applicationLegalese,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("About"),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
        child: RichText(
          softWrap: true,
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "Weather Me Up!\n\n",
            style: Theme.of(context).textTheme.headlineLarge,
            children: [
              TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                text:
                    "Weather Me Up is developed as an exercise according to the course 1DV535 given at Linneus University.",
                children: const [
                  TextSpan(
                      text:
                          "The App showcases the current weather and 40 predicted weather points with a 3 hours interval. All data used in the app is computed at OpenWeatherMap.org."),
                ],
              ),
              TextSpan(
                  text: "\n\nDeveloped by Josef Atoui\n",
                  style: Theme.of(context).textTheme.headlineSmall),
              WidgetSpan(
                  child: TextButton(
                onPressed: () => {
                  showLicensePage(
                      context: context,
                      applicationName: "Weather Me Up!",
                      applicationVersion: "1.0.0",
                      useRootNavigator: true),
                },
                child: const Text("Show Licences"),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
