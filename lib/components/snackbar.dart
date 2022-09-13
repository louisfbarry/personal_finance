import 'package:flutter/material.dart';

showSnackbar(context, message, duration, color) {
  return ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(SnackBar(
      // edit
      content: Text(
        message,
        style: const TextStyle(fontSize: 12),
      ),
      duration: Duration(seconds: duration),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
    ));
}
