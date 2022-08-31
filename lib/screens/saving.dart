import 'package:finance/model/firebaseservice.dart';
import 'package:finance/screens/saving_money_adding.dart';
import 'package:finance/screens/savingadding.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/firebaseservice.dart';

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
          style: TextStyle(fontSize: 15),
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Navigator.pushNamed(context, "/savingadding");
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddSaving(
                        isEdit: false,
                      )));
            },
            icon: const Icon(Icons.playlist_add),
          ),
        ],
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return SavingCard();
        },
      ),
    );
  }
}

class SavingCard extends StatelessWidget {
  const SavingCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("${currentuser!.email}")
              .doc("Saving")
              .collection("saving-data")
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            List<SavingDataCard> savingData = [];
            if (snapshot.hasData) {
              var data = snapshot.data!.docs;
              for (var savingList in data) {
                // savingData.add(Text(sd['title']));
                savingData.add(SavingDataCard(
                  title: savingList['title'],
                  targetPrice: savingList['targetPrice'],
                  addPrice: savingList['addPrice'],
                  id: savingList['id'],
                ));
              }
            }
            return SingleChildScrollView(
              child: Column(
                children: savingData,
              ),
            );
          },
        )
      ],
    );
  }
}

class SavingDataCard extends StatelessWidget {
  String title;
  int targetPrice;
  int addPrice;
  String id;
  SavingDataCard(
      {Key? key,
      required this.title,
      required this.targetPrice,
      required this.addPrice,
      required this.id})
      : super(key: key);

  void _showDialog(BuildContext context) {
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
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('${currentuser!.email}')
                              .doc("Saving")
                              .collection("saving-data")
                              .doc(id)
                              .delete();
                          FirebaseFirestore.instance
                              .collection('${currentuser!.email}')
                              .doc("Saving")
                              .collection("saving-data")
                              .doc(id)
                              .collection('add-prices')
                              .doc()
                              .delete();
                          Navigator.pop(context);
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

  void onSelected(
      BuildContext context, int item, String title, int targetPrice) {
    switch (item) {
      case 0:
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddSavingMoney(
                  title: title,
                  id: id,
                  addPrice: addPrice,
                )));
        break;
      case 1:
        // print("Clicked edit");
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AddSaving(
                  isEdit: true,
                  title: title,
                  targetPrice: targetPrice,
                  id: id,
                )));
        break;
      case 2:
        // print("Clicked delete");
        _showDialog(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/savingDetails", arguments: {
          'title': title,
          'targetPrice': targetPrice,
          'addPrice': addPrice,
          'id': id
        });
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 100,
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            "${NumberFormat.decimalPattern().format(targetPrice)} / ${NumberFormat.decimalPattern().format(addPrice)}",
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                      // Icon(Icons.more_vert)
                      // IconButton(onPressed: (){

                      // }, icon: const Icon(Icons.more_vert, size: 20,))
                      PopupMenuButton<int>(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        onSelected: (item) =>
                            onSelected(context, item, title, targetPrice),
                        itemBuilder: (context) => [
                          const PopupMenuItem<int>(
                              value: 0,
                              child: Text(
                                "Add Money",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                              )),
                          const PopupMenuItem<int>(
                              value: 1,
                              child: Text(
                                "Edit",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                              )),
                          const PopupMenuItem<int>(
                              value: 2,
                              child: Text(
                                "Delete",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.w500),
                              )),
                        ],
                        // child: Icon(Icons.more_vert),
                      ),
                    ],
                  ),
                ),
                LinearPercentIndicator(
                  // restartAnimation: true,
                  width: MediaQuery.of(context).size.width - 30,
                  animation: true,
                  animationDuration: 1000,
                  lineHeight: 15,
                  percent: addPrice / targetPrice,
                  center: Text(
                    // "80.0%",
                    "${((addPrice / targetPrice) * 100).toStringAsFixed(1)}%",
                    style: TextStyle(color: Colors.grey[800], fontSize: 10),
                  ),
                  barRadius: const Radius.circular(16),
                  progressColor: Colors.blue[400],
                  backgroundColor: Colors.grey[300],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
