import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:finance/model/firebaseservice.dart';
import 'package:intl/intl.dart';

// 1/9

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
                  time: history['createdAt'].toDate(),
                  historyId: history['id'],
                  id: id,
                  // totalAddPrice: totalAddPrice,
                ));
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

class SavingHistoryCard extends StatefulWidget {
  int price;
  var time;
  String historyId;
  String id;
  SavingHistoryCard({
    Key? key,
    required this.price,
    required this.time,
    required this.historyId,
    required this.id,
  }) : super(key: key);

  @override
  State<SavingHistoryCard> createState() => _SavingHistoryCardState();
}

class _SavingHistoryCardState extends State<SavingHistoryCard> {
  void _showDialog(BuildContext context, int totalPrice, int deletePrice) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.only(left: 10, top: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Do you want to delete ?",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "cancel",
                          style: TextStyle(fontSize: 12),
                        )),
                    TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await FirebaseFirestore.instance
                              .collection('${currentuser!.email}')
                              .doc("Saving")
                              .collection("saving-data")
                              .doc(widget.id)
                              .update({"addPrice": totalPrice - deletePrice});
                          getTotalValue();
                          await FirebaseFirestore.instance
                              .collection('${currentuser!.email}')
                              .doc("Saving")
                              .collection("saving-data")
                              .doc(widget.id)
                              .collection('add-prices')
                              .doc(widget.historyId)
                              .delete();
                        },
                        child: const Text(
                          "delete",
                          style: TextStyle(fontSize: 12),
                        )),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // ignore: prefer_typing_uninitialized_variables
  late var totalAddPrice;

  void getTotalValue() async {
    await for (var snapshot in FirebaseFirestore.instance
        .collection("${currentuser!.email}")
        .doc("Saving")
        .collection("saving-data")
        .doc(widget.id)
        .snapshots()) {
      totalAddPrice = snapshot.data()!['addPrice'];
    }
  }

  @override
  void initState() {
    getTotalValue();
    super.initState();
  }

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
                    NumberFormat.decimalPattern().format(widget.price),
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800]),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(DateFormat('dd-MM-yyyy').format(widget.time),
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[700]))
                ],
              ),
              IconButton(
                  onPressed: () {
                    // getTotalValue();
                    _showDialog(context, totalAddPrice, widget.price);
                  },
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
