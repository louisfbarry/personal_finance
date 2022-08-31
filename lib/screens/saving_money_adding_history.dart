import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:finance/model/firebaseservice.dart';
import 'package:intl/intl.dart';

class SavingHistory extends StatefulWidget {
  const SavingHistory({Key? key}) : super(key: key);
  @override
  State<SavingHistory> createState() => _SavingHistoryState();
}

class _SavingHistoryState extends State<SavingHistory> {
  var data;
  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments;
    String id = data['id'];
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
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("${currentuser!.email}")
              .doc("Saving")
              .collection('saving-data')
              .doc(id)
              .collection("add-prices")
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            List<SavingHistoryCard> savingHistoryData = [];
            if (snapshot.hasData) {
              var data = snapshot.data!.docs;
              for (var history in data) {
                savingHistoryData.add(SavingHistoryCard(
                    price: history['price'],
                    time: history['createdAt'].toDate()));
              }
            }
            return SingleChildScrollView(
              child: Column(
                children: savingHistoryData,
              ),
            );
          },
        ));
  }
}

class SavingHistoryCard extends StatelessWidget {
  int price;
  var time;
  SavingHistoryCard({
    Key? key,
    required this.price,
    required this.time,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    NumberFormat.decimalPattern().format(price),
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800]),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(DateFormat('dd-MM-yyyy').format(time),
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[700]))
                ],
              ),
              IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.delete,
                    color: Colors.grey[800],
                    size: 18,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
