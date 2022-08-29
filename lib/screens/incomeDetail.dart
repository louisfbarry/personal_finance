import 'package:finance/api/math.dart';
import 'package:finance/screens/Income.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../api/firebaseservice.dart';

class IncomeAdding extends StatefulWidget {
  const IncomeAdding({Key? key}) : super(key: key);

  @override
  State<IncomeAdding> createState() => _IncomeAddingState();
}

class _IncomeAddingState extends State<IncomeAdding> {
  TextEditingController amountcontroller = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  var dropdownValue = 'Investment';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Form(
        key: _formKey,
        child: Container(
          color: Colors.blue,
          height: 200,
          width: 200,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: amountcontroller,
                validator:
                    RequiredValidator(errorText: 'Pls enter your amount'),
              ),
              DropdownButton(
                value: dropdownValue,
                underline: const SizedBox(),
                items: const [
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
                      API().incomeadding(
                          dropdownValue, double.parse(amountcontroller.text));
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => const IncomePage(),
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
      )),
    );
  }
}
