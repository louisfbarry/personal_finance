import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/screens/dashboard.dart';
import 'package:finance/screens/language.dart';
import 'package:finance/screens/security.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/snackbar.dart';
import '../model/firebaseservice.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  TextEditingController securityController = TextEditingController();

  String userEmail = "";
  String userDisplayName = "";
  bool? toggleOn;

  getNameAndEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userDisplayName = prefs.getString("displayName")!;
      userEmail = prefs.getString("email")!;
    });
  }

  getPassLoginOnOff() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? onOff = prefs.getBool('passwordLogin');
    toggleOn = onOff;
    // print("onOff ${toggleOn}");
  }

  @override
  void initState() {
    getNameAndEmail();
    getPassLoginOnOff();
    super.initState();
  }

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
                          "Cancel",
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
    bool pass = true;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
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
                    AppLocalizations.of(context)!.security,
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
                      obscureText: pass,
                      decoration: InputDecoration(
                        hintText: "Enter your password",
                        hintStyle: const TextStyle(fontSize: 12),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                print(pass);
                                pass = !pass;
                              });
                            },
                            splashRadius: 2,
                            icon: (pass)
                                ? const Icon(
                                    Icons.remove_red_eye,
                                    color: Color.fromARGB(163, 20, 20, 20),
                                  )
                                : const Icon(
                                    Icons.visibility_off,
                                    color: Color.fromARGB(163, 19, 18, 18),
                                  )),
                        contentPadding: const EdgeInsets.symmetric(
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
                            final String? password =
                                prefs.getString('password');
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
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      // appBar: AppBar(
      //   title: Padding(
      //     padding: const EdgeInsets.symmetric(horizontal: 10),
      //     child: Text("Setting", style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w600),),
      //   ),
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,

      // ),
      body: (userEmail == "" || userDisplayName == "")
          ? const Center(
              // child: CircularProgressIndicator(),
              child: SpinKitPulse(
              color: Colors.grey,
            ))
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 25),
                      child: Text(
                        AppLocalizations.of(context)!.setting,
                        style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[900]),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        // color: Colors.grey[100],
                        color: Colors.blue[700],
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 15),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.person,
                                size: 33,
                                // color: Colors.brown,
                                color: Colors.grey[200],
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    userDisplayName,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        // color: Colors.grey[900]
                                        color: Colors.grey[100]),
                                  ),
                                  Text(
                                    userEmail,
                                    style: TextStyle(
                                        fontSize: 13,
                                        //  color: Colors.grey[800]
                                        color: Colors.grey[200]),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.password,
                                color: Colors.yellow[700],
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                AppLocalizations.of(context)!.passcodeLogin,
                                style: TextStyle(fontSize: 15),
                              )
                            ],
                          ),
                          Switch.adaptive(
                              value: toggleOn == null ? false : toggleOn!,
                              activeColor: Colors.blueAccent,
                              onChanged: (value) async {
                                setState(() {
                                  toggleOn = value;
                                });
                                // print(this.toggleOn);
                                final prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setBool('passwordLogin', toggleOn!);
                              })
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.grey[400],
                      thickness: 0.5,
                    ),

                    InkWell(
                      onTap: () {
                        // _securityDialog(context);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const Security()));
                      },
                      child: settingButton(
                          AppLocalizations.of(context)!.security,
                          const Icon(
                            Icons.lock,
                            color: Colors.green,
                          )),
                    ),
                    Divider(
                      color: Colors.grey[400],
                      thickness: 0.5,
                    ),
                    InkWell(
                      onTap: () {
                        // print("Language");
                        Navigator.pushNamed(context, '/language');
                      },
                      child: settingButton(
                          AppLocalizations.of(context)!.language,
                          const Icon(
                            Icons.language,
                            color: Colors.blue,
                          )),
                    ),
                    Divider(
                      color: Colors.grey[400],
                      thickness: 0.5,
                    ),
                    InkWell(
                      onTap: () {
                        _showDialog(
                            context,
                            AppLocalizations.of(context)!.dywtrp,

                            // AppLocalizations.of(context)!.reset,
                            "Reset", () async {
                          // saving delete path
                          var savingDeletePath = FirebaseFirestore.instance
                              .collection(
                                  "${FirebaseAuth.instance.currentUser!.email}")
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
                              .collection(
                                  "${FirebaseAuth.instance.currentUser!.email}")
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
                              .collection(
                                  "${FirebaseAuth.instance.currentUser!.email}")
                              .doc("Outcome")
                              .collection('outcome-data');

                          // delete outcome data
                          outcomeDeletePath.get().then((value) {
                            value.docs.forEach((element) {
                              outcomeDeletePath.doc(element.id).delete();
                            });
                          });

                          // delete income category
                          var incomeCategoryPath = FirebaseFirestore.instance
                              .collection(
                                  "${FirebaseAuth.instance.currentUser!.email}")
                              .doc("Income-catego")
                              .collection("data");

                          incomeCategoryPath.get().then((value) => {
                                value.docs.forEach((element) {
                                  incomeCategoryPath.doc(element.id).delete();
                                })
                              });

                          // delete outcome category
                          var outcomeCategoryPath = FirebaseFirestore.instance
                              .collection(
                                  "${FirebaseAuth.instance.currentUser!.email}")
                              .doc("Outcome-catego")
                              .collection("data");

                          outcomeCategoryPath.get().then((value) => {
                                value.docs.forEach((element) {
                                  outcomeCategoryPath.doc(element.id).delete();
                                })
                              });

                          API().addCollection();
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute<void>(
                          //     builder: (BuildContext context) =>
                          //         const Dashboard()));

                          Navigator.pop(context);
                          // Navigator.pushNamed(context, "/main");
                          showSnackbar(context, "Successfully reset app", 2,
                              Colors.green[300]);

                          //last
                        });
                      },
                      child: settingButton(
                          AppLocalizations.of(context)!.resetApp,
                          const Icon(Icons.restart_alt, color: Colors.orange)),
                    ),
                    Divider(
                      color: Colors.grey[400],
                      thickness: 0.5,
                    ),
                    InkWell(
                        onTap: () {
                          _showDialog(
                              context,
                              AppLocalizations.of(context)!.dywtlo,
                              "Logout", () async {
                            final prefs = await SharedPreferences.getInstance();
                            final success = await prefs.remove('passwordLogin');
                            final Language = await prefs.remove('language');
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                            print("logout - ${success}");
                            await FirebaseAuth.instance.signOut();
                          });
                        },
                        child: settingButton(
                            AppLocalizations.of(context)!.logout,
                            const Icon(
                              Icons.logout,
                              color: Colors.red,
                            ))),
                    Divider(
                      color: Colors.grey[400],
                      thickness: 0.5,
                    )
                  ],
                ),
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
              fontSize: 15,
            ),
          ),
        ]),
      ),
    ],
  );
}
