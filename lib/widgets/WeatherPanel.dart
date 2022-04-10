import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:sunisup/models/forecast_weather.dart';
import 'package:sunisup/models/meteo.dart';
import 'package:sunisup/widgets/DatePanel.dart';
import 'package:sunisup/widgets/MeteoPanel.dart';
import '../db/City.dart';
import '../models/City.dart';
import '../views/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WeatherPanel extends StatefulWidget { /* Ce fichier permet de build à l'aide des sharedPreferences la page de l'application avec les données qui lui sont disponibles. */
  const WeatherPanel(
      {Key? key,
      required this.city,
      required this.meteo,
      required this.forecastWeather})
      : super(key: key);
  final City city;
  final Meteo meteo;
  final ForecastWeather forecastWeather;

  @override
  _WeatherPanelState createState() {
    return _WeatherPanelState();
  }
}

class _WeatherPanelState extends State<WeatherPanel> {
  bool _expanded = false;
  bool isFirstLoad = true;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
        future: GetScrollStates(),
        builder: (context, snapshot) {
          if (snapshot.data?.getBool("${widget.city.Id_city}") != null &&
              isFirstLoad) {
            _expanded = snapshot.data!.getBool("${widget.city.Id_city}")!;
            isFirstLoad = false;
          }

          return Container(
              margin: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: ExpansionPanelList(
                  animationDuration: const Duration(milliseconds: 200),
                  children: [
                    ExpansionPanel(
                      headerBuilder: (context, isExpanded) {
                        return ListTile(
                          title: Row(
                            children: [
                              Column(children: [
                                Row(
                                  children: [
                                    Row(children: [
                                      Text("${widget.city.Libelle}",
                                          style: const TextStyle(fontSize: 30)),
                                      Image.network(widget.meteo.icon),
                                    ]),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      tooltip: '',
                                      onPressed: () {
                                        DeleteCity(widget.city.Id_city ?? 0);
                                      },
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DatePanel(date: DateTime.now()),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: MeteoPanel(
                                      temp: "${widget.meteo.main!.temp}",
                                      humidity:
                                          "${widget.meteo.main!.humidity}",
                                      deg: "${widget.meteo.wind!.deg}"),
                                ),
                              ])
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        );
                      },
                      body: ListTile(
                          title: Column(children: [
                        ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: widget.forecastWeather.list!.length,
                            itemBuilder: (context, i) {
                              return Row(
                                children: [
                                  DatePanel(
                                      date: DateTime.parse(widget
                                              .forecastWeather.list![i].dtTxt ??
                                          '')),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Image.network(
                                        widget.forecastWeather.list![i].icon),
                                  ),
                                  Text(
                                    "${widget.forecastWeather.list![i].main!.temp}°",
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ],
                                crossAxisAlignment: CrossAxisAlignment.center,
                              );
                            })
                      ])),
                      isExpanded: _expanded,
                      canTapOnHeader: true,
                    ),
                  ],
                  expansionCallback: (panelIndex, isExpanded) {
                    setState(() {
                      snapshot.data!
                          .setBool("${widget.city.Id_city}", !_expanded);
                      _expanded = !_expanded;
                    });
                  },
                ),
              ));
        });
  }

  Future DeleteCity(id) async {
    await CityDatabase.instance.DeleteCity(id);
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const Home(title: "SunIsUp")),
    );
  }

  Future<SharedPreferences> GetScrollStates() async {
    return await SharedPreferences.getInstance();
  }
}
