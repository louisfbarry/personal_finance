import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/screens/saving_money_adding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SavingDetails extends StatefulWidget {
  String id;
  SavingDetails({Key? key, required this.id}) : super(key: key);

  @override
  State<SavingDetails> createState() => _SavingDetailsState();
}

class _SavingDetailsState extends State<SavingDetails> {
  TextEditingController addPricesController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.savingDetails,
          style: TextStyle(fontSize: 15),
        ),
        elevation: 0.0,
        backgroundColor: Colors.blue[700],
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/savingHistory",
                    arguments: {'id': widget.id});
              },
              icon: const Icon(Icons.history))
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   // backgroundColor: Colors.blue.shade400,
      //   backgroundColor: Colors.blueAccent,
      //   onPressed: () {
      //     // openDialog(id, addPrice);
      //     Navigator.of(context).push(MaterialPageRoute(
      //         builder: (context) => AddSavingMoney(
      //               title: title,
      //               id: id,
      //               addPrice: addPrice,
      //               targetPrice: targetPrice,
      //             )));
      //   },
      //   child: const Icon(Icons.add),
      // ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("${FirebaseAuth.instance.currentUser!.email}")
            .doc("Saving")
            .collection("saving-data")
            // .doc(widget.id)
            .where('id', isEqualTo: widget.id)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          List detailsData = [];
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            // return const Center(child: CircularProgressIndicator());
            return const SpinKitPulse(
              color: Colors.grey,
            );
          } else if (snapshot.hasData) {
            // print("have");
            // print(snapshot.data);
            var docss = snapshot.data!.docs;
            var details = docss[0].data()!;
            detailsData.add(docss[0].data());
            // return Text(widgeet[0]['title']);
            return DetailsUi(
                id: detailsData[0]['id'],
                title: detailsData[0]['title'],
                addPrice: detailsData[0]['addPrice'],
                targetPrice: detailsData[0]['targetPrice']);
          }
          // return const Center(child: CircularProgressIndicator());
          // #edit
          return Container();
        },
      ),
      
    );
  }
}

class DetailsUi extends StatelessWidget {
  String id;
  String title;
  int addPrice;
  int targetPrice;
  DetailsUi(
      {Key? key,
      required this.id,
      required this.title,
      required this.addPrice,
      required this.targetPrice})
      : super(key: key);

  @override
  Widget build(BuildContext context) { 
           
      return Scaffold(
        floatingActionButton: FloatingActionButton(
        // backgroundColor: Colors.blue.shade400,
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          // openDialog(id, addPrice);
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddSavingMoney(
                    title: title,
                    id: id,
                    addPrice: addPrice,
                    targetPrice: targetPrice,
                  )));
        },
        child: const Icon(Icons.add),
      ),
        body: SingleChildScrollView(
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 30,
              ),
              Center(
                child: CircularPercentIndicator(
                  animation: true,
                  animationDuration: 1300,
                  radius: 70.0,
                  lineWidth: 20.0,
                  percent: addPrice / targetPrice,
                  center: Text(
                    "${((addPrice / targetPrice) * 100).toStringAsFixed(1)}%",
                    style: TextStyle(
                        color: Colors.grey[700], fontWeight: FontWeight.w500),
                  ),
                  progressColor: Colors.blue.shade300,
                  backgroundColor: Colors.red.shade300,
                  circularStrokeCap: CircularStrokeCap.round,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                  "${NumberFormat.decimalPattern().format(targetPrice)} / ${NumberFormat.decimalPattern().format(addPrice)}",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  )),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(
                  thickness: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.targetName,
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      title,
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(
                  thickness: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.targetPrice,
                      style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      NumberFormat.decimalPattern().format(targetPrice),
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(
                  thickness: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.reamaining,
                      style: TextStyle(
                          color: Colors.red[300],
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                        NumberFormat.decimalPattern()
                            .format(targetPrice - addPrice),
                        style: TextStyle(
                            color: Colors.red[300],
                            fontSize: 12,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}
