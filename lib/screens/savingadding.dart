import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/firebaseservice.dart';

class AddSaving extends StatefulWidget {
  final bool isEdit;
  final String? title;
  final int? targetPrice;
  final String? id;
  final int? addPrice;
  const AddSaving(
      {Key? key,
      required this.isEdit,
      this.title,
      this.targetPrice,
      this.id,
      this.addPrice})
      : super(key: key);
  @override
  State<AddSaving> createState() => _AddSavingState();
}

class _AddSavingState extends State<AddSaving> {
  bool _submitted = false;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  getOldValue() {
    if (widget.isEdit == true) {
      titleController = TextEditingController(text: widget.title);
      priceController =
          TextEditingController(text: widget.targetPrice.toString());
    } else {
      titleController = TextEditingController();
      priceController = TextEditingController();
    }
  }

  @override
  void initState() {
    getOldValue();
    // titleController = new TextEditingController(text: "ok");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: widget.isEdit
              ? const Text(
                  "Edit Target",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                )
              : const Text(
                  "Add Target",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.blueAccent,
        ),
        body: DefaultTextStyle(
            style: TextStyle(color: Colors.grey[900]),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 40,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5, left: 3),
                            child: Text(
                              "Title",
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          TextFormField(
                            // initialValue: "Tv",
                            autovalidateMode: _submitted
                                ? AutovalidateMode.onUserInteraction
                                : AutovalidateMode.disabled,
                            controller: titleController,
                            // style: TextStyle(color: Colors.grey[800]),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Title required";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: "Enter your title",
                              hintStyle: const TextStyle(fontSize: 12),
                              labelStyle: TextStyle(color: Colors.grey[800]),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15, bottom: 5, left: 3),
                            child: Text(
                              "Target Price",
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12),
                            ),
                          ),
                          TextFormField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            autovalidateMode: _submitted
                                ? AutovalidateMode.onUserInteraction
                                : AutovalidateMode.disabled,
                            keyboardType: TextInputType.number,
                            controller: priceController,
                            // 1/9
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Target price required";
                              } else if (value == "0") {
                                return "Please enter price";
                              } else if (widget.isEdit == true &&
                                  widget.addPrice! > int.parse(value)) {
                                return "Your target price is less than your added price";
                              }
                              return null;
                            },
                            decoration: const InputDecoration(
                              hintText: "Enter your price",
                              hintStyle: TextStyle(fontSize: 12),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 45,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    elevation: 0, primary: Colors.blueAccent),
                                onPressed: () {
                                  final savingValidate =
                                      _formKey.currentState!.validate();
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    _submitted = true;
                                  });

                                  if (savingValidate) {
                                    // 1/9
                                    if (widget.isEdit == true) {
                                      if (widget.addPrice! >
                                          int.parse(priceController.text)) {
                                        print(
                                            "Your add price is over your target price");
                                      } else {
                                        API().updateSaving(
                                            "${widget.id}",
                                            titleController.text,
                                            int.parse(priceController.text));
                                        Navigator.pop(context);
                                      }
                                    } else {
                                      API().savingadding(titleController.text,
                                          int.parse(priceController.text), 0);
                                      // Navigator.pushReplacementNamed(
                                      //     context, "/saving");
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                                child: (isLoading)
                                    ? const SizedBox(
                                        width: 15,
                                        height: 15,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ))
                                    : const Text("Save")),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
