mixin EndPoints {
  final String _BASEURL = "openweathermap.org";
  String get BASEAPIURL => "api.$_BASEURL";
  String get BASEURL => _BASEURL;
  final String WEATHER = "/data/2.5/weather";
  final String FORECAST = "/data/2.5/forecast";
  final String IMAGEICON = "/img/wn";
}
