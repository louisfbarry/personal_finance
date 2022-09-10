import 'package:finance/components/incomadding_detail.dart';
import 'package:finance/components/outcomeadding_detail.dart';
import 'package:finance/model/firebaseGet.dart';
import 'package:flutter/material.dart';
import '../model/firebaseservice.dart';

// bool addvaluefinished = false;

class AddValue extends StatefulWidget {
  const AddValue({Key? key}) : super(key: key);

  @override
  State<AddValue> createState() => _AddValueState();
}

class _AddValueState extends State<AddValue> {
  TextEditingController outcomeamountcontroller = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool submitted = false;
  List<String>? incomelist;
  List<String>? outcomelist;
  List<String>? outcomeImglist;
  List<String>? incomeImglist;
  getlist() async {
    await incomeCategoList().then((value) {
      setState(() {
        incomelist = value;
      });
    });
    // print(incomelist);

    await incomeCategoImgList().then((value) {
      setState(() {
        incomeImglist = value;
      });
    });

    await outcomeCategoList().then((value) {
      setState(() {
        outcomelist = value;
      });
    });
    // print(outcomelist);

    await outcomeCategoImgList().then((value) {
      setState(() {
        outcomeImglist = value;
      });
    });
    // print(outcomeImglist);

    // setState(() {
    //   addvaluefinished = true;
    // });
  }

  @override
  void initState() {
    API().addCollection();
    getlist();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 194, 237, 255),
        appBar: AppBar(
          elevation: 5,
          backgroundColor: const Color.fromARGB(255, 194, 237, 255),
          bottom: const TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black,
            tabs: [
              Tab(
                text: 'Income',
              ),
              Tab(
                text: 'Outcome',
              ),
              Tab(
                text: 'Saving',
              ),
            ],
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            '__',
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
        body: outcomeImglist == null
            ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [CircularProgressIndicator()]),
              )
            : Form(
                key: _formKey,
                child: TabBarView(children: [
                  IncomeAddingDetail(
                    incomeCategoList: incomelist!,
                    incomeCategoImgList: incomeImglist!,
                  ),
                  OutcomeAddingDetail(
                    outcomeCategoList: outcomelist!,
                    outcomeCategoIMgList: outcomeImglist!,
                  ),
                  Center(
                    child: Text('THird'),
                  ),
                ]),
              ),
      ),
    );
  }
}
