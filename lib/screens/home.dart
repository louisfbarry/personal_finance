import 'package:finance/model/firebaseservice.dart';
import 'package:finance/screens/addValue.dart';
import 'package:finance/screens/dashboard.dart';
import 'package:finance/screens/setting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:finance/provider/locale_provider.dart';
import 'package:provider/provider.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({Key? key}) : super(key: key);

  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  int currentIndex = 0;

  final screens = [const Dashboard(), const Setting()];

  bool ishome = true;
  void loginCheck() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
        Navigator.pushNamedAndRemoveUntil(
            context, "/register", (route) => false);
      } else {
        print('User is signed in!');
      }
    });
  }

  checkLang() async {
    final prefs = await SharedPreferences.getInstance();
    final int? lang = prefs.getInt('language');
    if (lang == 2) {
      // ignore: use_build_context_synchronously
      final provider = Provider.of<LocaleProvider>(context, listen: false);
      provider.setLocale(Locale('my'));
    } else {
      // ignore: use_build_context_synchronously
      final provider = Provider.of<LocaleProvider>(context, listen: false);
      provider.setLocale(Locale('en'));
    }
  }

  @override
  void initState() {
    checkLang();
    loginCheck();
    API().addCollection();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        body: screens[currentIndex],
        floatingActionButton: FloatingActionButton(
          // elevation: 0,
          onPressed: () {
            showModalBottomSheet(
                backgroundColor: Colors.transparent,
                barrierColor: Colors.transparent,
                context: context,
                enableDrag: true,
                isScrollControlled: true,
                builder: (_) {
                  return Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        )),
                    child: const AddValue(),
                  );
                });
          },
          backgroundColor: Colors.blue[700],
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          color: Colors.blue[700],
          shape: const CircularNotchedRectangle(),
          notchMargin: 4,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width * 0.47,
                child: GestureDetector(
                    onTap: ishome
                        ? () {}
                        : () {
                            setState(() {
                              currentIndex = 0;
                              ishome = true;
                            });
                          },
                    child: ishome
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                FontAwesomeIcons.house,
                                color: Colors.black,
                              ),
                              Text(
                                'Home',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              )
                            ],
                          )
                        : const Icon(FontAwesomeIcons.house)),
              ),
              SizedBox(
                height: 60,
                width: MediaQuery.of(context).size.width * 0.47,
                child: GestureDetector(
                    onTap: ishome
                        ? () {
                            setState(() {
                              currentIndex = 1;
                              ishome = false;
                            });
                          }
                        : () {},
                    child: ishome
                        ? const Icon(
                            FontAwesomeIcons.gear,
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                FontAwesomeIcons.gear,
                                color: Colors.black,
                              ),
                              Text(
                                'Setting',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              )
                            ],
                          )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}