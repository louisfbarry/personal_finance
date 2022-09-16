import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/model/firebaseservice.dart';
import 'package:finance/screens/incomecatego_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:finance/model/firebaseservice.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../model/firebaseGet.dart';

List<String> outcomelist = [];
List<String> outcomeImglist = [];
List<OutcomeData> OutcomeChart = [];
int outcometotal = 0;
bool outcomefinished = false;
bool outcomeisloading = false;

// ignore: must_be_immutable
class OutcomeCategoDetail extends StatefulWidget {
  const OutcomeCategoDetail({Key? key}) : super(key: key);

  @override
  State<OutcomeCategoDetail> createState() => _OutcomeCategoDetailState();
}

class _OutcomeCategoDetailState extends State<OutcomeCategoDetail> {
  String today = DateFormat("EEEEE, dd, MM, yyyy").format(DateTime.now());
  String yesterday = DateFormat("EEEEE, dd, MM, yyyy")
      .format(DateTime.now().subtract(const Duration(days: 1)));
  String daybefore = DateFormat("EEEEE, dd, MM, yyyy")
      .format(DateTime.now().subtract(const Duration(days: 2)));

  String daybeforesplit() {
    List<String> parts = daybefore.split(',');
    return '${parts[0]}(${parts[1]}/${parts[2]} ) ';
  }

  String datesplit(String date) {
    List<String> parts = date.split(',');
    return '${parts[0]}(${parts[1]},${parts[2]} ) ';
  }

  Map<String, dynamic>? data;

  getlist() async {
    await outcomeCategoList().then((value) {
      outcomelist = value;
    });
    await outcomeCategoImgList().then((value) {
      outcomeImglist = value;
    });

    for (var i = 0; i < outcomelist.length; i++) {
      outcometotal = 0;
      await outcomecategovalue(outcomelist[i]).then((value) {
        outcometotal = value;
      });
      print('${outcomelist[i]}>>>>>$outcometotal');
      OutcomeChart.add(OutcomeData(outcomelist[i], outcometotal));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var stream1 = FirebaseFirestore.instance
        .collection('${FirebaseAuth.instance.currentUser!.email}')
        .doc('Outcome-catego')
        .collection('data')
        .snapshots();
    var stream2 = FirebaseFirestore.instance
        .collection("${FirebaseAuth.instance.currentUser!.email}")
        .doc("Outcome")
        .collection("outcome-data")
        .snapshots();
    List<DetailStyle> todayDetail = [];
    List<DetailStyle> yestDetail = [];
    List<DetailStyle> daybeforeDetail = [];
    List<DetailStyle> left = [];

    return SizedBox(
      child: StreamBuilder2<QuerySnapshot, QuerySnapshot>(
        streams: StreamTuple2(
          stream1,
          stream2,
        ),
        builder: (BuildContext context, snapshots) {
          if (snapshots.snapshot1.hasError) {
            return Text('Error: ${snapshots.snapshot1.error}');
          } else if (snapshots.snapshot2.hasError) {
            return Text('Error: ${snapshots.snapshot2.error}');
          }

          if (snapshots.snapshot1.connectionState ==
              "ConnectionState.waiting") {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshots.snapshot2.connectionState ==
              "ConnectionState.waiting") {
            return const Center(child: CircularProgressIndicator());
          }

          todayDetail = [];
          yestDetail = [];
          daybeforeDetail = [];
          left = [];

          if (snapshots.snapshot1.hasData) {
            outcomelist = [];
            for (var data in snapshots.snapshot1.data!.docs) {
              outcomelist.add(data['categoname']);
              outcomeImglist.add(data['imagId']);
            }
          }

          if (snapshots.snapshot2.hasData) {
            OutcomeChart = [];

            for (var i = 0; i < outcomelist.length; i++) {
              print(outcomelist[i]);
              outcometotal = 0;

              for (var doc in snapshots.snapshot2.data!.docs) {
                if (doc['category'] == outcomelist[i]) {
                  int amount = doc['amount'];
                  outcometotal = outcometotal + amount;
                  // print(outcometotal);
                }
              }
              OutcomeChart.add(OutcomeData(outcomelist[i], outcometotal));
              print('${outcomelist[i]}>>>>$outcometotal');
            }
            snapshots.snapshot2.data!.docs.map((DocumentSnapshot document) {
              data = document.data() as Map<String, dynamic>;
              if (data!['created At'] == today) {
                todayDetail.add(DetailStyle(
                  data: data,
                  getlist: getlist,
                ));
              } else if (data!['created At'] == yesterday) {
                yestDetail.add(DetailStyle(
                  data: data,
                  getlist: getlist,
                ));
              } else if (data!['created At'] == daybefore) {
                daybeforeDetail.add(DetailStyle(
                  data: data,
                  getlist: getlist,
                ));
              } else {
                left.add(DetailStyle(
                  data: data,
                  getlist: getlist,
                ));
              }
            }).toList();
          }

          // snapshot.data!.docs.map((DocumentSnapshot document) {
          //   data = document.data()! as Map<String, dynamic>;
          //   if (data!['created At'] == today) {
          //     todayDetail.add(DetailStyle(
          //       data: data,
          //       getlist: getlist,
          //     ));
          //   } else if (data!['created At'] == yesterday) {
          //     yestDetail.add(DetailStyle(data: data, getlist: getlist));
          //   } else if (data!['created At'] == daybefore) {
          //     daybeforeDetail.add(DetailStyle(data: data, getlist: getlist));
          //   } else {
          //     left.add(DetailStyle(data: data, getlist: getlist));
          //   }
          // }).toList();

          return Scaffold(
              backgroundColor: const Color.fromARGB(255, 238, 250, 255),
              appBar: AppBar(title: const Text('Expenses')),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 30,
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: SfCircularChart(
                            legend: Legend(
                                isVisible: true,
                                position: LegendPosition.bottom),
                            tooltipBehavior: TooltipBehavior(enable: true),
                            series: <CircularSeries>[
                              PieSeries<OutcomeData, String>(
                                dataSource: OutcomeChart,
                                // dataSource: [
                                //   OutcomeData("Salary", salaryoutcometotal.toInt()),
                                //   OutcomeData("Investment", investoutcometotal.toInt()),
                                //   OutcomeData(
                                //       "Uncategorized", uncategooutcometotal.toInt())
                                // ],
                                xValueMapper: (OutcomeData data, _) =>
                                    data.OutcomeType,
                                yValueMapper: (OutcomeData data, _) =>
                                    data.OutcomeValue,
                                dataLabelSettings: const DataLabelSettings(
                                    isVisible: true,
                                    showZeroValue: true,
                                    overflowMode: OverflowMode.trim,
                                    showCumulativeValues: true,
                                    labelPosition:
                                        ChartDataLabelPosition.outside),
                                enableTooltip: true,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 10.0),
                      child: Text('Today'),
                    ),
                    todayDetail.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text('No Expenses has been added !'),
                          )
                        : Card(
                            elevation: 1, child: Column(children: todayDetail)),
                    yestDetail.isEmpty
                        ? const Text('')
                        : const Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text('Yesterday'),
                          ),
                    Card(
                      elevation: 1,
                      child: Column(
                        children: yestDetail,
                      ),
                    ),
                    daybeforeDetail.isEmpty
                        ? const Text('')
                        : Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(daybeforesplit()),
                          ),
                    Card(
                      elevation: 1,
                      child: Column(
                        children: daybeforeDetail,
                      ),
                    ),
                    left.isEmpty
                        ? const Text('')
                        : const Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Text('Last 7 day'),
                          ),
                    Card(
                      elevation: 2,
                      child: Column(
                        children: left,
                      ),
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }
}

class OutcomeData {
  String OutcomeType;
  int OutcomeValue;
  OutcomeData(this.OutcomeType, this.OutcomeValue);
}

// ignore: must_be_immutable
class DetailStyle extends StatefulWidget {
  Map<String, dynamic>? data;
  VoidCallback getlist;
  DetailStyle({Key? key, required this.data, required this.getlist})
      : super(key: key);

  @override
  State<DetailStyle> createState() => _DetailStyleState();
}

class _DetailStyleState extends State<DetailStyle> {
  String showdate = '';

  bool confirmpass = true;

  bool submitted = false;

  TextEditingController? amountcontroller;
  TextEditingController? notecontroller;
  String dropdownValue = '';
  String img = 'a';

  getimg() async {
    outcomeisloading = false;
    await getOutcomeImg(widget.data!['category']).then((value) {
      setState(() {
        img = value;
      });
    });

    outcomeisloading = true;
  }

  @override
  void initState() {
    amountcontroller = TextEditingController(text: '${widget.data!['amount']}');
    notecontroller = TextEditingController(text: '${widget.data!['note']}');
    dropdownValue = widget.data!['category'];
    getimg();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            backgroundColor: Colors.transparent,
            barrierColor: Colors.transparent,
            context: context,
            builder: (_) {
              return SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(240, 245, 252, 228),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.close))),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 5.0),
                            child: Text('Category'),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: DropdownButtonFormField(
                              value: dropdownValue,
                              isExpanded: true,
                              items: outcomelist
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              height: 25,
                                              width: 25,
                                              child: Image(
                                                  image: AssetImage(
                                                      'images/${outcomeImglist[outcomelist.indexOf(item)]}.png')),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              item,
                                              // textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  dropdownValue = newValue.toString();
                                });
                              },
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 1, color: Colors.black),
                                      borderRadius: BorderRadius.circular(5)),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 2, color: Colors.black),
                                      borderRadius: BorderRadius.circular(5))),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 5.0),
                            child: Text('Amount'),
                          ),
                          SizedBox(
                            height: 60,
                            width: 300,
                            child: TextFormField(
                              controller: amountcontroller,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                              autovalidateMode: submitted
                                  ? AutovalidateMode.always
                                  : AutovalidateMode.disabled,
                              validator: RequiredValidator(
                                  errorText: 'Pls enter your amount'),
                              decoration: InputDecoration(
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.redAccent),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.black),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2,
                                        color:
                                            Color.fromARGB(157, 9, 237, 176)),
                                    borderRadius: BorderRadius.circular(10)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1, color: Colors.redAccent),
                                    borderRadius: BorderRadius.circular(10)),
                                // filled: true,
                                // fillColor: const Color.fromARGB(157, 9, 237, 176),

                                hintText: '${widget.data!['amount']}',
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 5.0),
                            child: Text('Note'),
                          ),
                          SizedBox(
                            height: 60,
                            width: 300,
                            child: TextFormField(
                              controller: notecontroller,
                              autovalidateMode: submitted
                                  ? AutovalidateMode.always
                                  : AutovalidateMode.disabled,
                              validator: RequiredValidator(
                                  errorText: 'Pls enter your note'),
                              decoration: InputDecoration(
                                errorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.redAccent),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.black),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2,
                                        color:
                                            Color.fromARGB(157, 9, 237, 176)),
                                    borderRadius: BorderRadius.circular(10)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1, color: Colors.redAccent),
                                    borderRadius: BorderRadius.circular(10)),
                                // filled: true,
                                // fillColor: const Color.fromARGB(157, 9, 237, 176),

                                hintText: '${widget.data!['note']}',
                              ),
                            ),
                          ),
                          Text('Created At : ${widget.data!['created At']}'),
Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                  onPressed: () async {
                                    outcomefinished = false;
                                    API().outcomehistroyupdate(
                                        dropdownValue,
                                        int.parse(amountcontroller!.text),
                                        notecontroller!.text,
                                        widget.data!['id']);
                                    OutcomeChart = [];
                                    widget.getlist();
                                    print(outcomefinished);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Edit')),
                              ElevatedButton(
                                  onPressed: () async {
                                    outcomefinished = false;
                                    API().outcomehistorydelete(
                                        widget.data!['id']);
                                    OutcomeChart = [];
                                    widget.getlist();
                                    print(outcomefinished);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('delete')),
                            ],
                          )
                        ],
                      ),
                    ]),
                  ),
                ),
              );
            });
      },
      child: outcomeisloading
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: 25,
                            width: 25,
                            child: Image(image: AssetImage('images/$img.png')),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            '${widget.data!['category']} ',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.black),
                          ),
                        ],
                      ),
                      Text(
                        '${widget.data!['amount']} MMK',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : const Center(
              child: Text('....'),
            ),
    );
  }
}













