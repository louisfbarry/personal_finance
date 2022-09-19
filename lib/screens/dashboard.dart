import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/model/firebaseservice.dart';
import 'package:finance/screens/saving.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:intl/intl.dart';

import 'incomecatego_detail.dart';
import 'outcomecatego_detail.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  var stream4 = FirebaseFirestore.instance
      .collection('${FirebaseAuth.instance.currentUser!.email}')
      .doc('Income-catego')
      .collection('data')
      .snapshots();

  var stream5 = FirebaseFirestore.instance
      .collection('${FirebaseAuth.instance.currentUser!.email}')
      .doc('Outcome-catego')
      .collection('data')
      .snapshots();

  @override
  void initState() {
    API().addCollection();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: StreamBuilder5<QuerySnapshot, QuerySnapshot, QuerySnapshot,
              QuerySnapshot, QuerySnapshot>(
          streams: StreamTuple5(stream1, stream2, stream3, stream4, stream5),
          builder: (BuildContext context,
              SnapshotTuple5<
                      QuerySnapshot<Object?>,
                      QuerySnapshot<Object?>,
                      QuerySnapshot<Object?>,
                      QuerySnapshot<Object?>,
                      QuerySnapshot<Object?>>
                  snapshots) {
            int incomeTotal = 0;
            int outcomeTotal = 0;
            int savingTotal = 0;
            int incomecategototal = 0;
            int outcomecategototal = 0;
            int amount = 0;
            int outcomeamount = 0;
            if (snapshots.snapshot1.hasError) {
              return Text('Error: ${snapshots.snapshot1.error}');
            } else if (snapshots.snapshot2.hasError) {
              return Text('Error: ${snapshots.snapshot2.error}');
            } else if (snapshots.snapshot3.hasError) {
              return Text('Error: ${snapshots.snapshot3.error}');
            } else if (snapshots.snapshot4.hasError) {
              return Text('Error: ${snapshots.snapshot3.error}');
            } else if (snapshots.snapshot5.hasError) {
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
            if (snapshots.snapshot4.connectionState ==
                "ConnectionState.waiting") {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshots.snapshot5.connectionState ==
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

            if (snapshots.snapshot4.hasData) {
              choices = [];
              incomecategototal = 0;
              for (var element in snapshots.snapshot4.data!.docs) {
                var incomecategodata = element.data() as Map<String, dynamic>;
                if (snapshots.snapshot1.hasData) {
                  for (var data in snapshots.snapshot1.data!.docs) {
                    if (data['category'] == incomecategodata['categoname']) {
                      amount = data['amount'];
                      incomecategototal += amount;
                    }
                  }
                }
                choices.add(Choice(
                    title: incomecategodata['categoname'],
                    imgname: incomecategodata['imagId'],
                    amount: incomecategototal));
                incomecategototal = 0;
              }
            }

            if (snapshots.snapshot5.hasData) {
              outcomechoices = [];
              outcomecategototal = 0;
              for (var element in snapshots.snapshot5.data!.docs) {
                var outcomecategodata = element.data() as Map<String, dynamic>;
                if (snapshots.snapshot2.hasData) {
                  for (var data in snapshots.snapshot2.data!.docs) {
                    if (data['category'] == outcomecategodata['categoname']) {
                      outcomeamount = data['amount'];
                      outcomecategototal += outcomeamount;
                    }
                  }
                }
                outcomechoices.add(Choice(
                    title: outcomecategodata['categoname'],
                    imgname: outcomecategodata['imagId'],
                    amount: outcomecategototal));
                outcomecategototal = 0;
              }
              return DashboardUi(
                income: incomeTotal,
                outcome: outcomeTotal,
                saving: savingTotal,
                incomeVs: incomeTotal - (outcomeTotal + savingTotal),
                allTotal: incomeTotal + outcomeTotal + savingTotal,
              );
            }

            // return const Center(child: CircularProgressIndicator());
            // #edit
            return Center(child: Container());
          }),
    );
  }
}

class DashboardUi extends StatefulWidget {
  int income;
  int outcome;
  int saving;
  int incomeVs;
  int allTotal;
  DashboardUi(
      {Key? key,
      required this.income,
      required this.outcome,
      required this.saving,
      required this.incomeVs,
      required this.allTotal})
      : super(key: key);

  @override
  State<DashboardUi> createState() => _DashboardUiState();
}

class _DashboardUiState extends State<DashboardUi> {
  String displayName = "";

  int selectedChart = 1;
  // bool choose = true;
  final PageController pagecontroller = PageController();
  int pageindex = 0;

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
      // backgroundColor: Colors.transparent,
      backgroundColor: Colors.grey[100],
      body: (displayName == "")
          ? Center(
              // child: CircularProgressIndicator(),
              child: Container(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          Container(
                              color: Colors.grey[100],
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(13.0),
                                    bottomRight: Radius.circular(13.0),
                                  ),
                                  child: Image.asset(
                                    'images/gradient.png',
                                    width: double.infinity,
                                    height: 230,
                                    fit: BoxFit.cover,
                                  ))),
                          Positioned(
                            top: 30,
                            left: 30,
                            child: Text(
                              AppLocalizations.of(context)!.totalBalance,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                          Positioned(
                            top: 30,
                            right: 30,
                            child: (widget.incomeVs < 0)
                                ? Text(
                                    "${NumberFormat.decimalPattern().format(widget.incomeVs)} MMK",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        // color: Colors.red[300]
                                        color: Colors.deepOrangeAccent[100]),
                                  )
                                : Text(
                                    "${NumberFormat.decimalPattern().format(widget.incomeVs)} MMK",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                          ),
                          Positioned(
                            bottom: -120,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width - 20,
                                height: 280,
                                child: Card(
                                  // color: Colors.grey[100],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  elevation: 3,
                                  child: (widget.income == 0 &&
                                          widget.outcome == 0 &&
                                          widget.saving == 0)
                                      ? Center(
                                          child: Text(
                                            "No Data",
                                            style: TextStyle(
                                                color: Colors.grey[700],
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                    flex: 1,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                    setState(() {
                                                      selectedChart = 1;
                                                    });
                                                  },
                                                      child: Row(
                                                        children: [
                                                          Transform.scale(
                                                            scale: 0.8,
                                                            child: Radio(
                                                                value: 1,
                                                                groupValue:
                                                                    selectedChart,
                                                                onChanged:
                                                                    (value) =>
                                                                        setState(
                                                                            () {
                                                                          selectedChart =
                                                                              1;
                                                                        })),
                                                          ),
                                                          const Expanded(
                                                              child: Text(
                                                            "Pie Chart",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ))
                                                        ],
                                                      ),
                                                    )),
                                                Expanded(
                                                    flex: 1,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                    setState(() {
                                                      selectedChart = 2;
                                                    });
                                                  },
                                                      child: Row(
                                                        children: [
                                                          Transform.scale(
                                                            scale: 0.8,
                                                            child: Radio(
                                                                value: 2,
                                                                groupValue:
                                                                    selectedChart,
                                                                onChanged:
                                                                    (value) =>
                                                                        setState(
                                                                            () {
                                                                          selectedChart =
                                                                              2;
                                                                        })),
                                                          ),
                                                          const Expanded(
                                                              child: Text(
                                                            "Column Chart",
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ))
                                                        ],
                                                      ),
                                                    ))
                                              ],
                                            ),
                                            (selectedChart == 1)
                                                ? SizedBox(
                                                    height: 200,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: SfCircularChart(
                                                        legend: Legend(
                                                            isVisible: true,
                                                            position:
                                                                LegendPosition
                                                                    .bottom),
                                                        tooltipBehavior:
                                                            TooltipBehavior(
                                                                enable: true),
                                                        // series: <CircularSeries>[
                                                        //   PieSeries<IOData, String>(
                                                        //     dataSource: [
                                                        //       IOData("income",
                                                        //           widget.income
                                                        //           ),
                                                        //       IOData("outcome",
                                                        //           widget.outcome),
                                                        //       IOData("saving",
                                                        //           widget.saving)
                                                        //     ],

                                                        //     xValueMapper:
                                                        //         (IOData data, _) =>
                                                        //             data.iotype,
                                                        //     yValueMapper:
                                                        //         (IOData data, _) =>
                                                        //             data.iovalue,
                                                        //     dataLabelSettings:
                                                        //         const DataLabelSettings(
                                                        //             isVisible: true,
                                                        //             showZeroValue: true,
                                                        //             overflowMode:
                                                        //                 OverflowMode
                                                        //                     .trim,
                                                        //             showCumulativeValues:
                                                        //                 true,
                                                        //             labelPosition:
                                                        //                 ChartDataLabelPosition
                                                        //                     .outside),
                                                        //     enableTooltip: true,
                                                        //   )
                                                        // ],
                                                        series: <
                                                            CircularSeries>[
                                                          PieSeries<IOData,
                                                              String>(
                                                            dataSource: [
                                                              IOData(
                                                                  AppLocalizations.of(
                                                                          context)!
                                                                      .income,
                                                                  double.parse(
                                                                      ((widget.income / widget.allTotal) *
                                                                              100)
                                                                          .toStringAsFixed(
                                                                              2)),
                                                                  "${double.parse(((widget.income / widget.allTotal) * 100).toStringAsFixed(2))}%"),
                                                              IOData(
                                                                  AppLocalizations.of(
                                                                          context)!
                                                                      .outcome,
                                                                  double.parse(
                                                                      ((widget.outcome / widget.allTotal) *
                                                                              100)
                                                                          .toStringAsFixed(
                                                                              2)),
                                                                  "${double.parse(((widget.outcome / widget.allTotal) * 100).toStringAsFixed(2))}%"),
                                                              IOData(
                                                                  AppLocalizations.of(
                                                                          context)!
                                                                      .saving,
                                                                  double.parse(
                                                                      ((widget.saving / widget.allTotal) *
                                                                              100)
                                                                          .toStringAsFixed(
                                                                              2)),
                                                                  "${double.parse(((widget.saving / widget.allTotal) * 100).toStringAsFixed(2))}%")
                                                            ],
                                                            xValueMapper:
                                                                (IOData data,
                                                                        _) =>
                                                                    data.iotype,
                                                            yValueMapper:
                                                                (IOData data,
                                                                        _) =>
                                                                    data.iovalue,
                                                            dataLabelMapper:
                                                                (IOData data,
                                                                        _) =>
                                                                    data.iolabel,
                                                            dataLabelSettings:
                                                                const DataLabelSettings(
                                                              isVisible: true,
                                                              showZeroValue:
                                                                  true,
                                                              // overflowMode:
                                                              //     OverflowMode
                                                              //         .trim,
                                                              overflowMode:
                                                                  OverflowMode
                                                                      .shift,
                                                              showCumulativeValues:
                                                                  true,
                                                              // labelPosition:
                                                              //     ChartDataLabelPosition
                                                              //         .outside
                                                            ),
                                                            enableTooltip: true,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox(
                                                    height: 200,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: SfCartesianChart(
                                                        tooltipBehavior:
                                                            TooltipBehavior(
                                                                enable: true),
                                                        series: <ChartSeries>[
                                                          ColumnSeries<IOCData,
                                                              String>(
                                                            color: Colors.teal,
                                                            dataSource: [
                                                              IOCData(
                                                                  AppLocalizations.of(
                                                                          context)!
                                                                      .income,
                                                                  widget.income,
                                                                  NumberFormat
                                                                          .decimalPattern()
                                                                      .format(widget
                                                                          .income)),
                                                              IOCData(
                                                                  AppLocalizations.of(
                                                                          context)!
                                                                      .outcome,
                                                                  widget
                                                                      .outcome,
                                                                  NumberFormat
                                                                          .decimalPattern()
                                                                      .format(widget
                                                                          .outcome)),
                                                              IOCData(
                                                                  AppLocalizations.of(
                                                                          context)!
                                                                      .saving,
                                                                  widget.saving,
                                                                  NumberFormat
                                                                          .decimalPattern()
                                                                      .format(widget
                                                                          .saving))
                                                            ],
                                                            name: "data",
                                                            xValueMapper:
                                                                (IOCData data,
                                                                        _) =>
                                                                    data.iotype,
                                                            yValueMapper:
                                                                (IOCData data,
                                                                        _) =>
                                                                    data.iovalue,
                                                            dataLabelMapper:
                                                                (IOCData data,
                                                                        _) =>
                                                                    data.iolabel,
                                                            enableTooltip: true,
                                                            dataLabelSettings:
                                                                const DataLabelSettings(
                                                                    isVisible:
                                                                        true,
                                                                    labelAlignment:
                                                                        ChartDataLabelAlignment
                                                                            .outer),
                                                          ),
                                                        ],
                                                        primaryXAxis:
                                                            CategoryAxis(),
                                                      ),
                                                    ),
                                                  ),
                                            // : Text("hi")
                                          ],
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ]),
                    const SizedBox(
                      height: 130,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 180,
                      color: Colors.white,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      child: Text(
                                        AppLocalizations.of(context)!.income,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[800]),
                                      ),
                                    ),
                                    Text(
                                      NumberFormat.decimalPattern()
                                          .format(widget.income),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          // color: Colors.white
                                          color: Colors.grey[800]),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.outcome,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            // color: Colors.white
                                            color: Colors.grey[800]),
                                      ),
                                      Text(
                                        NumberFormat.decimalPattern()
                                            .format(widget.outcome),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            // color: Colors.white
                                            color: Colors.grey[800]),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!.saving,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            // color: Colors.grey[830],
                                            // color: Colors.white
                                            color: Colors.grey[800]),
                                      ),
                                      Text(
                                        NumberFormat.decimalPattern()
                                            .format(widget.saving),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            // color: Colors.grey[830]
                                            // color: Colors.white
                                            color: Colors.grey[800]),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .totalBalance,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            // color: Colors.white
                                            color: Colors.grey[800]),
                                      ),
                                      (widget.incomeVs < 0)
                                          ? Text(
                                              NumberFormat.decimalPattern()
                                                  .format(widget.incomeVs),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.red),
                                            )
                                          : Text(
                                              NumberFormat.decimalPattern()
                                                  .format(widget.incomeVs),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  // color: Colors.white
                                                  color: Colors.grey[800]),
                                            ),
                                    ],
                                  ),
                                ),
                              ]),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 20,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    pageindex = 0;
                                  });
                                  // print(pageindex);
                                  pagecontroller.animateToPage(0,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeInOut);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: pageindex == 0
                                        ? Colors.blue[700]
                                        : Colors.white,
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.31,
                                  height: 30,
                                  child: Center(
                                    child: Text(
                                      'Income',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: pageindex == 0
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )),
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    pageindex = 1;
                                  });
                                  // print(pageindex);
                                  pagecontroller.animateToPage(1,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeInOut);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: pageindex == 1
                                        ? Colors.blue[700]
                                        : Colors.white,
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width * 0.31,
                                  height: 30,
                                  child: Center(
                                    child: Text(
                                      'Expenses',
                                      style: TextStyle(
                                          fontSize: 13,
                                          color: pageindex == 1
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                )),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  pageindex = 2;
                                });
                                // print(pageindex);
                                pagecontroller.animateToPage(2,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeInOut);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: pageindex == 2
                                      ? Colors.blue[700]
                                      : Colors.white,
                                ),
                                width: MediaQuery.of(context).size.width * 0.31,
                                height: 30,
                                child: Center(
                                  child: Text(
                                    'Saving',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: pageindex == 2
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            )
                          ]),
                    ),
                    Container(
                      color: Colors.grey[100],
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: PageView(
                        controller: pagecontroller,
                        onPageChanged: (int page) {
                          setState(() {
                            pageindex = page;
                          });
                          print('$page>>>>>');
                        },
                        children: [
                          Container(
                              color: Colors.grey[100],
                              width: (MediaQuery.of(context).size.width),
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: GridView.count(
                                  crossAxisCount: 3,
                                  primary: false,
                                  children:
                                      List.generate(choices.length, (index) {
                                    return Center(
                                      child: SelectCard(
                                        choice: choices[index],
                                        choose: true,
                                      ),
                                    );
                                  }))),
                          Container(
                              color: Colors.grey[100],
                              width: (MediaQuery.of(context).size.width),
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: GridView.count(
                                  crossAxisCount: 3,
                                  primary: false,
                                  children: List.generate(outcomechoices.length,
                                      (index) {
                                    return Center(
                                      child: SelectCard(
                                        choice: outcomechoices[index],
                                        choose: false,
                                      ),
                                    );
                                  }))),
                          SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: const Saving())
                          // Saving()
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

class IOData {
  IOData(this.iotype, this.iovalue, this.iolabel);
  // final String iotype;
  final String iotype;
  // final int iovalue;
  final double iovalue;
  final String iolabel;
}

class IOCData {
  IOCData(this.iotype, this.iovalue, this.iolabel);
  final String iotype;
  final int iovalue;
  final String iolabel;
}

class Choice {
  const Choice({
    required this.title,
    required this.imgname,
    required this.amount,
  });
  final String title;
  final String imgname;
  final int amount;
}

List<Choice> choices = [];
List<Choice> outcomechoices = [];

class SelectCard extends StatelessWidget {
  const SelectCard({Key? key, required this.choice, required this.choose})
      : super(key: key);
  final Choice choice;
  final bool choose;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: choose
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const IncomeCategodetail(),
                ),
              );
            }
          : () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) =>
                      const OutcomeCategoDetail(),
                ),
              );
            },
      child: SizedBox(
        width: 3000,
        height: 300,
        child: Card(
            elevation: 3,
            color: Colors.white,
            child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: Image(
                          image: AssetImage('images/${choice.imgname}.png')),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      child: Text(
                        choice.title,
                       
                      ),
                    ),
                    Text(
                      '${NumberFormat.decimalPattern().format(choice.amount)} MMK',
                    ),
                  ]),
            )),
      ),
    );
  }
}
