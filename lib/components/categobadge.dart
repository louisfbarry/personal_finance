import 'package:flutter/material.dart';

class Choice {
  const Choice({required this.title, required this.icon, required this.color});
  final String title;
  final IconData icon;
  final Color color;
}

List<Choice> choices = <Choice>[
  const Choice(
      title: 'Investment',
      icon: Icons.contacts,
      color: Color.fromARGB(255, 253, 239, 150)),
  const Choice(
    title: 'Salary',
    icon: Icons.home,
    color: Colors.green,
  ),
  const Choice(
    title: 'Uncategorized',
    icon: Icons.unarchive_outlined,
    color: Color.fromARGB(255, 56, 62, 86),
  ),
];
