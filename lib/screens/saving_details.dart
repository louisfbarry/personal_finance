import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SavingDetails extends StatefulWidget {
  SavingDetails({Key? key}) : super(key: key);

  @override
  State<SavingDetails> createState() => _SavingDetailsState();
}

class _SavingDetailsState extends State<SavingDetails> {
  Future openDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            contentPadding: const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 10.0),
            title: Text(
              "Add Money",
              style: TextStyle(color: Colors.grey[800], fontSize: 15),
            ),
            content: TextFormField(
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: "Add amount",
                hintStyle: TextStyle(fontSize: 12),
                contentPadding: EdgeInsets.all(8),
                isDense: true,
              ),
            ),
            actions: [
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Save")),
              ])
            ],
          ));

  @override
  Widget build(BuildContext context) {
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
                Navigator.pushNamed(context, "/savingHistory");
              },
              icon: const Icon(Icons.history))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // backgroundColor: Colors.blue.shade400,
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          openDialog();
        },
        child: Icon(Icons.add),
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
                percent: 0.8,
                center: Text(
                  "80%",
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
            Text("100000 / 80000",
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
                    "Smart Tv",
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
              padding: EdgeInsets.symmetric(horizontal: 15),
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
                    "200000",
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
              padding: EdgeInsets.symmetric(horizontal: 15),
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
                  Text("20000",
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
