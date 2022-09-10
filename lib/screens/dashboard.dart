import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:pie_chart/pie_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var stream1 = FirebaseFirestore.instance
      .collection("${FirebaseAuth.instance.currentUser!.email}")
      .doc("Income")
      .collection("income-data")
      .snapshots();

  var stream2 = FirebaseFirestore.instance
      .collection("${FirebaseAuth.instance.currentUser!.email}")
      .doc("Outcome")
      .collection("outcome-data")
      .snapshots();

  var stream3 = FirebaseFirestore.instance
      .collection("${FirebaseAuth.instance.currentUser!.email}")
      .doc("Saving")
      .collection('saving-data')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: StreamBuilder3<QuerySnapshot, QuerySnapshot, QuerySnapshot>(
        streams: StreamTuple3(stream1, stream2, stream3),
        builder: (context, snapshots) {
          int incomeTotal = 0;
          int outcomeTotal = 0;
          int savingTotal = 0;
          if (snapshots.snapshot1.hasError) {
            return Text('Error: ${snapshots.snapshot1.error}');
          } else if (snapshots.snapshot2.hasError) {
            return Text('Error: ${snapshots.snapshot2.error}');
          } else if (snapshots.snapshot3.hasError) {
            return Text('Error: ${snapshots.snapshot3.error}');
          }
          if (snapshots.snapshot1.connectionState ==
              "ConnectionState.waiting") {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshots.snapshot2.connectionState ==
              "ConnectionState.waiting") {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshots.snapshot3.connectionState ==
              "ConnectionState.waiting") {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshots.snapshot1.hasData) {
            // var incomeData = snapshots.snapshot1.data!.docs;
            for (var data in snapshots.snapshot1.data!.docs) {
              var incomeField = data;
              int amount = incomeField['amount'];
              incomeTotal = incomeTotal + amount;
            }
          }
          if (snapshots.snapshot2.hasData) {
            // var incomeData = snapshots.snapshot1.data!.docs;
            for (var data in snapshots.snapshot2.data!.docs) {
              var outcomeField = data;
              int amount = outcomeField['amount'];
              outcomeTotal = outcomeTotal + amount;
            }
          }
          if (snapshots.snapshot3.hasData) {
            for (var data in snapshots.snapshot3.data!.docs) {
              var savingField = data;
              int addPrice = savingField['addPrice'];
              savingTotal = savingTotal + addPrice;
            }
          }
          return DashboardUi(
              Income: incomeTotal, Outcome: outcomeTotal, Saving: savingTotal);
        },
      ),
    );
  }
}

class DashboardUi extends StatefulWidget {
  int Income;
  int Outcome;
  int Saving;
  DashboardUi({
    Key? key,
    required this.Income,
    required this.Outcome,
    required this.Saving,
  }) : super(key: key);

  @override
  State<DashboardUi> createState() => _DashboardUiState();
}

class _DashboardUiState extends State<DashboardUi> {
  String displayName = "";
  Future getDisplayName() async {
    final prefs = await SharedPreferences.getInstance();
    final String? name = prefs.getString('displayName');
    // print(">> ${action}");
    setState(() {
      displayName = name!;
    });
  }

  @override
  void initState() {
    getDisplayName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: (displayName == "")
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 90,
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          elevation: 0.0,
                          // color: Colors.grey[800],
                          color: Colors.blue[700],

                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  displayName,
                                  style: TextStyle(
                                      color: Colors.grey[200],
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "${widget.Income - (widget.Outcome + widget.Saving)}",
                                  style: TextStyle(
                                      color: Colors.grey[100],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      // Text("Income - ${widget.Income}"),
                      // Text("Outcome - ${widget.Outcome}"),
                      // Text("Saving - ${widget.Saving}"),

                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        child: Card(
                          elevation: 3,
                          child: (widget.Income == 0 &&
                                  widget.Outcome == 0 &&
                                  widget.Saving == 0)
                              ? Center(
                                  child: Text(
                                    "No Data",
                                    style: TextStyle(
                                        color: Colors.grey[700],
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: SfCircularChart(
                                    legend: Legend(
                                        isVisible: true,
                                        position: LegendPosition.bottom),
                                    tooltipBehavior:
                                        TooltipBehavior(enable: true),
                                    series: <CircularSeries>[
                                      PieSeries<IOData, String>(
                                          dataSource: [
                                            IOData("Income", widget.Income),
                                            IOData("Outcome", widget.Outcome),
                                            IOData("Saving", widget.Saving)
                                          ],
                                          xValueMapper: (IOData data, _) =>
                                              data.iotype,
                                          yValueMapper: (IOData data, _) =>
                                              data.iovalue,
                                          dataLabelSettings:
                                              const DataLabelSettings(
                                                  isVisible: true,
                                                  showZeroValue: true,
                                                  overflowMode:
                                                      OverflowMode.trim,
                                                  showCumulativeValues: true,
                                                  labelPosition:
                                                      ChartDataLabelPosition
                                                          .outside),
                                          enableTooltip: true,
                                          animationDuration: 800)
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class IOData {
  IOData(this.iotype, this.iovalue);
  final String iotype;
  final int iovalue;
}
