import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/model/firebaseGet.dart';
import 'package:finance/components/catego_detail.dart';
import 'package:finance/screens/addValue.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

import '../model/firebaseservice.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  CollectionReference user = firestore.collection('${currentuser!.email}');

  // ignore: non_constant_identifier_names
  double investTotal = 0;
  double salaryTotal = 0;
  double uncategoTotal = 0;
  Future<List<dynamic>>? invest;
  Future<List<dynamic>>? salary;
  Future<List<dynamic>>? uncatego;

  investcalculate() async {
    invest = incomecategovalue('Investment');
    await invest!.then((value) {
      for (var i = 0; i < value.length; i++) {
        setState(() {
          investTotal += value[i];
        });
      }
    });
  }

  salarycalculate() async {
    salary = incomecategovalue('Salary');
    await salary!.then((value) {
      for (var i = 0; i < value.length; i++) {
        setState(() {
          salaryTotal += value[i];
        });
      }
    });
  }

  uncategocalculate() async {
    uncatego = incomecategovalue('Uncategorized');
    await uncatego!.then((value) {
      for (var i = 0; i < value.length; i++) {
        setState(() {
          uncategoTotal += value[i];
        });
      }
    });
  }

  List<IncomeData> _IncomeChart = [];

  @override
  void initState() {
    investcalculate();
    salarycalculate();
    uncategocalculate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 250, 255),
      appBar: AppBar(title: const Text('Income')),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width - 30,
              height: MediaQuery.of(context).size.height * 0.4,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: SfCircularChart(
                    legend: Legend(
                        isVisible: true, position: LegendPosition.bottom),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <CircularSeries>[
                      PieSeries<IncomeData, String>(
                        // dataSource: _IncomeChart,
                        dataSource: [
                          IncomeData("Salary", salaryTotal.toInt()),
                          IncomeData("Investment", investTotal.toInt()),
                          IncomeData("Uncategorized", uncategoTotal.toInt())
                        ],
                        xValueMapper: (IncomeData data, _) => data.IncomeType,
                        yValueMapper: (IncomeData data, _) => data.IncomeValue,
                        dataLabelSettings: const DataLabelSettings(
                            isVisible: true,
                            showZeroValue: true,
                            overflowMode: OverflowMode.trim,
                            showCumulativeValues: true,
                            labelPosition: ChartDataLabelPosition.outside),
                        enableTooltip: true,
                      )
                    ],
                  ),
                ),
              ),
            ),
            CategoDetail(
              userstream: incomeStream,
            ),
          ],
        ),
      )),
    );
  }
}

class IncomeData {
  String IncomeType;
  int IncomeValue;
  IncomeData(this.IncomeType, this.IncomeValue);
}
