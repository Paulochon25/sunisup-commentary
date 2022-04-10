import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import '../db/City.dart';

class DatePanel extends StatefulWidget { /* Permet d'afficher un panel où est renseignée l'heure */
  const DatePanel({Key? key, required this.date}) : super(key: key);

  final DateTime date;

  @override
  _DatePanelState createState() {
    return _DatePanelState();
  }
}

class _DatePanelState extends State<DatePanel> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(DateFormat('EEEE').format(widget.date)),
      Text(DateFormat('MMMM dd, yyyy').format(widget.date))
    ], crossAxisAlignment: CrossAxisAlignment.start);
  }


}
