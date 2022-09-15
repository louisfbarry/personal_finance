import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/firebaseservice.dart';

class AddSavingMoney extends StatefulWidget {
  final String title;
  final String id;
  final int addPrice;
  final int targetPrice;

  const AddSavingMoney(
      {Key? key,
      required this.title,
      required this.id,
      required this.addPrice,
      required this.targetPrice})
      : super(key: key);

  @override
  State<AddSavingMoney> createState() => _AddSavingMoneyState();
}

class _AddSavingMoneyState extends State<AddSavingMoney> {
  TextEditingController amountController = TextEditingController();

  bool _submitted = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text(
            "Add money for ${widget.title}",
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.blue[700],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 15, bottom: 10, left: 3),
                    child: Text(
                      "Amount",
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500,
                          fontSize: 12),
                    ),
                  ),
                  TextFormField(
                    autofocus: true,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: amountController,
                    autovalidateMode: _submitted
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                    keyboardType: TextInputType.number,
                    // 1/9
                    validator: (value) {
                      if (value == null || value.isEmpty || value == "0") {
                        return "Please enter amount";
                      } else if (int.parse(value) + widget.addPrice >
                          widget.targetPrice) {
                        return "Your add price is over your target price";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: "Enter Your Amount",
                      hintStyle: TextStyle(fontSize: 12),
                    ),
                  ),
                  const SizedBox(
                    height: 13,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 2.2,
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  primary: Colors.grey[700],
                                  side: const BorderSide(
                                      width: 1, color: Colors.grey)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"))),
                      SizedBox(
                          width: MediaQuery.of(context).size.width / 2.2,
                          child: ElevatedButton(
                              onPressed: () {
                                final addAmountValidate =
                                    _formKey.currentState!.validate();
                                setState(() {
                                  _submitted = true;
                                });
                                if (addAmountValidate) {
                                  API().savingPriceAdding(
                                      int.parse(amountController.text),
                                      widget.id);
                                  FirebaseFirestore.instance
                                      .collection("${FirebaseAuth.instance.currentUser!.email}")
                                      .doc("Saving")
                                      .collection("saving-data")
                                      .doc(widget.id)
                                      .update({
                                    "addPrice": widget.addPrice +
                                        int.parse(amountController.text)
                                  });
                                  Navigator.pop(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 0, primary: Colors.blue[600]),
                              child: const Text("Add")))
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
