import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/components/incomenewcatego.dart';
import 'package:finance/screens/incomecatego_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../model/firebaseservice.dart';
class IncomeAddingDetail extends StatefulWidget {
  IncomeAddingDetail({
    Key? key,
  }) : super(key: key);
  @override
  State<IncomeAddingDetail> createState() => _IncomeAddingDetailState();
}
class _IncomeAddingDetailState extends State<IncomeAddingDetail> {
  // List<String>? getlist;
  Map<String, dynamic>? data;
  String dropdownValue = 'Salary';
  bool submitted = false;
  List<String> incomeCategoList = [];
  List<String> incomeCategoImgList = [];
  final _formKey = GlobalKey<FormState>();
  TextEditingController amountcontroller = TextEditingController();
  TextEditingController notecontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: firestore
          .collection('${FirebaseAuth.instance.currentUser!.email}')
          .doc('Income-catego')
          .collection('data')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              SpinKitPulse(
                color: Colors.grey,
              )
            ],
          );
        }
        if (snapshot.hasData) {
          incomeCategoList = [];
          incomeCategoImgList = [];
          // print(snapshot.data!.docs);
          for (var element in snapshot.data!.docs) {
            data = element.data() as Map<String, dynamic>;
            incomeCategoList.add(data!['categoname']);
            incomeCategoImgList.add(data!['imagId']);
          }
        }
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
                                                    'images/${incomeCategoImgList[incomeCategoList.indexOf(item)]}.png')),
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
                            // decoration: InputDecoration(
                            //     enabledBorder: OutlineInputBorder(
                            //         borderSide: const BorderSide(
                            //             width: 1, color: Colors.black),
                            //         borderRadius: BorderRadius.circular(5)),
                            //     focusedBorder: OutlineInputBorder(
                            //         borderSide: const BorderSide(
                            //             width: 2, color: Colors.black),
                            //         borderRadius: BorderRadius.circular(5))),
                          
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
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
                                              0.8,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          )),
                                      child: IncomeCategoCreate());
                                });
                          },
                          child: Container(
                            height: 45,
                            width: 40,
                            child: const Image(
                                image: AssetImage('images/addfile.png')),
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
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                        validator: RequiredValidator(
                            errorText: 'Pls enter your amount'),
                        // decoration: InputDecoration(
                        //   errorBorder: OutlineInputBorder(
                        //     borderSide: const BorderSide(
                        //         width: 1, color: Colors.redAccent),
                        //     borderRadius: BorderRadius.circular(5.0),
                        //   ),
                        //   enabledBorder: OutlineInputBorder(
                        //     borderSide:
                        //         const BorderSide(width: 1, color: Colors.black),
                        //     borderRadius: BorderRadius.circular(5.0),
                        //   ),
                        //   focusedBorder: OutlineInputBorder(
                        //       borderSide: const BorderSide(
                        //           width: 2, color: Colors.black),
                        //       borderRadius: BorderRadius.circular(5)),
                        //   focusedErrorBorder: OutlineInputBorder(
                        //       borderSide: const BorderSide(
                        //           width: 1, color: Colors.redAccent),
                        //       borderRadius: BorderRadius.circular(5)),
                        //   hintText: 'Enter amount',
                        // ),
                        decoration: InputDecoration(
                              hintText: "Enter amount",
                              hintStyle: const TextStyle(fontSize: 13),
                              labelStyle: TextStyle(color: Colors.grey[800]),
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
                        // decoration: InputDecoration(
                        //   contentPadding: const EdgeInsets.symmetric(
                        //       vertical: 30.0, horizontal: 10),
                        //   enabledBorder: OutlineInputBorder(
                        //       borderSide: const BorderSide(
                        //           width: 1, color: Colors.black),
                        //       borderRadius: BorderRadius.circular(5)),
                        //   focusedBorder: OutlineInputBorder(
                        //       borderSide: const BorderSide(
                        //           width: 2, color: Colors.black),
                        //       borderRadius: BorderRadius.circular(5)),
                        //   hintText: 'Note',
                        // ),
                        decoration: InputDecoration(
                              hintText: "Note",
                              hintStyle: const TextStyle(fontSize: 13),
                              labelStyle: TextStyle(color: Colors.grey[800]),
                            ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 20,
                      height: 40,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 0, primary: Colors.blue[700]),
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
                                  builder: (BuildContext context) =>
                                      IncomeCategodetail(),
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
      },
    );
  }
}