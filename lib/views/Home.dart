import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sunisup/models/all_weather.dart';
import 'package:sunisup/models/meteo.dart';
import 'package:sunisup/services/MeteoService.dart';
import 'package:sunisup/widgets/MeteoPanelList.dart';
import 'package:sunisup/widgets/Modal.dart';
import 'package:sunisup/widgets/WeatherPanel.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> { /* Snapshot intégré qui permet de faire un effet de chargement de page à l'ouverture de l'application, avant de lister toutes les villes fichées dans la DB */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          centerTitle: true,
          title: Text(widget.title),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset('assets/icons/sunIsUp_white.png',
                fit: BoxFit.cover),
          )),
      body: FutureBuilder<List<All_weather>>(
          future: getAllMeteoInDatabase(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Text("Chargement en cours ... "));
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data!.isNotEmpty) {
                return MeteoPanelList(weathers: snapshot.data!);
              }
              return const Center(
                  child: Text("Vous n'avez actuellement pas de ville"));
            } else {
              return const Center(child: Text("Une erreur est survenue"));
            }
          }),
      floatingActionButton: Modal(),
    );
  }
}
