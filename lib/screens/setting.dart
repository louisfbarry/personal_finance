import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.settings),
            Text("Setting"),
          ],
        ),
        automaticallyImplyLeading: false,
        elevation: 0.0,
      ),
      body: Center(
          child: Column(
        children: [
          Elevbutton(
            text: 'Language',
            icon: Icons.language_outlined,
            color: Colors.blueAccent,
            route: '',
          ),
          Elevbutton(
            text: 'Change Password',
            icon: Icons.lock,
            color: Colors.amber,
            route: '/changepassword',
          ),
          Elevbutton(
            text: 'Reset App',
            icon: Icons.warning_rounded,
            color: Colors.red,
            route: '',
          ),
          Elevbutton(
            text: 'About us',
            icon: Icons.info_outline,
            color: Colors.greenAccent,
            route: '',
          ),
        ],
      )),
    );
  }
}

class Elevbutton extends StatelessWidget {
  String text;
  IconData icon;
  Color color;
  String route;
  Elevbutton(
      {Key? key,
      required this.text,
      required this.icon,
      required this.color,
      required this.route})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        minimumSize: const Size.fromHeight(50), // NEW
      ),
      child: Container(
        padding: const EdgeInsets.only(top: 20.0, bottom: 20),
        child: Row(
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  icon,
                  color: color,
                )),
            Container(
                margin: const EdgeInsets.only(left: 10.0),
                child: Text(
                  text,
                  style: const TextStyle(
                      fontSize: 15.0, color: Colors.black, fontFamily: 'Libre'),
                ))
          ],
        ),
      ),
    );
  }
}
