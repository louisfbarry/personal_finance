import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:form_field_validator/form_field_validator.dart';

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

  final _formKey = GlobalKey<FormState>();

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
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
      key: _formKey,
      child: SizedBox(
        child: Center(
          child: SingleChildScrollView(
            child: Column(children: [
              Container(
                height: 300,
                width: 300,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('images/Removal-243.png'))),
              ),
              Container(
                  width: 300,
                  padding: const EdgeInsets.only(bottom: 8),
                  alignment: Alignment.topLeft,
                  child: const Text('Welcome!',
                  style: TextStyle(
                    fontFamily: 'Libre',
                    fontSize: 20,
                    color: Colors.teal
                  ),)),
              Column(
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
                          borderSide: const BorderSide(
                              width: 1, color: Colors.redAccent),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 1,
                              color: Color.fromARGB(157, 9, 237, 176)),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2,
                                color: Color.fromARGB(157, 9, 237, 176)),
                            borderRadius: BorderRadius.circular(10)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1, color: Colors.redAccent),
                            borderRadius: BorderRadius.circular(10)),
                        hintText: 'Enter Your Email Account',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    width: 300,
                    child: TextFormField(
                      controller: passwordcontroller,
                      obscureText: pass,
                      autovalidateMode: submitted
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      validator: passwordValidator,
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 1, color: Colors.redAccent),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 1,
                              color: Color.fromARGB(157, 9, 237, 176)),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 2,
                                color: Color.fromARGB(157, 9, 237, 176)),
                            borderRadius: BorderRadius.circular(10)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1, color: Colors.redAccent),
                            borderRadius: BorderRadius.circular(10)),
                        // filled: true,
                        // fillColor: const Color.fromARGB(157, 9, 237, 176),
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
                        hintText: 'Enter Password',
                      ),
                    ),
                  ),
                  Container(
                    width: 300,
                    alignment: Alignment.topRight,
                    child: TextButton(onPressed: () {
                      
                    },
                     child: const Text('forget password?',
                     textAlign: TextAlign.left,
                    style: TextStyle(color: Colors.blue),),),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        final String? username = prefs.getString('UserID');
                        setState(() {
                          submitted = true;
                          print('$username');
                        });
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isloading = true;
                          });
                          try {
                            final auth = FirebaseAuth.instance;
                            UserCredential currentUser =
                                await auth.signInWithEmailAndPassword(
                                    email: usernamecontroller.text,
                                    password: passwordcontroller.text);
                            print(currentUser.user!);
                            if (currentUser.user!.uid != null) {
                              isloading = false;
                              // ignore: use_build_context_synchronously
                              Navigator.popUntil(
                                  context, ModalRoute.withName('/'));
                              // ignore: use_build_context_synchronously
                              Navigator.pushReplacementNamed(context, '/main');
                              usernamecontroller.clear();
                              passwordcontroller.clear();
                            }
                          } on FirebaseException catch (e) {
                            if (e.code == 'user-not-found') {
                              errorMassage = 'No user found with this E-mail';
                            } else if (e.code == 'wrong-password') {
                              errorMassage = ' Wrong password !';
                            } else {
                              errorMassage = e.code;
                            }
                            setState(() {
                              isloading = false;
                            });
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(errorMassage),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 1)));
                          } catch (e) {
                            setState(() {
                              isloading = false;
                            });
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(e.toString()),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 1)));
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: const Color.fromARGB(157, 9, 237, 176),
                        padding: const EdgeInsets.only(left: 120, right: 120),
                        elevation: 15,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Need to Create An Account ?',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              Navigator.pushNamed(context, '/register');
                            });
                          },
                          child: const Text(
                            'SignUp',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Color.fromARGB(255, 8, 254, 4)),
                          )),
                      const SizedBox(
                        height: 100,
                      )
                    ],
                  )
                ],
              ),
            ]),
          ),
        ),
      ),
    ));
  }
}
