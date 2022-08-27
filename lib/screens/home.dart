import 'package:finance/api/firebaseservice.dart';
import 'package:finance/screens/budget.dart';
import 'package:finance/screens/dashboard.dart';
import 'package:finance/screens/saving.dart';
import 'package:finance/screens/setting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({Key? key}) : super(key: key);

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  int currentIndex = 0;

  final screens = [Dashboard(), Saving(), Budget(), Setting()];

  void loginCheck() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
        Navigator.pushNamed(context, '/login');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  void initState() {
    loginCheck();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // body: IndexedStack(
    //   index: currentIndex,
    //   children: screens,
    // ),
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        // body: IndexedStack(
        //   index: currentIndex,
        //   children: screens,
        // ),
        body: screens[currentIndex],

        // BAR 1
        bottomNavigationBar: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: Colors.transparent,
            labelTextStyle: MaterialStateProperty.all(TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.grey[900])),
          ),
          child: NavigationBar(
            height: 60,
            backgroundColor: Color.fromRGBO(193, 214, 233, 1),
            labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
            selectedIndex: currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: "Home"),
              NavigationDestination(
                  icon: Icon(Icons.savings_outlined),
                  selectedIcon: Icon(Icons.savings),
                  label: "Saving"),
              NavigationDestination(
                  icon: Icon(Icons.money_outlined),
                  selectedIcon: Icon(Icons.money),
                  label: "Budget"),
              NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  selectedIcon: Icon(Icons.settings),
                  label: "Setting"),
            ],
          ),
        ),

        // // BAR 2
        // bottomNavigationBar: BottomNavigationBar(
        //   // backgroundColor: Colors.grey[900],
        //   // selectedItemColor: Colors.grey[100],
        //   // unselectedItemColor: Colors.grey[500],
        //   // showUnselectedLabels: false,
        //   currentIndex: currentIndex,
        //   // type: BottomNavigationBarType.fixed,
        //   onTap: (index) => setState(() {
        //     currentIndex = index;
        //   }),
        //   items: const [
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.home),
        //         label: "Home",
        //         backgroundColor: Colors.green),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.favorite),
        //         label: "Saving",
        //         backgroundColor: Colors.blue),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.chat),
        //         label: "Budget",
        //         backgroundColor: Colors.teal),
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.settings),
        //         label: "Setting",
        //         backgroundColor: Colors.red),
        //   ],
        // ),
      ),
    );
  }
}
