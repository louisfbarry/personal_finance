import 'package:flutter/material.dart';

class AddSaving extends StatefulWidget {
  const AddSaving({Key? key}) : super(key: key);
  @override
  State<AddSaving> createState() => _AddSavingState();
}

class _AddSavingState extends State<AddSaving> {
  bool _submitted = false;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text(
            "Add Target",
            style: TextStyle(
              fontSize: 18,
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
              autovalidateMode: _submitted
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
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
                            keyboardType: TextInputType.number,
                            controller: priceController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Target price required";
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
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    _submitted = true;
                                  });
                                  print(_submitted);
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
