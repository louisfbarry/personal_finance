import 'package:finance/model/bioauth.dart';
import 'package:finance/screens/home.dart';
import 'package:finance/screens/login.dart';
import 'package:finance/screens/passCode.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FrontScreen extends StatefulWidget {
  const FrontScreen({Key? key}) : super(key: key);

  @override
  State<FrontScreen> createState() => _FrontScreenState();
}

class _FrontScreenState extends State<FrontScreen> {
  bool showBiometrics = false;

  // isBiometricAvailable() async {
  //   showBiometrics = await BiometricHelper().hasEnrolledBiometrics();
  //   if (showBiometrics == false) {
  //     // ignore: use_build_context_synchronously
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => const MyPasscode(),
  //       ),
  //     );
  //   } else {
  //     // ignore: use_build_context_synchronously
  //     Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const Mainpage(),
  //         ));
  //   }
  //   print(">>>>> $showBiometrics");
  //   setState(() {});
  // }

  void loginCheck() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
        Navigator.pushNamed(context, '/login');
      } else {
        print('User is signed in!');
        Navigator.pushNamed(context, '/passcode');
        // isBiometricAvailable();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Center(
                    child: Image.asset(
                      'images/landing.png',
                      width: 240,
                      height: 240,
                    ),
                  ),
                ),
                Text("Personal Finance",
                    style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800])),
                Text(
                  "Find ways to get more income and saving",
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 13,
                      letterSpacing: 0.7),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 0, primary: Colors.blueAccent),
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: const Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ))),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            primary: Colors.blueAccent,
                            side: const BorderSide(
                                width: 1, color: Colors.blueAccent)),
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: const Text("Register"))),
                const SizedBox(
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
