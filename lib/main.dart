import 'package:finance/screens/changePw.dart';
import 'package:finance/screens/home.dart';
import 'package:finance/screens/leadingpage.dart';
import 'package:finance/screens/login.dart';
import 'package:finance/screens/register.dart';
import 'package:finance/screens/resetPw.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: '/main',
      routes: {
        '/': (context) => const FrontScreen(),
        '/login': (context) => const MyLogInPage(),
        '/register': (context) => const RegisterPage(),
        '/reset' :(context) => const ResetPassword(),
        '/main': (context) => const Mainpage(),
        '/changepassword':(context) => const ChangePw(),
      },
    );
  }
}
