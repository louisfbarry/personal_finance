import 'dart:async';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/snackbar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController userregistController = TextEditingController();
  TextEditingController passwordregistController = TextEditingController();
  TextEditingController nameregistController = TextEditingController();

  bool pass = true;
  bool confirmpass = true;
  bool submitted = false;
  bool isloading = false;

  final _formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;

  final emialValidator = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'enter a valid email address'),
  ]);

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(6, errorText: 'password must be at least 6 digits long'),
  ]);

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
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Create Account",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.grey[800]),
                              ),
                              Text(
                                "Increase your income today ! ",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                    color: Colors.grey[700],
                                    letterSpacing: 0.8),
                              ),
                              const SizedBox(height: 20),
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
                                controller: userregistController,
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
                                  "Name",
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              TextFormField(
                                controller: nameregistController,
                                autovalidateMode: submitted
                                    ? AutovalidateMode.always
                                    : AutovalidateMode.disabled,
                                validator: RequiredValidator(
                                    errorText: 'Name is required'),
                                decoration: InputDecoration(
                                  hintText: "Enter your name",
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
                                controller: passwordregistController,
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
                                      splashRadius: 2,
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
                              const SizedBox(
                                height: 20,
                              ),
                              SizedBox(
                                width: double.infinity,
                                height: 45,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      FocusScope.of(context).unfocus();
                                      setState(() {
                                        submitted = true;
                                      });
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          isloading = true;
                                        });
                                        try {
                                          final newUser = await auth
                                              .createUserWithEmailAndPassword(
                                                  email:
                                                      userregistController.text,
                                                  password:
                                                      passwordregistController
                                                          .text);
                                          await auth.currentUser!
                                              .updateDisplayName(
                                                  nameregistController.text);
                                          auth.currentUser!
                                              .sendEmailVerification();
                                          // ignore: use_build_context_synchronously
                                          showSnackbar(
                                              context,
                                              ' We sent Verification email to "${userregistController.text}"',
                                              2,
                                              Colors.green[300]);
                                          Navigator.pushNamed(
                                              context, '/login');
                                          setState(() {
                                            isloading = false;
                                          });
                                        } on FirebaseAuthException catch (e) {
                                          String errorMessage = "";
                                          String code = e.code;

                                          if (code == "invalid-email") {
                                            errorMessage = "Invalid email.";
                                          } else if (code ==
                                              "email-already-in-use") {
                                            errorMessage =
                                                "Email was already in use.";
                                          } else if (code ==
                                              "too-many-requests") {
                                            errorMessage =
                                                "Too many request try again later.";
                                          } else if (code ==
                                              "network-request-failed") {
                                            errorMessage =
                                                "Your are currently offline.";
                                          } else {
                                            errorMessage =
                                                "Something went wrong please try again.";
                                          }
                                          showSnackbar(context, errorMessage, 1,
                                              Colors.red[300]);
                                          setState(() {
                                            isloading = false;
                                          });
                                        } catch (e) {
                                          print(e);
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
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Text(
                                              'Sign up',
                                            ),
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
                                "Already have an account? ",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[800],
                                  fontSize: 12,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/login');
                                },
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: const Size(50, 30),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    alignment: Alignment.centerLeft),
                                child: const Text(
                                  "Login",
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
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
