# Assignment_3

A Weather App!

## HOW TO RUN IN DEVELOPMENT MODE

The app is designed to use OpenWeather´s API. Therefore, you need to signup to https://openweathermap.org/ to retrive your key. 

To run this application you need to setup an environment. 
It can either be done using api_keys.json file or directly in Flutter Cli.

### api_keys.json File

```json
{
    "WEATHER_API_KEY": "<Your API Key>"
}

```

```
flutter run --dart-define-from-file=api_keys.json

```

### Directly in Flutter Cli

```
flutter run --dart-define WEATHER_API_KEY=<Your API Key>
```
