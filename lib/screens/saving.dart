import 'package:flutter/material.dart';

class Saving extends StatefulWidget {
  const Saving({Key? key}) : super(key: key);

  @override
  State<Saving> createState() => _SavingState();
}

class _SavingState extends State<Saving> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saving"),
        automaticallyImplyLeading: false,
        elevation: 0.0,
      ),
      body: Center(
        child : Text("Saving")
      ),
    );
  }
}
