import 'package:finance/components/incomadding_detail.dart';
import 'package:finance/components/outcomeadding_detail.dart';
import 'package:finance/model/firebaseGet.dart';
import 'package:finance/screens/Income.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../model/firebaseservice.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  getlist() async {
    await IncomeCategoList().then((value) {
      setState(() {
        incomelist = value;
      });
    });
    print(incomelist);
  }

  @override
  void initState() {
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
        body: incomelist == null
            ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                  CircularProgressIndicator()
                ]),
              )
            : Form(
                key: _formKey,
                child: TabBarView(children: [
                  IncomeAddingDetail(
                    incomeCategoList: incomelist!,
                  ),
                  OutcomeAddingDetail(),
                  Center(
                    child: Text('THird'),
                  ),
                ]),
              ),
      ),
    );
  }
}
