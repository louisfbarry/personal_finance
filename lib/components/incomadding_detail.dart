import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/model/firebaseGet.dart';
import 'package:finance/screens/Income.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../model/firebaseservice.dart';

class IncomeAddingDetail extends StatefulWidget {
  List<String> incomeCategoList;
  IncomeAddingDetail({Key? key, required this.incomeCategoList})
      : super(key: key);

  @override
  State<IncomeAddingDetail> createState() => _IncomeAddingDetailState();
}

class _IncomeAddingDetailState extends State<IncomeAddingDetail> {
  List<String>? getlist;
  String dropdownValue = 'Investment';
  bool submitted = false;
  List<String> incomeCategoList = [];
  final _formKey = GlobalKey<FormState>();
  TextEditingController amountcontroller = TextEditingController();
  TextEditingController? notecontroller = TextEditingController();

  @override
  void initState() {
    incomeCategoList = widget.incomeCategoList;
    print(incomeCategoList);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: DropdownButtonFormField(
                        value: dropdownValue,
                        isExpanded: true,
                        items: incomeCategoList
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
                    Container(
                      height: 50,
                      width: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return const Popupdialog();
                                  });
                            },
                            icon: const FaIcon(
                              FontAwesomeIcons.fileCirclePlus,
                              size: 35,
                            )),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Container(
                  margin: const EdgeInsets.only(top: 15),
                  width: MediaQuery.of(context).size.width - 20,
                  child: TextFormField(
                    controller: amountcontroller,
                    autovalidateMode: submitted
                        ? AutovalidateMode.always
                        : AutovalidateMode.disabled,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    validator:
                        RequiredValidator(errorText: 'Pls enter your amount'),
                    decoration: InputDecoration(
                      errorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1, color: Colors.redAccent),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1, color: Colors.black),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 2, color: Colors.black),
                          borderRadius: BorderRadius.circular(5)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 1, color: Colors.redAccent),
                          borderRadius: BorderRadius.circular(5)),
                      hintText: 'Enter amount',
                    ),
                  ),
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width - 20,
                  height: 120,
                  child: TextFormField(
                    controller: notecontroller,
                    maxLines: 7,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 30.0, horizontal: 10),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.black),
                          borderRadius: BorderRadius.circular(5)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 2, color: Colors.black),
                          borderRadius: BorderRadius.circular(5)),
                      hintText: 'Note',
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 20,
                  height: 40,
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          submitted = true;
                        });
                        print(
                            '$dropdownValue and ${int.parse(amountcontroller.text)}');

                        if (_formKey.currentState!.validate()) {
                          API().incomeadding(
                              dropdownValue, int.parse(amountcontroller.text));

                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const IncomePage(),
                            ),
                          );
                        } else {
                          print('wrong');
                        }
                      },
                      child: const Text(
                        'Add',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class Popupdialog extends StatelessWidget {
  const Popupdialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController? newcatego = TextEditingController();
    CollectionReference user = firestore.collection('${currentuser!.email}');
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.amber,
          height: 300,
          width: 300,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                width: 200,
                height: 50,
                child: TextFormField(
                  controller: newcatego,
                  autovalidateMode: AutovalidateMode.disabled,
                  validator:
                      RequiredValidator(errorText: 'Pls enter your name'),
                  decoration: InputDecoration(
                    errorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.redAccent),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.black),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 2, color: Colors.black),
                        borderRadius: BorderRadius.circular(5)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(width: 1, color: Colors.redAccent),
                        borderRadius: BorderRadius.circular(5)),
                    hintText: 'Enter name',
                  ),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  user
                      .doc('Income-catego')
                      .collection('data')
                      .doc(newcatego.text)
                      .set({'categoname': newcatego.text, 'imagId': 'job'});
                },
                child: const Text('set catego'))
          ]),
        ),
      ),
    );
  }
}
