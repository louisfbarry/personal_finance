import 'package:finance/components/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Security extends StatefulWidget {
  const Security({Key? key}) : super(key: key);
  @override
  State<Security> createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool submitted = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Security",
          style: TextStyle(fontSize: 15),
        ),
        elevation: 0.0,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          InkWell(
            onTap: () {
              nameController.clear();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: AlertDialog(
                      contentPadding:
                          const EdgeInsets.only(left: 10, top: 10, right: 10),
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
                              "Change Name",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                                controller: nameController,
                                // autovalidateMode: submitted
                                //     ? AutovalidateMode.onUserInteraction
                                //     : AutovalidateMode.disabled,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Name can't be empty";
                                  } else {
                                    return null;
                                  }
                                },
                                autofocus: true,
                                decoration: const InputDecoration(
                                  hintText: "Enter your new name",
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
                                      setState(() {
                                        submitted = true;
                                      });
                                      print(submitted);
                                      var validate =
                                          _formKey.currentState!.validate();
                                      // _formKey.currentState!.validate();
                                      if (validate) {
                                        final user =
                                            FirebaseAuth.instance.currentUser!;
                                        await user
                                            .updateDisplayName(
                                                nameController.text)
                                            .then((value) async {
                                          final prefs = await SharedPreferences
                                              .getInstance();
                                          await prefs.setString('displayName',
                                              nameController.text);
                                          Navigator.pop(context);

                                          // ignore: use_build_context_synchronously
                                          showSnackbar(
                                              context,
                                              "Name has been successfully changed",
                                              2,
                                              Colors.green[300]);
                                        }).catchError((error) {
                                          print(error);
                                          Navigator.pop(context);

                                          showSnackbar(
                                              context,
                                              "Name can't be changed ${error.toString()}",
                                              5,
                                              Colors.red[300]);
                                        });
                                        await user.reload();
                                      }
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
                    ),
                  );
                },
              );
            },
            child: securityButton(
                "Change Name", const Icon(Icons.person, color: Colors.amber)),
          ),
          Divider(
            color: Colors.grey[300],
            thickness: 0.5,
          ),
          InkWell(
            onTap: () {
              passwordController.clear();
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: AlertDialog(
                      contentPadding:
                          const EdgeInsets.only(left: 10, top: 10, right: 10),
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
                              "Change Password",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                                controller: passwordController,
                                // autovalidateMode: submitted
                                //     ? AutovalidateMode.onUserInteraction
                                //     : AutovalidateMode.disabled,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Password can't be empty";
                                  } else if (value.length < 6) {
                                    return "Password need 6 character";
                                  } else {
                                    return null;
                                  }
                                },
                                autofocus: true,
                                decoration: const InputDecoration(
                                  hintText: "Enter your new password",
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
                                      print(submitted);
                                      setState(() {
                                        submitted = true;
                                      });
                                      print(submitted);
                                      var validate =
                                          _formKey.currentState!.validate();
                                      // _formKey.currentState!.validate();
                                      if (validate) {
                                        print(submitted);
                                        final user =
                                            FirebaseAuth.instance.currentUser!;
                                        await user
                                            .updatePassword(
                                                passwordController.text)
                                            .then((value) async {
                                          final prefs = await SharedPreferences
                                              .getInstance();
                                          await prefs.setString('password',
                                              passwordController.text);
                                          Navigator.pop(context);

                                          // ignore: use_build_context_synchronously
                                          showSnackbar(
                                              context,
                                              "Password has been successfully changed",
                                              2,
                                              Colors.green[300]);
                                        }).catchError((error) {
                                          print(error);
                                          Navigator.pop(context);

                                          showSnackbar(
                                              context,
                                              "Password can't be changed ${error.toString()}",
                                              5,
                                              Colors.red[300]);
                                        });
                                        await user.reload();
                                      }
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
                    ),
                  );
                },
              );
            },
            child: securityButton(
                "Change Password",
                const Icon(
                  Icons.password,
                  color: Colors.red,
                )),
          ),
          Divider(
            color: Colors.grey[300],
            thickness: 0.5,
          ),
        ],
      ),
    );
  }
}

Widget securityButton(text, icon) {
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
