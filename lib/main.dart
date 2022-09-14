import 'package:finance/screens/changePw.dart';
import 'package:finance/screens/checkScreen.dart';
import 'package:finance/screens/home.dart';
import 'package:finance/screens/leadingpage.dart';
import 'package:finance/screens/login.dart';
import 'package:finance/screens/passCode.dart';
import 'package:finance/screens/register.dart';
import 'package:finance/screens/resetPw.dart';
import 'package:finance/screens/resetPw2.dart';
import 'package:finance/screens/saving_details.dart';
import 'package:finance/screens/saving_money_adding_history.dart';
import 'package:finance/screens/savingadding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        inputDecorationTheme: const InputDecorationTheme(
          contentPadding: EdgeInsets.all(10),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/checkScreen',
      routes: {
        '/': (context) => const FrontScreen(),
        '/login': (context) => const MyLogInPage(),
        '/register': (context) => const RegisterPage(),
        '/reset': (context) => const ResetPassword(),
        '/reset2': (context) => const ResetPassword2(),
        '/main': (context) => const Mainpage(),
        '/changepassword': (context) => const ChangePw(),
        '/checkScreen': (context) => const checkScreen(),
        '/passcode': (context) => const MyPasscode(),
        '/savingHistory': (context) => const SavingHistory()
      },
    );
  }
}
