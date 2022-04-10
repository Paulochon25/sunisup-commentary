import 'package:sunisup/models/forecast_weather.dart';
import 'package:sunisup/models/meteo.dart';
import './City.dart';

class All_weather { /* Permet à l'aide des fichier forecast et meteo de récupérer les données sur le temps d'une ville */
  final Meteo meteo;
  final ForecastWeather forecastWeather;
  final City city;
  All_weather(this.city, this.meteo, this.forecastWeather);
}
