import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import '../components/snackbar.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final emialValidator = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'Enter a valid email address'),
  ]);

  final auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  TextEditingController usernamecontroller = TextEditingController();
  bool submitted = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          body: DefaultTextStyle(
        style: TextStyle(color: Colors.grey[900]),
        child: Center(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Forget Password",
                      style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800])),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    "Enter your email we will send reset password link",
                    style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12,
                        letterSpacing: 0.3),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: usernamecontroller,
                    autovalidateMode: submitted
                        ? AutovalidateMode.always
                        : AutovalidateMode.disabled,
                    validator: emialValidator,
                    decoration: const InputDecoration(
                      hintText: "Enter your email",
                      hintStyle: TextStyle(fontSize: 12),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: const Text(
                        'go back to login',
                        textAlign: TextAlign.left,
                        style: TextStyle(color: Colors.blue, fontSize: 12),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 0, primary: Colors.blueAccent),
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        if (_formKey.currentState!.validate()) {
                          auth.sendPasswordResetEmail(
                              email: usernamecontroller.text);
                          showSnackbar(
                              context,
                              "We have sent reset password link in your email",
                              4,
                              Colors.green[300]);
                          Navigator.pushReplacementNamed(context, '/login');
                        }
                      },
                      child: const Text(
                        'Send Request',
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }
}