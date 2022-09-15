import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class checkScreen extends StatefulWidget {
  const checkScreen({Key? key}) : super(key: key);

  @override
  State<checkScreen> createState() => _checkScreenState();
}

class _checkScreenState extends State<checkScreen> {
  bool? passcode;

  getPasscode() async {
    final prefs = await SharedPreferences.getInstance();
    final bool? onOff = prefs.getBool('passwordLogin');
    passcode = onOff;
    // print("onOffC ${passcode}");
    // print(">>>${passcode}");
  }

  void loginCheck() async {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user == null) {
        print('User is currently signed out!');
        // Navigator.popUntil(ModalRoute.withName("/"));
        Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
      } else {
        print('User is signed in!');
        await getPasscode();
        passCodeScrrenCheck();
        // Navigator.pushReplacementNamed(context, '/main');
        // isBiometricAvailable();
      }
    });
  }

  void passCodeScrrenCheck() {
    if (passcode == true) {
      // print("passcode");
      Navigator.pushNamedAndRemoveUntil(context, "/passcode", (route) => false);
    } else {
      Navigator.pushReplacementNamed(context, '/main');
    }
  }

  @override
  void initState() {
    // print("hi");
    // getPasscode();
    loginCheck();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SpinKitPulse(
          color: Colors.grey,
        ),
      ),
    );
  }
}
