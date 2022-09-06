import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/screens/saving_money_adding.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../model/firebaseservice.dart';

class Security extends StatefulWidget {
  const Security({Key? key}) : super(key: key);
  @override
  State<Security> createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Security"),
        elevation: 0.0,
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
