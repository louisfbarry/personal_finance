import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/model/firebaseservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:finance/model/firebaseservice.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../model/firebaseGet.dart';

List<String> outcomelist = [];
List<OutcomeData> OutcomeChart = [];
int total = 0;
bool finished = false;

// ignore: must_be_immutable
class OutcomeCategoDetail extends StatefulWidget {
  Stream<QuerySnapshot> userstream;
  OutcomeCategoDetail({Key? key, required this.userstream}) : super(key: key);

  @override
  State<OutcomeCategoDetail> createState() => _OutcomeCategoDetailState();
}

class _OutcomeCategoDetailState extends State<OutcomeCategoDetail> {
  String today = DateFormat("EEEEE, dd, MM, yyyy").format(DateTime.now());
  String yesterday = DateFormat("EEEEE, dd, MM, yyyy")
      .format(DateTime.now().subtract(const Duration(days: 1)));
  String daybefore = DateFormat("EEEEE, dd, MM, yyyy")
      .format(DateTime.now().subtract(const Duration(days: 2)));

  Map<String, dynamic>? data;
  String daybeforesplit() {
    List<String> parts = daybefore.split(',');
    return '${parts[0]}(${parts[1]},${parts[2]} ) ';
  }

  String datesplit(String date) {
    List<String> parts = date.split(',');
    return '${parts[0]}(${parts[1]},${parts[2]} ) ';
  }

  getlist() async {
    await outcomeCategoList().then((value) {
      setState(() {
        outcomelist = value;
      });
    });
    print(outcomelist);
    for (var i = 0; i < outcomelist.length; i++) {
      total = 0;
      await outcomecategovalue(outcomelist[i]).then((value) {
        total = value;
      });
      print('${outcomelist[i]}>>>>>$total');
      OutcomeChart.add(OutcomeData(outcomelist[i], total));
    }
    setState(() {
      finished = true;
    });
  }

  @override
  void initState() {
    OutcomeChart = [];
    getlist();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: StreamBuilder<QuerySnapshot>(
        stream: widget.userstream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [CircularProgressIndicator()],
            );
          }

          List<DetailStyle> todayDetail = [];
          List<DetailStyle> yestDetail = [];
          List<DetailStyle> daybeforeDetail = [];
          List<DetailStyle> left = [];

          snapshot.data!.docs.map((DocumentSnapshot document) {
            data = document.data()! as Map<String, dynamic>;
            if (data!['created At'] == today) {
              todayDetail.add(DetailStyle(
                data: data,
                getlist: getlist,
              ));
            } else if (data!['created At'] == yesterday) {
              yestDetail.add(DetailStyle(data: data, getlist: getlist));
            } else if (data!['created At'] == daybefore) {
              daybeforeDetail.add(DetailStyle(data: data, getlist: getlist));
            } else {
              left.add(DetailStyle(data: data, getlist: getlist));
            }
          }).toList();

          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 238, 250, 255),
            appBar: AppBar(title: const Text('Outcome')),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 30,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: finished
                        ? Card(
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
                                    //   OutcomeData("Salary", salaryTotal.toInt()),
                                    //   OutcomeData("Investment", investTotal.toInt()),
                                    //   OutcomeData(
                                    //       "Uncategorized", uncategoTotal.toInt())
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
                          )
                        : const Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text('Today'),
                  ),
                  todayDetail.isEmpty
                      ? const Text('No Outcome has been added !')
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
            ),
          );
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

  bool isloading = false;

  TextEditingController? amountcontroller;
  String dropdownValue = '';

  @override
  void initState() {
    amountcontroller = TextEditingController(text: '${widget.data!['amount']}');
    dropdownValue = widget.data!['category'];
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
              return Container(
                height: 400,
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
                                      child: Text(
                                        item,
                                        // textAlign: TextAlign.center,
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
                                      color: Color.fromARGB(157, 9, 237, 176)),
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
                        Text('Created At : ${widget.data!['created At']}'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                                onPressed: () async {
                                  finished = false;
                                  API().outcomehistroyupdate(
                                      dropdownValue,
                                      int.parse(amountcontroller!.text),
                                      widget.data!['id']);
                                  OutcomeChart = [];
                                  widget.getlist();
                                  print(finished);
                                  Navigator.pop(context);
                                },
                                child: const Text('Edit')),
                            ElevatedButton(
                                onPressed: () async {
                                  finished = false;
                                  API()
                                      .outcomehistorydelete(widget.data!['id']);
                                  OutcomeChart = [];
                                  widget.getlist();
                                  print(finished);
                                  Navigator.pop(context);
                                },
                                child: const Text('delete')),
                          ],
                        )
                      ],
                    ),
                  ]),
                ),
              );
            });
      },
      child: Padding(
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
                    const Icon(Icons.badge_outlined),
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
      ),
    );
  }
}
