import 'package:finance/model/firebaseservice.dart';
import 'package:finance/screens/saving_details.dart';
import 'package:finance/screens/saving_money_adding.dart';
import 'package:finance/screens/savingadding.dart';
import 'package:finance/screens/savingediting.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/firebaseservice.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

class Saving extends StatefulWidget {
  const Saving({Key? key}) : super(key: key);
  @override
  State<Saving> createState() => _SavingState();
}

class _SavingState extends State<Saving> {
  // Future<List> incomevalue() async {
  //   List<int> list = [0];
  //   await user
  //       .doc('Income')
  //       .collection('income-data')
  //       .orderBy('created At')
  //       .get()
  //       .then((snapshot) {
  //     snapshot.docs.map((DocumentSnapshot document) {
  //       Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

  //       list.add(data['amount']);
  //     }).toList();
  //   });
  //   print(list);
  //   return list;
  // }

  // Future<List> savingtotal() async {
  //   List<int> list = [0];

  //   await FirebaseFirestore.instance
  //       .collection("${currentuser!.email}")
  //       .doc("Saving")
  //       .collection("saving-data")
  //       .get()
  //       .then((snapshot) {
  //     snapshot.docs.map((DocumentSnapshot document) {
  //       Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
  //       list.add(data['addPrice']);
  //     }).toList();
  //   });
  //   print(list);
  //   return list;
  // }

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
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       // Navigator.pushNamed(context, "/savingadding");
        //       Navigator.of(context).push(MaterialPageRoute(
        //           builder: (context) => const AddSaving(
        //                 isEdit: false,
        //               )));
        //     },
        //     icon: const Icon(Icons.playlist_add),
        //   ),
        // ],
        automaticallyImplyLeading: false,
        elevation: 0.0,
        backgroundColor: Colors.blue[700],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("${FirebaseAuth.instance.currentUser!.email}")
            .doc("Saving")
            .collection("saving-data")
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List<SavingDataCard> savingData = [];
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            // #edit
            // return const Center(child: CircularProgressIndicator());
            return const SpinKitPulse(
              color: Colors.grey,
            );
          } else if (snapshot.hasData) {
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
            return SingleChildScrollView(
              child: Column(
                children: (savingData.isEmpty)
                    ? [
                        const SizedBox(
                          height: 30,
                        ),
                        Center(
                            child: Text(
                          "No saving has been added.",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500),
                        ))
                      ]
                    : savingData,
              ),
            );
          }
          // #edit
          return Container();
        },
      ),
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
                        // 1/9
                        onPressed: () async {
                          var savingAddPricePath = FirebaseFirestore.instance
                              .collection(
                                  '${FirebaseAuth.instance.currentUser!.email}')
                              .doc("Saving")
                              .collection("saving-data")
                              .doc(id)
                              .collection('add-prices');
                          await savingAddPricePath.get().then((data) {
                            data.docs.forEach((element) {
                              savingAddPricePath.doc(element.id).delete();
                            });
                          });
                          await FirebaseFirestore.instance
                              .collection(
                                  '${FirebaseAuth.instance.currentUser!.email}')
                              .doc("Saving")
                              .collection("saving-data")
                              .doc(id)
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
                  targetPrice: targetPrice,
                )));
        break;
      case 1:
        // print("Clicked edit");
        // edit
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EditSaving(
                  isEdit: true,
                  title: title,
                  targetPrice: targetPrice,
                  addPrice: addPrice,
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
      // 1/9
      onTap: () {
        // Navigator.pushNamed(context, "/savingDetails", arguments: {
        //   'title': title,
        //   'targetPrice': targetPrice,
        //   'addPrice': addPrice,
        //   'id': id
        // }
        // );
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => SavingDetails(
                  id: id,
                )));
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
