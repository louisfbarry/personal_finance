import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/api/math.dart';
import 'package:finance/screens/incomeDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../api/firebaseservice.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  CollectionReference user = firestore.collection('${currentuser!.email}');
  final Stream<QuerySnapshot> _investStream = firestore
      .collection('${currentuser!.email}')
      .doc('Income')
      .collection('Investment')
      .snapshots();
  final Stream<QuerySnapshot> _salaryStream = firestore
      .collection('${currentuser!.email}')
      .doc('Income')
      .collection('Salary')
      .snapshots();

  double total = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Income')),
      bottomNavigationBar: BottomAppBar(
          elevation: 5,
          child: InkWell(
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const IncomeAdding(),
                ),
              );
            },
            child: Container(
              color: Colors.greenAccent,
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Add income',
                      style:
                          TextStyle(color: Colors.black, fontFamily: "Libre"),
                    )
                  ]),
            ),
          )),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
                color: Color.fromARGB(142, 33, 149, 243),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.4,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          categoValue(_investStream, 'Investment'),
                          Container(
                            color: Colors.green,
                            height: 100,
                            width: 200,
                            child: StreamBuilder<QuerySnapshot>(
                              stream: _salaryStream,
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snapshot) {
                                total = 0;
                                value = [];
                                if (snapshot.hasError) {
                                  return const Text('Something went wrong');
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text("Loading");
                                }

                                if (snapshot.hasData) {
                                  snapshot.data!.docs
                                      .map((DocumentSnapshot document) {
                                    Map<String, dynamic> data = document.data()!
                                        as Map<String, dynamic>;
                                    total += data['amount'];
                                    value.add(data['amount']);
                                    print(total);
                                  }).toList();
                                }
                                print(value);
                                return Text('$total');
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.5,
              // color: Colors.amber,
              child: GridView.count(
                  primary: false,
                  crossAxisCount: 3,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: List.generate(choices.length, (index) {
                    return Center(
                      child: SelectCard(choice: choices[index]),
                    );
                  })),
            )
          ],
        ),
      )),
    );
  }
}

class SelectCard extends StatelessWidget {
  const SelectCard({Key? key, required this.choice}) : super(key: key);
  final Choice choice;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 7,
        color: choice.color,
        child: Center(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                    child: Icon(choice.icon, size: 40.0, color: Colors.black)),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    choice.title,
                    style: const TextStyle(fontFamily: 'Libre', fontSize: 12),
                  ),
                ),
              ]),
        ));
  }
}
