import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/model/firebaseservice.dart';
import 'package:finance/screens/addValue.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class Popupdialog extends StatelessWidget {
  bool isIncome;
  Popupdialog({Key? key, required this.isIncome}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController? newcatego = TextEditingController();
    CollectionReference user = firestore.collection('${currentuser!.email}');
    final _formKey = GlobalKey<FormState>();
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                width: 200,
                height: 50,
                child: TextFormField(
                  controller: newcatego,
                  autovalidateMode: AutovalidateMode.disabled,
                  validator: RequiredValidator(
                      errorText: 'Pls enter your category name'),
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
                    hintText: 'Create category name',
                  ),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  isIncome
                      ? user
                          .doc('Income-catego')
                          .collection('data')
                          .doc(newcatego.text)
                          .set({'categoname': newcatego.text, 'imagId': 'job'})
                      : user
                          .doc('Outcome-catego')
                          .collection('data')
                          .doc(newcatego.text)
                          .set(
                              {'categoname': newcatego.text, 'imagId': 'food'});

                  Navigator.pop(context);
                },
                child: const Text('set catego'))
          ]),
        ),
      ),
    );
  }
}
