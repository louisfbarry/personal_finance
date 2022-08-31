import 'package:finance/model/firebaseGet.dart';
import 'package:finance/screens/Income.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../model/firebaseservice.dart';

class AddValue extends StatefulWidget {
  const AddValue({Key? key}) : super(key: key);

  @override
  State<AddValue> createState() => _AddValueState();
}

class _AddValueState extends State<AddValue> {
  TextEditingController amountcontroller = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var dropdownValue = 'Investment';
  var outcomedropdownValue = 'Food';
  bool isOutcome = false;

  void IsOutcome() {
    setState(() {
      isOutcome = !isOutcome;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        style: (isOutcome == false)
                            ? ElevatedButton.styleFrom(
                                primary: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 100, vertical: 20),
                              )
                            : ElevatedButton.styleFrom(
                                primary: Colors.transparent,
                                shadowColor: Colors.transparent),
                        onPressed: (isOutcome == true)
                            ? () {
                                setState(() {
                                  IsOutcome();
                                });
                              }
                            : () {},
                        child: Text(
                          "Income",
                          style: (isOutcome == true)
                              ? const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)
                              : const TextStyle(
                                  color: Color.fromARGB(255, 14, 206, 20),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                        )),
                    const SizedBox(
                      width: 5,
                    ),
                    ElevatedButton(
                        style: (isOutcome == true)
                            ? ElevatedButton.styleFrom(
                                primary: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 100, vertical: 20),
                              )
                            : ElevatedButton.styleFrom(
                                primary: Colors.transparent,
                                shadowColor: Colors.transparent),
                        onPressed: (isOutcome == false)
                            ? () {
                                setState(() {
                                  IsOutcome();
                                });
                              }
                            : () {},
                        child: Text(
                          "Outcome",
                          style: (isOutcome == false)
                              ? const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)
                              : const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                        )),
                  ]),
            ),
            Container(
              color: Colors.blue,
              height: 200,
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: amountcontroller,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    validator:
                        RequiredValidator(errorText: 'Pls enter your amount'),
                  ),
                  DropdownButton(
                    value: isOutcome ? outcomedropdownValue : dropdownValue,
                    underline: const SizedBox(),
                    items: isOutcome
                        ? const [
                            DropdownMenuItem(
                              value: 'Food',
                              child: Text(
                                '   Food',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'Car',
                              child: Text(
                                '   Car',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'Bill',
                              child: Text(
                                '   Bill',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ]
                        : const [
                            DropdownMenuItem(
                              value: 'Investment',
                              child: Text(
                                '   Investment',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'Salary',
                              child: Text(
                                '   Salary',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            DropdownMenuItem(
                              value: 'Uncategorized',
                              child: Text(
                                '   Uncategorized',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                    onChanged: (newValue) {
                      setState(() {
                        dropdownValue = newValue.toString();
                      });
                    },
                  ),
                  ElevatedButton(
                      onPressed: () {
                        print('$dropdownValue and ${amountcontroller.text}');

                        if (_formKey.currentState!.validate()) {
                          (isOutcome)
                              ? API().outcomeadding(dropdownValue,
                                  double.parse(amountcontroller.text))
                              : API().incomeadding(dropdownValue,
                                  double.parse(amountcontroller.text));

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
                      child: const Text('add'))
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
