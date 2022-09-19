import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/model/firebaseservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../model/firebaseGet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

List<String> incomelist = [];
List<String> incomeImglist = [];
List<IncomeData> incomeChart = [];
int total = 0;
bool finished = false;
bool isloading = false;

// ignore: must_be_immutable
class IncomeCategodetail extends StatefulWidget {
  const IncomeCategodetail({Key? key}) : super(key: key);

  @override
  State<IncomeCategodetail> createState() => _IncomeCategodetailState();
}

class _IncomeCategodetailState extends State<IncomeCategodetail> {
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
    await incomeCategoList().then((value) {
      incomelist = value;
    });

    await incomeCategoImgList().then((value) {
      incomeImglist = value;
    });

    for (var i = 0; i < incomelist.length; i++) {
      total = 0;
      await incomecategovalue(incomelist[i]).then((value) {
        total = value;
      });
      print('${incomelist[i]}>>>>>$total');
      incomeChart.add(IncomeData(incomelist[i], total));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var stream1 = FirebaseFirestore.instance
        .collection('${FirebaseAuth.instance.currentUser!.email}')
        .doc('Income-catego')
        .collection('data')
        .snapshots();
    var stream2 = FirebaseFirestore.instance
        .collection("${FirebaseAuth.instance.currentUser!.email}")
        .doc("Income")
        .collection("income-data")
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
                incomelist = [];
                for (var data in snapshots.snapshot1.data!.docs) {
                  incomelist.add(data['categoname']);
                  incomeImglist.add(data['imagId']);
                }
              }

              if (snapshots.snapshot2.hasData) {
                incomeChart = [];

                for (var i = 0; i < incomelist.length; i++) {
                  print(incomelist[i]);
                  total = 0;

                  for (var doc in snapshots.snapshot2.data!.docs) {
                    if (doc['category'] == incomelist[i]) {
                      int amount = doc['amount'];
                      total = total + amount;
                      // print(total);
                    }
                  }
                  incomeChart.add(IncomeData(incomelist[i], total));
                  print('${incomelist[i]}>>>>$total');
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

              return Scaffold(
                  backgroundColor: const Color.fromARGB(255, 238, 250, 255),
                  // appBar: AppBar(title: const Text('Income')),
                  appBar: AppBar(
                    centerTitle: true,
                    title: Text(
                      AppLocalizations.of(context)!.incomeDetails,
                      style: TextStyle(fontSize: 15),
                    ),
                    elevation: 0.0,
                    backgroundColor: Colors.blue[700],
                  ),
                  body: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: SfCircularChart(
                                  legend: Legend(
                                      isVisible: true,
                                      position: LegendPosition.bottom),
                                  tooltipBehavior:
                                      TooltipBehavior(enable: true),
                                  series: <CircularSeries>[
                                    PieSeries<IncomeData, String>(
                                      dataSource: incomeChart,
                                      xValueMapper: (IncomeData data, _) =>
                                          data.IncomeType,
                                      yValueMapper: (IncomeData data, _) =>
                                          data.IncomeValue,
                                      dataLabelSettings:
                                          const DataLabelSettings(
                                              isVisible: true,
                                              showZeroValue: true,
                                              overflowMode: OverflowMode.trim,
                                              showCumulativeValues: true,
                                              labelPosition:
                                                  ChartDataLabelPosition
                                                      .outside),
                                      enableTooltip: true,
                                    )
                                  ],
                                ),
                              ),
                            )),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 10),
                          child: Text(
                            AppLocalizations.of(context)!.today,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[800]),
                          ),
                        ),
                        todayDetail.isEmpty
                            ? Center(child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('No Income has been added !',
                          style: TextStyle(
                          // fontWeight: FontWeight.w500,
                          color: Colors.grey[800]
                      ),
                          ),
                        ))
                            : Card(
                                elevation: 1,
                                child: Column(children: todayDetail)),
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
                  )
                  // : Center(
                  //     // #edit
                  //     // child: CircularProgressIndicator(),
                  //     child: Container(),
                  //   ),
                  );
            }));
  }
}

class IncomeData {
  String IncomeType;
  int IncomeValue;
  IncomeData(this.IncomeType, this.IncomeValue);
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
    isloading = false;
    await getImg(widget.data!['category']).then((value) {
      setState(() {
        img = value;
      });
    });
    setState(() {
      isloading = true;
    });
  }

  @override
  void initState() {
    // amountcontroller = TextEditingController(
    //     text: NumberFormat.decimalPattern().format(widget.data!['amount']));
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
                  height: MediaQuery.of(context).size.height * 0.7,
                  decoration: const BoxDecoration(
                      color: Colors.white,
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
                            width: MediaQuery.of(context).size.width,
                            child: DropdownButtonFormField(
                              value: dropdownValue,
                              isExpanded: true,
                              items: incomelist
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              height: 25,
                                              width: 25,
                                              child: Image(
                                                  image: AssetImage(
                                                      'images/${incomeImglist[incomelist.indexOf(item)]}.png')),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              item,
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
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Text('Amount'),
                          ),
                          SizedBox(
                            height: 60,
                            width: MediaQuery.of(context).size.width,
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
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.black),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2, color: Colors.black),
                                    borderRadius: BorderRadius.circular(5)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1, color: Colors.redAccent),
                                    borderRadius: BorderRadius.circular(5)),
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
                            width: MediaQuery.of(context).size.width,
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
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.black),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 2,
                                        color: Color.fromARGB(157, 0, 0, 0)),
                                    borderRadius: BorderRadius.circular(5)),
                                focusedErrorBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1, color: Colors.redAccent),
                                    borderRadius: BorderRadius.circular(5)),
                                // filled: true,
                                // fillColor: const Color.fromARGB(157, 9, 237, 176),

                                hintText: '${widget.data!['note']}',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                                'Created At : ${widget.data!['created At']}'),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 0, primary: Colors.blue[700]),
                                  onPressed: () async {
                                    finished = false;
                                    API().incomehistroyupdate(
                                      dropdownValue,
                                      int.parse(amountcontroller!.text),
                                      notecontroller!.text,
                                      widget.data!['id'],
                                    );
                                    incomeChart = [];
                                    widget.getlist();
                                    print(finished);

                                    Navigator.pop(context);
                                  },
                                  child: Text(AppLocalizations.of(context)!.edit)),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 0, primary: Colors.blue[700]),
                                    
                                  onPressed: () {
                                    finished = false;
                                    API().incomehistroydelete(
                                        widget.data!['id']);
                                    incomeChart = [];
                                    widget.getlist();
                                    print(finished);

                                    Navigator.pop(context);
                                  },
                                  child: Text(AppLocalizations.of(context)!.delete)),
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
      child: isloading
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
                        '${NumberFormat.decimalPattern().format(widget.data!['amount'])} MMK',
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
