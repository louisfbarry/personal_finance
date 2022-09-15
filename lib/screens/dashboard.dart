import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:pie_chart/pie_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:intl/intl.dart';

import 'incomecatego_detail.dart';
import 'outcomecatego_detail.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: StreamBuilder5<QuerySnapshot, QuerySnapshot, QuerySnapshot,
          QuerySnapshot, QuerySnapshot>(
        streams: StreamTuple5(stream1, stream2, stream3, stream4, stream5),
        builder: (context, snapshots) {
          int incomeTotal = 0;
          int outcomeTotal = 0;
          int savingTotal = 0;
          int incomecategototal = 0;
          Map<String, dynamic>? incomecategodata;
          Map<String, dynamic>? outcomecategodata;
          List<String> incomeCategoList = [];
          List<String> incomeCategoImgList = [];
          List<String> outcomeCategoList = [];
          List<String> outcomeCategoImgList = [];
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
            incomeCategoList = [];
            incomeCategoImgList = [];
            choices = [];
            incomecategototal = 0;
            for (var element in snapshots.snapshot4.data!.docs) {
              incomecategodata = element.data()! as Map<String, dynamic>;
              incomeCategoList.add(incomecategodata['categoname']);
              incomeCategoImgList.add(incomecategodata['imagId']);
            }
          }
          print(incomeCategoList);
          for (var i = 0; i < incomeCategoList.length; i++) {
            for (var data in snapshots.snapshot1.data!.docs) {
              if (data['category'] == incomeCategoList[i]) {
                int amount = data['amount'];
                incomecategototal = incomecategototal + amount;
              }
            }
            print(incomecategototal);
            choices.add(Choice(
                title: incomeCategoList[i],
                imgname: incomeCategoImgList[i],
                amount: incomecategototal));
            incomecategototal = 0;
          }

          if (snapshots.snapshot5.hasData) {
            outcomeCategoList = [];
            outcomeCategoImgList = [];
            for (var element in snapshots.snapshot5.data!.docs) {
              outcomecategodata = element.data()! as Map<String, dynamic>;
              outcomeCategoList.add(outcomecategodata['categoname']);
              outcomeCategoImgList.add(outcomecategodata['imagId']);
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
        },
      ),
    );
  }
}

// class Dashboard extends StatefulWidget {
//   const Dashboard({Key? key}) : super(key: key);
//   @override
//   State<Dashboard> createState() => _DashboardState();
// }

// class _DashboardState extends State<Dashboard> {
//   var stream1 = FirebaseFirestore.instance
//       .collection("${FirebaseAuth.instance.currentUser!.email}")
//       .doc("Income")
//       .collection("income-data")
//       .snapshots();

//   var stream2 = FirebaseFirestore.instance
//       .collection("${FirebaseAuth.instance.currentUser!.email}")
//       .doc("Outcome")
//       .collection("outcome-data")
//       .snapshots();

//   var stream3 = FirebaseFirestore.instance
//       .collection("${FirebaseAuth.instance.currentUser!.email}")
//       .doc("Saving")
//       .collection('saving-data')
//       .snapshots();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[100],
//       body: StreamBuilder3<QuerySnapshot, QuerySnapshot, QuerySnapshot>(
//         streams: StreamTuple3(stream1, stream2, stream3),
//         builder: (context, snapshots) {
//           int incomeTotal = 0;
//           int outcomeTotal = 0;
//           int savingTotal = 0;
//           if (snapshots.snapshot1.hasError) {
//             return Text('Error: ${snapshots.snapshot1.error}');
//           } else if (snapshots.snapshot2.hasError) {
//             return Text('Error: ${snapshots.snapshot2.error}');
//           } else if (snapshots.snapshot3.hasError) {
//             return Text('Error: ${snapshots.snapshot3.error}');
//           }
//           if (snapshots.snapshot1.connectionState ==
//               "ConnectionState.waiting") {
//             // return const Center(child: CircularProgressIndicator()
//             return const SpinKitPulse(
//               color: Colors.grey,
//             );
//           }
//           if (snapshots.snapshot2.connectionState ==
//               "ConnectionState.waiting") {
//             // return const Center(child: CircularProgressIndicator()
//             return const SpinKitPulse(
//               color: Colors.grey,
//             );
//           }
//           if (snapshots.snapshot3.connectionState ==
//               "ConnectionState.waiting") {
//                 return const SpinKitPulse(
//               color: Colors.grey,
//             );
//           }
//           if (snapshots.snapshot1.hasData) {
//             // var incomeData = snapshots.snapshot1.data!.docs;
//             for (var data in snapshots.snapshot1.data!.docs) {
//               var incomeField = data;
//               int amount = incomeField['amount'];
//               incomeTotal = incomeTotal + amount;
//             }
//           }
//           if (snapshots.snapshot2.hasData) {
//             // var incomeData = snapshots.snapshot1.data!.docs;
//             for (var data in snapshots.snapshot2.data!.docs) {
//               var outcomeField = data;
//               int amount = outcomeField['amount'];
//               outcomeTotal = outcomeTotal + amount;
//             }
//           }
//           if (snapshots.snapshot3.hasData) {
//             for (var data in snapshots.snapshot3.data!.docs) {
//               var savingField = data;
//               int addPrice = savingField['addPrice'];
//               savingTotal = savingTotal + addPrice;
//             }
//             return DashboardUi(
//               income: incomeTotal,
//               outcome: outcomeTotal,
//               saving: savingTotal,
//               incomeVs: incomeTotal - (outcomeTotal + savingTotal),
//               allTotal: incomeTotal + outcomeTotal + savingTotal,
//             );
//           }
//           // return const Center(child: CircularProgressIndicator());
//           // #edit
//           return Center(child: Container());
//         },
//       ),
//     );
//   }
// }

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
      // backgroundColor: Colors.grey[100],
      body: (displayName == "")
          ? Center(
              // child: CircularProgressIndicator(),
              child: Container(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 60,
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          elevation: 0.0,
                          // color: Colors.grey[800],
                          color: Colors.blue[700],

                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                  // "${widget.income - (widget.outcome + widget.saving)}",
                                  // "${widget.incomeVs}",
                                  NumberFormat.decimalPattern()
                                      .format(widget.incomeVs),
                                  style: TextStyle(
                                      color: Colors.grey[100],
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // Text("income - ${widget.income}"),
                      // Text("outcome - ${widget.outcome}"),
                      // Text("saving - ${widget.saving}"),
                      // Text("all Total - ${widget.allTotal}"),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 280,
                        child: Card(
                          color: Colors.grey[100],
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Row(
                                              children: [
                                                Transform.scale(
                                                  scale: 0.8,
                                                  child: Radio(
                                                      value: 1,
                                                      groupValue: selectedChart,
                                                      onChanged: (value) =>
                                                          setState(() {
                                                            selectedChart = 1;
                                                          })),
                                                ),
                                                const Expanded(
                                                    child: Text(
                                                  "Pie Chart",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ))
                                              ],
                                            )),
                                        Expanded(
                                            flex: 1,
                                            child: Row(
                                              children: [
                                                Transform.scale(
                                                  scale: 0.8,
                                                  child: Radio(
                                                      value: 2,
                                                      groupValue: selectedChart,
                                                      onChanged: (value) =>
                                                          setState(() {
                                                            selectedChart = 2;
                                                          })),
                                                ),
                                                const Expanded(
                                                    child: Text(
                                                  "Column Chart",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ))
                                              ],
                                            ))
                                      ],
                                    ),
                                    (selectedChart == 1)
                                        ? SizedBox(
                                            height: 200,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: SfCircularChart(
                                                legend: Legend(
                                                    isVisible: true,
                                                    position:
                                                        LegendPosition.bottom),
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
                                                series: <CircularSeries>[
                                                  PieSeries<IOData, String>(
                                                    dataSource: [
                                                      IOData(
                                                          "Income",
                                                          double.parse(((widget
                                                                          .income /
                                                                      widget
                                                                          .allTotal) *
                                                                  100)
                                                              .toStringAsFixed(
                                                                  2)),
                                                          "${double.parse(((widget.income / widget.allTotal) * 100).toStringAsFixed(2))}%"),
                                                      IOData(
                                                          "Outcome",
                                                          double.parse(((widget
                                                                          .outcome /
                                                                      widget
                                                                          .allTotal) *
                                                                  100)
                                                              .toStringAsFixed(
                                                                  2)),
                                                          "${double.parse(((widget.outcome / widget.allTotal) * 100).toStringAsFixed(2))}%"),
                                                      IOData(
                                                          "Saving",
                                                          double.parse(((widget
                                                                          .saving /
                                                                      widget
                                                                          .allTotal) *
                                                                  100)
                                                              .toStringAsFixed(
                                                                  2)),
                                                          "${double.parse(((widget.saving / widget.allTotal) * 100).toStringAsFixed(2))}%")
                                                    ],
                                                    xValueMapper:
                                                        (IOData data, _) =>
                                                            data.iotype,
                                                    yValueMapper:
                                                        (IOData data, _) =>
                                                            data.iovalue,
                                                    dataLabelMapper:
                                                        (IOData data, _) =>
                                                            data.iolabel,
                                                    dataLabelSettings:
                                                        const DataLabelSettings(
                                                      isVisible: true,
                                                      showZeroValue: true,
                                                      // overflowMode:
                                                      //     OverflowMode
                                                      //         .trim,
                                                      overflowMode:
                                                          OverflowMode.shift,
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
                                                  const EdgeInsets.all(5.0),
                                              child: SfCartesianChart(
                                                tooltipBehavior:
                                                    TooltipBehavior(
                                                        enable: true),
                                                series: <ChartSeries>[
                                                  ColumnSeries<IOCData, String>(
                                                    dataSource: [
                                                      IOCData(
                                                          "income",
                                                          widget.income,
                                                          NumberFormat
                                                                  .decimalPattern()
                                                              .format(widget
                                                                  .income)),
                                                      IOCData(
                                                          "outcome",
                                                          widget.outcome,
                                                          NumberFormat
                                                                  .decimalPattern()
                                                              .format(widget
                                                                  .outcome)),
                                                      IOCData(
                                                          "saving",
                                                          widget.saving,
                                                          NumberFormat
                                                                  .decimalPattern()
                                                              .format(widget
                                                                  .saving))
                                                    ],
                                                    name: "data",
                                                    xValueMapper:
                                                        (IOCData data, _) =>
                                                            data.iotype,
                                                    yValueMapper:
                                                        (IOCData data, _) =>
                                                            data.iovalue,
                                                    dataLabelMapper:
                                                        (IOCData data, _) =>
                                                            data.iolabel,
                                                    enableTooltip: true,
                                                    dataLabelSettings:
                                                        const DataLabelSettings(
                                                            isVisible: true,
                                                            labelAlignment:
                                                                ChartDataLabelAlignment
                                                                    .outer),
                                                  ),
                                                ],
                                                primaryXAxis: CategoryAxis(),
                                              ),
                                            ),
                                          ),
                                    // : Text("hi")
                                  ],
                                ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute<void>(
                                //     builder: (BuildContext context) =>
                                //         const CategoDetail(),
                                //   ),
                                // );
                              },
                              child: const Text('To Income Detail')),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        const OutcomeCategoDetail(),
                                  ),
                                );
                              },
                              child: const Text('To outcome Detail')),
                        ],
                      ),
                      Container(
                        color: Colors.amber,
                        width: (MediaQuery.of(context).size.width),
                        height: MediaQuery.of(context).size.height * 0.4,
                        child: GridView.count(
                            crossAxisCount: 3,
                            primary: false,
                            padding: const EdgeInsets.all(6),
                            children: List.generate(choices.length, (index) {
                              return Center(
                                child: SelectCard(choice: choices[index]),
                              );
                            })),
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


class SelectCard extends StatelessWidget {
  const SelectCard({Key? key, required this.choice}) : super(key: key);
  final Choice choice;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => const CategoDetail(),
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
              child: SizedBox(
                // height: MediaQuery.of(context).size.height * 0.4,
                // height : 300,
                // width: 150,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: Image(
                            image: AssetImage(
                                'images/Income/${choice.imgname}.png')),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text(
                          choice.title,
                          style:
                              const TextStyle(fontFamily: 'Libre', fontSize: 10),
                        ),
                      ),
                      Text(
                        '${choice.amount}',
                        style: const TextStyle(fontFamily: 'Libre', fontSize: 10),
                      ),
                    ]),
              ),
            )),
      ),
    );
  }
}