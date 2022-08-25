import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class IncomePage extends StatefulWidget {
  const IncomePage({Key? key}) : super(key: key);

  @override
  State<IncomePage> createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Income')),
      bottomNavigationBar: BottomAppBar(
          elevation: 5,
          child: InkWell(
            onTap: () {},
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
              color: Colors.amber,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.4,
            ),
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

class Choice {
  const Choice({required this.title, required this.icon, required this.color});
  final String title;
  final IconData icon;
  final Color color;
}

List<Choice> choices = <Choice>[
  const Choice(title: 'Salary', icon: Icons.home, color: Colors.green),
  const Choice(
      title: 'Investment',
      icon: Icons.contacts,
      color: Color.fromARGB(255, 253, 239, 150)),
  const Choice(
      title: 'Part-Time',
      icon: Icons.map,
      color: Color.fromARGB(255, 163, 86, 56)),
  const Choice(
      title: 'Uncategorized',
      icon: Icons.unarchive_outlined,
      color: Color.fromARGB(255, 56, 62, 86)),
];

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
