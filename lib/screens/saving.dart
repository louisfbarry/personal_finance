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
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Saving",
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, "/savingadding");
            },
            icon: const Icon(Icons.playlist_add),
          ),
        ],
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: Colors.blueAccent,
      ),
      body: const Center(child: Text("Saving")),
    );
  }
}
