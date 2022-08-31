import 'package:finance/screens/saving_money_adding.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SavingDetails extends StatefulWidget {
  SavingDetails({Key? key}) : super(key: key);

  @override
  State<SavingDetails> createState() => _SavingDetailsState();
}

class _SavingDetailsState extends State<SavingDetails> {
  TextEditingController addPricesController = TextEditingController();

  // Future openDialog(String id, int addPrices) => showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //           contentPadding: const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 10.0),
  //           title: Text(
  //             "Add Money",
  //             style: TextStyle(color: Colors.grey[800], fontSize: 15),
  //           ),
  //           content: TextFormField(
  //             controller: addPricesController,
  //             autofocus: true,
  //             keyboardType: TextInputType.number,
  //             decoration: const InputDecoration(
  //               hintText: "Add amount",
  //               hintStyle: TextStyle(fontSize: 12),
  //               contentPadding: EdgeInsets.all(8),
  //               isDense: true,
  //             ),
  //           ),
  //           actions: [
  //             Row(mainAxisAlignment: MainAxisAlignment.end, children: [
  //               TextButton(
  //                   onPressed: () {
  //                     Navigator.pop(context);
  //                   },
  //                   child: Text("Cancel")),
  //               TextButton(
  //                   onPressed: () {
  //                     // Navigator.pop(context);
  //                     if (addPricesController.text.isNotEmpty) {
  //                       API().savingPriceAdding(
  //                           int.parse(addPricesController.text), id);
  //                       FirebaseFirestore.instance
  //                           .collection("lwinhtooaung267@gmail.com")
  //                           .doc("Saving")
  //                           .collection("saving-data")
  //                           .doc(id)
  //                           .update({
  //                         "addPrice":
  //                             addPrices + int.parse(addPricesController.text)
  //                       });
  //                       Navigator.pop(context);
  //                       addPricesController.clear();
  //                     }
  //                   },
  //                   child: Text("Save")),
  //             ])
  //           ],
  //         ));

  var data;

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)!.settings.arguments;

    var title = data['title'];
    int targetPrice = data['targetPrice'];
    int addPrice = data['addPrice'];
    int reamainingPrice = targetPrice - addPrice;
    String id = data['id'];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Saving Details",
          style: TextStyle(fontSize: 15),
        ),
        elevation: 0.0,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/savingHistory",
                    arguments: {'id': id});
              },
              icon: const Icon(Icons.history))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // backgroundColor: Colors.blue.shade400,
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          // openDialog(id, addPrice);
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => AddSavingMoney(
                    title: title,
                    id: id,
                    addPrice: addPrice,
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
                    "Target name : ",
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
                    "Target price : ",
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
                    "Reamaining : ",
                    style: TextStyle(
                        color: Colors.red[300],
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                  Text(NumberFormat.decimalPattern().format(reamainingPrice),
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
