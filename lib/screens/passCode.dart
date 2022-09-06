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
    return Scaffold(
        body: Form(
      key: _formKey,
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 80,
            width: 300,
            child: TextFormField(
              controller: passwordcontroller,
              obscureText: pass,
              autovalidateMode: submitted
                  ? AutovalidateMode.always
                  : AutovalidateMode.disabled,
              validator:
                  RequiredValidator(errorText: "Password can't be empty"),
              decoration: InputDecoration(
                errorBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 1, color: Colors.redAccent),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      width: 1, color: Color.fromARGB(157, 0, 0, 0)),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        width: 2, color: Color.fromARGB(157, 0, 0, 0)),
                    borderRadius: BorderRadius.circular(10)),
                focusedErrorBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 1, color: Colors.redAccent),
                    borderRadius: BorderRadius.circular(10)),
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        pass = !pass;
                      });
                    },
                    splashRadius: 2,
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
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                setState(() {
                  submitted = true;
                });
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    isloading = true;
                  });
                  final prefs = await SharedPreferences.getInstance();
                  final pass = prefs.getString('password');
                  print(pass);

                  if (pass == passwordcontroller.text) {
                    Navigator.pushReplacementNamed(context, '/main');
                    isloading = false;
                  } else {
                    print('wrong pass');
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(94, 0, 0, 0),
                padding: const EdgeInsets.only(left: 120, right: 120),
                elevation: 10,
              ),
              child: isloading
                  ? const Padding(
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'SignIn',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Libre',
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                    )),
        ],
      )),
    ));
  }
}
