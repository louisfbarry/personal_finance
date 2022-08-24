import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final emialValidator = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'enter a valid email address'),
  ]);

  final auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  TextEditingController usernamecontroller = TextEditingController();
  bool submitted = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 80,
              width: 300,
              child: TextFormField(
                controller: usernamecontroller,
                autovalidateMode: submitted
                    ? AutovalidateMode.always
                    : AutovalidateMode.disabled,
                validator: emialValidator,
                decoration: InputDecoration(
                  errorBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 1, color: Colors.redAccent),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        width: 1, color: Color.fromARGB(157, 9, 237, 176)),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          width: 2, color: Color.fromARGB(157, 9, 237, 176)),
                      borderRadius: BorderRadius.circular(10)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 1, color: Colors.redAccent),
                      borderRadius: BorderRadius.circular(10)),
                  hintText: 'Enter Your Email Account',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  auth.sendPasswordResetEmail(email: usernamecontroller.text);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Container(
                        alignment: Alignment.center,
                        height: 30,
                        child: const Text(
                          ' We have sent  Passwordreset email. ',
                          style: TextStyle(
                              fontFamily: 'Libre',
                              fontSize: 15,
                              color: Colors.black),
                        ),
                      ),
                      backgroundColor: Colors.teal,
                      duration: const Duration(seconds: 2)));
                  Navigator.pushReplacementNamed(context, '/login');
                }
              },
              style: ElevatedButton.styleFrom(
                primary: const Color.fromARGB(157, 9, 237, 176),
                padding: const EdgeInsets.only(left: 100, right: 100),
                elevation: 15,
              ),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Send Request',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Libre',
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
