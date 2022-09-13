import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/model/firebaseservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../model/firebaseGet.dart';

List<String> incomelist = [];
List<String> incomeImglist = [];
List<IncomeData> IncomeChart = [];
int total = 0;
bool finished = false;

// ignore: must_be_immutable
class CategoDetail extends StatefulWidget {
  CategoDetail({Key? key}) : super(key: key);

  @override
  State<CategoDetail> createState() => _CategoDetailState();
}

class _CategoDetailState extends State<CategoDetail> {
  String today = DateFormat("EEEEE, dd, MM, yyyy").format(DateTime.now());
  String yesterday = DateFormat("EEEEE, dd, MM, yyyy")
      .format(DateTime.now().subtract(const Duration(days: 1)));
  String daybefore = DateFormat("EEEEE, dd, MM, yyyy")
      .format(DateTime.now().subtract(const Duration(days: 2)));

  Map<String, dynamic>? data;
  String daybeforesplit() {
    List<String> parts = daybefore.split(',');
    return '${parts[0]}(${parts[1]}/${parts[2]} ) ';
  }

  String datesplit(String date) {
    List<String> parts = date.split(',');
    return '${parts[0]}(${parts[1]},${parts[2]} ) ';
  }

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
      IncomeChart.add(IncomeData(incomelist[i], total));
    }
    setState(() {
      finished = true;
    });
  }

  @override
  void initState() {
    IncomeChart = [];
    getlist();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: StreamBuilder<QuerySnapshot>(
        stream: firestore
            .collection('${FirebaseAuth.instance.currentUser!.email}')
            .doc('Income')
            .collection('income-data')
            .orderBy('created At', descending: false)
            .snapshots(),
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
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 238, 250, 255),
            appBar: AppBar(title: const Text('Income')),
            body: finished
                ? SingleChildScrollView(
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
                                  tooltipBehavior:
                                      TooltipBehavior(enable: true),
                                  series: <CircularSeries>[
                                    PieSeries<IncomeData, String>(
                                      dataSource: IncomeChart,
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
                        const Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text('Today'),
                        ),
                        todayDetail.isEmpty
                            ? const Text('No Income has been added !')
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
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          );
        },
      ),
    );
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

  bool isloading = false;

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
                                                      'images/Income/${incomeImglist[incomelist.indexOf(item)]}.png')),
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
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                                'Created At : ${widget.data!['created At']}'),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                  onPressed: () async {
                                    finished = false;
                                    API().incomehistroyupdate(
                                      dropdownValue,
                                      int.parse(amountcontroller!.text),
                                      notecontroller!.text,
                                      widget.data!['id'],
                                    );
                                    IncomeChart = [];
                                    widget.getlist();
                                    print(finished);

                                    Navigator.pop(context);
                                  },
                                  child: const Text('Edit')),
                              ElevatedButton(
                                  onPressed: () {
                                    finished = false;
                                    API().incomehistroydelete(
                                        widget.data!['id']);
                                    IncomeChart = [];
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
                            child: Image(
                                image: AssetImage('images/Income/$img.png')),
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
