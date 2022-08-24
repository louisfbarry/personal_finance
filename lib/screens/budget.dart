import 'package:flutter/material.dart';

class Budget extends StatefulWidget {
  const Budget({Key? key}) : super(key: key);

  @override
  State<Budget> createState() => _BudgetState();
}

class _BudgetState extends State<Budget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Budget"),
        automaticallyImplyLeading: false,
        elevation: 0.0,
      ),
      body: Center(
        child : Text("Budget")
      ),
    );
  }
}
