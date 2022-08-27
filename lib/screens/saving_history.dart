import 'package:flutter/material.dart';

class SavingHistory extends StatefulWidget {
  const SavingHistory({Key? key}) : super(key: key);

  @override
  State<SavingHistory> createState() => _SavingHistoryState();
}

class _SavingHistoryState extends State<SavingHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Saving History",
          style: TextStyle(fontSize: 15),
        ),
        elevation: 0.0,
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
        return SavingHistoryCard();
      }),
    );
  }
}

class SavingHistoryCard extends StatelessWidget {
  const SavingHistoryCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("100000", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey[800]),),
                  const SizedBox(height: 5,),
                  Text("26-08-2022", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: Colors.grey[700]))],
              ),
              IconButton(onPressed: () {}, icon: Icon(Icons.delete, color: Colors.grey[800], size: 18,))
            ],
          ),
        ),
      ),
    );
  }
}
