import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_me_up/views/home_view.dart';

class LocatorError extends StatefulWidget {
  static const String ROUTENAME = "/error";
  final LocationPermission previousPermission;

  const LocatorError({super.key, required this.previousPermission});

  @override
  State<LocatorError> createState() => _LocatorErrorState();
}

class _LocatorErrorState extends State<LocatorError> {
  bool settingsHaveBeenOpened = false;
  late LocationPermission permission;

  @override
  void initState() {
    permission = widget.previousPermission;
    super.initState();
  }

  void checkPermission() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacementNamed(HomeView.ROUTENAME);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: "This app requires your position to work!",
            children: [
              const TextSpan(text: "\n"),
              TextSpan(
                  text: permission == LocationPermission.deniedForever
                      ? "Please open your settings to grant access for the app!"
                      : ""),
              WidgetSpan(
                child: ElevatedButton.icon(
                  onPressed: () => Geolocator.openAppSettings(),
                  icon: const Icon(Icons.open_in_new_outlined),
                  label: const Text("Open Settings"),
                ),
              ),
              WidgetSpan(
                child: ElevatedButton.icon(
                  onPressed: () => Geolocator.requestPermission().then((value) {
                    setState(() {
                      permission = value;
                    });
                    checkPermission();
                  }),
                  icon: const Icon(Icons.perm_device_information_outlined),
                  label: const Text("Request again!"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
