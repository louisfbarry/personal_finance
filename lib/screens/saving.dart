import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

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
              Navigator.pushNamed(context, "/savingadding");
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

  void onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        print("Clicked edit");
        break;
      case 1:
        print("Clicked delete");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/savingDetails");
      },
      child: Padding(
        padding: const EdgeInsets.all(6.0),
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
                            "Smart Tv",
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[700],
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            "100000/80000",
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
                          borderRadius: BorderRadius.circular(8)
                        ),
                          onSelected: (item) => onSelected(context, item),
                          itemBuilder: (context) => [
                                PopupMenuItem<int>(
                                    value: 0, child: Text("Edit", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),)),
                                PopupMenuItem<int>(
                                    value: 1, child: Text("Delete", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),)),
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
                  percent: 0.8,
                  center: Text(
                    "80.0%",
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
