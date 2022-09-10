import 'package:finance/components/newcategocreate.dart';
import 'package:finance/screens/incomecatego_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../model/firebaseservice.dart';

class IncomeAddingDetail extends StatefulWidget {
  List<String> incomeCategoList;
  List<String> incomeCategoImgList;
  IncomeAddingDetail(
      {Key? key,
      required this.incomeCategoList,
      required this.incomeCategoImgList})
      : super(key: key);

  @override
  State<IncomeAddingDetail> createState() => _IncomeAddingDetailState();
}

class _IncomeAddingDetailState extends State<IncomeAddingDetail> {
  // List<String>? getlist;
  String dropdownValue = 'Investment';
  bool submitted = false;
  List<String> incomeCategoList = [];
  final _formKey = GlobalKey<FormState>();
  TextEditingController amountcontroller = TextEditingController();
  TextEditingController notecontroller = TextEditingController();

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
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: Image(
                                            image: AssetImage(
                                                'images/Income/${widget.incomeCategoImgList[incomeCategoList.indexOf(item)]}.png')),
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
                    Container(
                      height: 50,
                      width: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  backgroundColor: Colors.transparent,
                                  barrierColor: Colors.transparent,
                                  context: context,
                                  enableDrag: true,
                                  isScrollControlled: true,
                                  builder: (_) {
                                    return Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.6,
                                      decoration: const BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 194, 237, 255),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          )),
                                      child: Popupdialog(
                                        isIncome: true,
                                      ),
                                    );
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
                              dropdownValue,
                              int.parse(amountcontroller.text),
                              notecontroller.text);
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => CategoDetail(
                                userstream: incomeStream,
                              ),
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
