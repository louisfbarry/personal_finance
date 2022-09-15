import 'package:finance/components/snackbar.dart';
import 'package:finance/model/bioauth.dart';
import 'package:finance/screens/home.dart';
import 'package:finance/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';

class MyPasscode extends StatefulWidget {
  const MyPasscode({Key? key}) : super(key: key);

  @override
  State<MyPasscode> createState() => _MyPasscodeState();
}

class _MyPasscodeState extends State<MyPasscode> {
  bool submitted = false;
  bool isloading = false;
  bool pass = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController passwordcontroller = TextEditingController();
  // final auth = FirebaseAuth.instance;

  final LocalAuthentication bioauth = LocalAuthentication();
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          body: SafeArea(
        child: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 9),
                      child: Text("Login", style: TextStyle(fontSize: 22, color: Colors.grey[700], fontWeight: FontWeight.bold),),
                    ),
                    TextFormField(
                      autofocus: true,
                      controller: passwordcontroller,
                      obscureText: pass,
                      autovalidateMode: submitted
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      validator: RequiredValidator(
                          errorText: "Password can't be empty"),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                pass = !pass;
                              });
                            },
                            // splashRadius: 2,
                            icon: pass
                                ? const Icon(
                                    Icons.remove_red_eye,
                                    color: Color.fromARGB(163, 20, 20, 20),
                                  )
                                : const Icon(
                                    Icons.visibility_off,
                                    color: Color.fromARGB(163, 19, 18, 18),
                                  )),
                        hintText: 'Enter your Password',
                        hintStyle: const TextStyle(fontSize: 12),
                        labelStyle: TextStyle(color: Colors.grey[800]),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, '/reset2');
                        },
                        child: Text(
                          'forget password ? ',
                          textAlign: TextAlign.left,
                          style:
                              TextStyle(color: Colors.blue[700], fontSize: 12),
                        ),
                      ),
                    ),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              submitted = true;
                            });

                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isloading = true;
                              });
                              final prefs =
                                  await SharedPreferences.getInstance();
                              // final pass = prefs.getString('password');

                              // print(pass);
                              final email = prefs.getString('email');
                              await FirebaseAuth.instance.currentUser!.reload();
                              try {
                                await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(
                                        email: email!,
                                        password: passwordcontroller.text);
                                // ignore: use_build_context_synchronously
                                Navigator.pushReplacementNamed(
                                    context, '/main');
                                setState(() {
                                  isloading = false;
                                });
                              } on FirebaseException catch (e) {
                                String errorMessage = "";
                                String code = e.code;
                                if (e.code == "wrong-password") {
                                  errorMessage = "Invalid password.";
                                } else if (code == "too-many-requests") {
                                  errorMessage =
                                      "Too many request try again later";
                                } else if (code == "network-request-failed") {
                                  errorMessage = "Your are currently offline.";
                                } else {
                                  errorMessage =
                                      "Something went wrong please try again.";
                                }
                                // ignore: use_build_context_synchronously
                                showSnackbar(
                                    context, errorMessage, 1, Colors.red[300]);
                                setState(() {
                                  isloading = false;
                                });
                              }

                              // if (pass == passwordcontroller.text) {
                              //   Navigator.pushReplacementNamed(context, '/main');
                              //   setState(() {
                              //     isloading = false;
                              //   });
                              // } else {
                              //   // print('wrong pass');
                              //   // ignore: use_build_context_synchronously
                              //   showSnackbar(context, "Invalid Password", 2,
                              //       Colors.red[300]);
                              //   setState(() {
                              //     isloading = false;
                              //   });
                              // }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              elevation: 0, primary: Colors.blue[700]),
                          child: isloading
                              ? const SizedBox(
                                  width: 15,
                                  height: 15,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    'SignIn',
                                  ),
                                )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      )),
    );
  }
}







