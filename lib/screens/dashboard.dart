import 'package:finance/screens/Income.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pie_chart/pie_chart.dart';

import '../model/firebaseservice.dart';
import '../components/categobadge.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Map<String, double> dataMap = {
    "Income": 40000,
    "Outcome": 10000,
    "Saving": 20000,
  };

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
      // backgroundColor: const Color.fromRGBO(193, 214, 233, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: Card(
                    elevation: 0.0,
                    color: Colors.grey[800],
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "User",
                            style: TextStyle(
                                color: Colors.grey[200],
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          
                          Text(
                            "100000",
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
                Row(
                  children: [
                    SizedBox(
                      height: 200,
                      width: 200,
                      child: LayoutBuilder(
                          builder: ((context, constraints) => Container(
                                decoration: const BoxDecoration(
                                  // color: Color.fromRGBO(193, 214, 233, 1),
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      spreadRadius: -10,
                                      blurRadius: 17,
                                      offset: Offset(-5, -5),
                                      color: Colors.white,
                                    ),
                                    BoxShadow(
                                      spreadRadius: -2,
                                      blurRadius: 10,
                                      offset: Offset(7, 7),
                                      // color: Color.fromRGBO(146, 182, 216, 1),
                                      // color: Color.fromRGBO(146, 182, 216, 1),
                                      color: Colors.grey,
                                    )
                                  ],
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: PieChart(
                                    dataMap: dataMap,
                                    colorList: [
                                      Colors.blue.shade200,
                                      Colors.red.shade200,
                                      Colors.green.shade200
                                      // Colors.grey.shade400,
                                      // Colors.grey.shade600,
                                      // Colors.grey.shade700,
                                    ],
                                    animationDuration:
                                        const Duration(milliseconds: 1000),
                                    chartRadius:
                                        MediaQuery.of(context).size.width / 2,
                                    chartValuesOptions:
                                        const ChartValuesOptions(
                                      showChartValuesInPercentage: true,
                                      showChartValueBackground: false,
                                      // showChartValuesOutside: true
                                    ),
                                    legendOptions:
                                        const LegendOptions(showLegends: false),
                                  ),
                                ),
                              ))),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                                width: 10,
                                child: CircleAvatar(
                                    backgroundColor: Colors.indigo[200])),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text("Income")
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                                width: 10,
                                child: CircleAvatar(
                                    backgroundColor: Colors.red[200])),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text("Outcome")
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                                width: 10,
                                child: CircleAvatar(
                                    backgroundColor: Colors.green[200])),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text("Saving")
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                // const SizedBox(
                //   height: 15,
                // ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => IncomePage(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: Text(
                      "Income >",
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                SizedBox(
                  width: (MediaQuery.of(context).size.width),
                  height: 150,
                  child: ListView(
                      scrollDirection: Axis.horizontal,
                      primary: false,
                      padding: const EdgeInsets.all(6),
                      children: List.generate(choices.length, (index) {
                        return Center(
                          child: SelectCard(choice: choices[index]),
                        );
                      })),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Text(
                    "Outcome >",
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: (MediaQuery.of(context).size.width / 2) - 20,
                        height: 100,
                        child: const Card()),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SelectCard extends StatelessWidget {
  const SelectCard({Key? key, required this.choice}) : super(key: key);
  final Choice choice;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   Navigator.push(
      //       context,
      //       MaterialPageRoute<void>(
      //         builder: (BuildContext context) =>
      //             IncomeCategoDetail(userstream: choice.userstream),
      //       ));
      // },
      child: Card(
          elevation: 7,
          color: choice.color,
          child: Center(
            child: SizedBox(
              height: 150,
              width: 150,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child:
                            Icon(choice.icon, size: 40.0, color: Colors.black)),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        choice.title,
                        style:
                            const TextStyle(fontFamily: 'Libre', fontSize: 12),
                      ),
                    ),
                  ]),
            ),
          )),
    );
  }
}
