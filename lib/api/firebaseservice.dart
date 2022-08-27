import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

var firestore = FirebaseFirestore.instance;
final currentuser = FirebaseAuth.instance.currentUser;
CollectionReference user = firestore.collection('${currentuser!.email}');


class API {
  Future addCollection() async {
    user.doc('Income').set({'Created At': DateTime.now()});
    user.doc('Outcome').set({'Created At': DateTime.now()});
    user.doc('Saving').set({'Created At': DateTime.now()});
    // addsubCollection(result.id, 'Income');
    // addsubCollection(result.id, 'Outcome');
    // return result.id;
  }

  incomeadding(String category, double amount) {
    user.doc('Income').collection(category).add({
      'category': category,
      'amount': amount,
      ' created At': DateTime.now()
    });
  }
}

class Choice {
  const Choice({required this.title, required this.icon, required this.color});
  final String title;
  final IconData icon;
  final Color color;
}

List<Choice> choices = <Choice>[
  const Choice(title: 'Salary', icon: Icons.home, color: Colors.green),
  const Choice(
      title: 'Investment',
      icon: Icons.contacts,
      color: Color.fromARGB(255, 253, 239, 150)),
  const Choice(
      title: 'Part-Time',
      icon: Icons.map,
      color: Color.fromARGB(255, 163, 86, 56)),
  const Choice(
      title: 'Uncategorized',
      icon: Icons.unarchive_outlined,
      color: Color.fromARGB(255, 56, 62, 86)),
];
