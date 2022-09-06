import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:form_field_validator/form_field_validator.dart';

import '../components/snackbar.dart';

class MyLogInPage extends StatefulWidget {
  const MyLogInPage({Key? key}) : super(key: key);

  @override
  State<MyLogInPage> createState() => _MyLogInPageState();
}

class _MyLogInPageState extends State<MyLogInPage> {
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  bool pass = true;
  bool confirmpass = true;
  bool submitted = false;
  bool isloading = false;

  late User currentUser;
  final auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  Timer mytime = Timer.periodic(const Duration(seconds: 3), ((timer) async {
    print('time reached');
  }));

  Future<void> checkEmail() async {
    currentUser = auth.currentUser!;
    await currentUser.reload();

    if (currentUser.emailVerified) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('password', passwordcontroller.text);
      setState(() {
        isloading = false;

        usernamecontroller.clear();
        passwordcontroller.clear();
        mytime.cancel();
        Navigator.popUntil(context, ModalRoute.withName('/'));
        Navigator.pushNamed(context, '/main');
      });
    } else {
      print('not yet');
    }
  }

  final emialValidator = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'enter a valid email address'),
  ]);

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(6, errorText: 'password must be at least 6 digits long'),
  ]);

  bool eye = true;
  var errorMassage = '';

  @override
  void dispose() {
    mytime.cancel();
    //test
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: Colors.grey[100],
          body: DefaultTextStyle(
            style: TextStyle(color: Colors.grey[900]),
            child: Form(
              key: _formKey,
              child: SizedBox(
                child: Center(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(13.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Text(
                                    "Welcome Back",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 23,
                                        color: Colors.grey[800]),
                                  ),
                                  Text(
                                    "Hello again you've been missed!",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: Colors.grey[700]),
                                  ),
                                  const SizedBox(
                                    height: 25,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 3),
                                    child: Text(
                                      "Email Address",
                                      style: TextStyle(
                                        color: Colors.grey[800],
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: usernamecontroller,
                                    autovalidateMode: submitted
                                        ? AutovalidateMode.always
                                        : AutovalidateMode.disabled,
                                    validator: emialValidator,
                                    decoration: InputDecoration(
                                      hintText: "Enter your email",
                                      hintStyle: const TextStyle(fontSize: 12),
                                      labelStyle:
                                          TextStyle(color: Colors.grey[800]),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 3),
                                    child: Text(
                                      "Password",
                                      style: TextStyle(
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: passwordcontroller,
                                    obscureText: pass,
                                    autovalidateMode: submitted
                                        ? AutovalidateMode.always
                                        : AutovalidateMode.disabled,
                                    validator: passwordValidator,
                                    decoration: InputDecoration(
                                      hintText: "Enter your password",
                                      hintStyle: const TextStyle(fontSize: 12),
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              pass = !pass;
                                            });
                                          },
                                          // splashRadius: 2,
                                          icon: pass
                                              ? Icon(
                                                  Icons.remove_red_eye,
                                                  color: Colors.grey[800],
                                                )
                                              : Icon(
                                                  Icons.visibility_off,
                                                  color: Colors.grey[800],
                                                )),
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    alignment: Alignment.topRight,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.pushReplacementNamed(
                                            context, '/reset');
                                      },
                                      child: const Text(
                                        'forget password ? ',
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 40,
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          FocusScope.of(context).unfocus();
                                          final prefs = await SharedPreferences
                                              .getInstance();
                                          final String? username =
                                              prefs.getString('UserID');
                                          prefs.setString('password',
                                              passwordcontroller.text);
                                          setState(() {
                                            submitted = true;
                                            print('$username');
                                          });
                                          if (_formKey.currentState!
                                              .validate()) {
                                            setState(() {
                                              isloading = true;
                                            });
                                            try {
                                              final auth =
                                                  FirebaseAuth.instance;
                                              UserCredential currentUser =
                                                  await auth
                                                      .signInWithEmailAndPassword(
                                                          email:
                                                              usernamecontroller
                                                                  .text,
                                                          password:
                                                              passwordcontroller
                                                                  .text);
                                              print(currentUser.user!);
                                              setState(() {
                                                mytime;
                                                checkEmail();
                                              });
                                            } on FirebaseException catch (e) {
                                              String errorMessage = "";
                                              String code = e.code;

                                              if (code == "invalid-email") {
                                                errorMessage = "Invalid email.";
                                              } else if (code ==
                                                  "user-not-found") {
                                                errorMessage =
                                                    "User not found.";
                                              } else if (code ==
                                                  "wrong-password") {
                                                errorMessage =
                                                    "Invalid password.";
                                              } else if (code ==
                                                  "too-many-requests") {
                                                errorMessage =
                                                    "Too many request try again later";
                                              } else if (code ==
                                                  "network-request-failed") {
                                                errorMessage =
                                                    "Your are currently offline.";
                                              } else {
                                                errorMessage =
                                                    "Something went wrong please try again.";
                                              }

                                              // ignore: use_build_context_synchronously
                                              showSnackbar(
                                                  context,
                                                  errorMessage,
                                                  1,
                                                  Colors.red[300]);
                                              setState(() {
                                                isloading = false;
                                              });
                                            } catch (e) {
                                              setState(() {
                                                isloading = false;
                                              });
                                              // ignore: use_build_context_synchronously
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content:
                                                          Text(e.toString()),
                                                      backgroundColor:
                                                          Colors.red[300],
                                                      duration: const Duration(
                                                          seconds: 1)));
                                            }
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            primary: Colors.blueAccent),
                                        child: isloading
                                            ? const SizedBox(
                                                width: 15,
                                                height: 15,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2,
                                                ),
                                              )
                                            : const Text(
                                                'SignIn',
                                              )),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 30),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account? ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey[800],
                                      fontSize: 12,
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushReplacementNamed(
                                          context, '/register');
                                    },
                                    style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: const Size(50, 30),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        alignment: Alignment.centerLeft),
                                    child: const Text(
                                      "Signup",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.blueAccent,
                                        fontSize: 12,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
            ),
          )),
    );
  }
}
