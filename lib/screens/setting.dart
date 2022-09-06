import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/screens/security.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/snackbar.dart';
import '../model/firebaseservice.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  TextEditingController securityController = TextEditingController();

  void _showDialog(
      BuildContext context, String title, String button, Function fun) {
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
                  title,
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
                        onPressed: () {
                          fun();
                          // Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: Text(
                          button,
                          style: const TextStyle(fontSize: 12),
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

  void _securityDialog(BuildContext context) {
    securityController.clear();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.only(left: 10, top: 10, right: 10),
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
                  "Security",
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                    controller: securityController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: "Enter your password",
                      hintStyle: TextStyle(fontSize: 12),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 8,
                      ),
                      isDense: true,
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Cancel",
                          style: TextStyle(fontSize: 12),
                        )),
                    TextButton(
                        // 1/9
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          final String? password = prefs.getString('password');
                          // print(password);
                          if (securityController.text == password) {
                            Navigator.pop(context);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const Security()));
                          } else {
                            // ignore: use_build_context_synchronously
                            showSnackbar(context, "Invalid password", 2,
                                Colors.red[300]);
                            Navigator.pop(context);
                          }

                          securityController.clear();
                        },
                        child: const Text(
                          "Enter",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                "Setting",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800]),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                _securityDialog(context);
              },
              child: settingButton(
                  "Security",
                  const Icon(
                    Icons.lock,
                    color: Colors.green,
                  )),
            ),
            Divider(
              color: Colors.grey[300],
              thickness: 0.5,
            ),
            InkWell(
              onTap: () {
                print("Language");
              },
              child: settingButton(
                  "Language",
                  const Icon(
                    Icons.language,
                    color: Colors.blue,
                  )),
            ),
            Divider(
              color: Colors.grey[300],
              thickness: 0.5,
            ),
            InkWell(
              onTap: () {
                _showDialog(context, "Do you want to reset app ?", "reset",
                    () async {
                  // saving delete path
                  var savingDeletePath = FirebaseFirestore.instance
                      .collection("${currentuser!.email}")
                      .doc("Saving")
                      .collection('saving-data');

                  // delete saving add-price
                  savingDeletePath.get().then((value) {
                    value.docs.forEach((element) {
                      savingDeletePath
                          .doc(element.id)
                          .collection("add-prices")
                          .get()
                          .then((value2) {
                        value2.docs.forEach((element2) {
                          savingDeletePath
                              .doc(element.id)
                              .collection('add-prices')
                              .doc(element2.id)
                              .delete();
                          // .then((value) => print("success"));
                        });
                      });
                    });
                  });

                  // delete saving data
                  savingDeletePath.get().then((value) {
                    value.docs.forEach((element) {
                      savingDeletePath.doc(element.id).delete();
                    });
                  });

                  // income path
                  var incomeDeletePath = FirebaseFirestore.instance
                      .collection("${currentuser!.email}")
                      .doc("Income")
                      .collection('income-data');

                  // delete income data
                  incomeDeletePath.get().then((value) {
                    value.docs.forEach((element) {
                      incomeDeletePath.doc(element.id).delete();
                    });
                  });

                  // outcome path
                  var outcomeDeletePath = FirebaseFirestore.instance
                      .collection("${currentuser!.email}")
                      .doc("Outcome")
                      .collection('outcome-data');

                  // delete outcome data
                  outcomeDeletePath.get().then((value) {
                    value.docs.forEach((element) {
                      outcomeDeletePath.doc(element.id).delete();
                    });
                  });

                  Navigator.pop(context);

                  //last
                });
              },
              child: settingButton("Reset App",
                  const Icon(Icons.restart_alt, color: Colors.orange)),
            ),
            Divider(
              color: Colors.grey[300],
              thickness: 0.5,
            ),
            InkWell(
                onTap: () {
                  _showDialog(context, "Do you want to logout ?", "logout",
                      () async {
                    print("logout");
                    await FirebaseAuth.instance.signOut();
                  });
                },
                child: settingButton(
                    "Logout",
                    const Icon(
                      Icons.logout,
                      color: Colors.red,
                    ))),
            Divider(
              color: Colors.grey[300],
              thickness: 0.5,
            )
          ],
        ),
      ),
    );
  }
}

Widget settingButton(text, icon) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(children: [
          // Icon( , color: color,),
          icon,
          const SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: const TextStyle(
              fontSize: 13,
            ),
          ),
        ]),
      ),
    ],
  );
}
