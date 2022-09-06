import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../model/firebaseservice.dart';
import 'package:firebase_database/firebase_database.dart';

CollectionReference user = firestore.collection('${currentuser!.email}');

Future<List<String>> IncomeCategoList() async {
  List<String> list = [];
  await user.doc('Income-catego').collection('data').get().then((snapshot) {
    snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

      list.add(data['categoname']);
    }).toList();
  });
  print(list);
  return list;
  // final allData = querySnapshot.docs.map((doc) {
  //   doc.data();
  // }).toList();
}

Future<List> incomecategovalue(String catego) async {
  List<int> list = [0];
  await user
      .doc('Income')
      .collection('income-data')
      .orderBy('created At')
      .get()
      .then((snapshot) {
    snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      if (data['category'] == catego) {
        list.add(data['amount']);
      }
    }).toList();
  });
  print(list);
  return list;
}

Future<List> outcomecategovalue(String catego) async {
  List<int> list = [0];
  await user.doc('outcome').collection('outcome-data').get().then((snapshot) {
    snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      if (data['category'] == catego) {
        list.add(data['amount']);
      }
    }).toList();
  });
  print(list);
  return list;
}

Future<List> savingcategovalue(String catego) async {
  List<int> list = [];
  await user.doc('Income').collection(catego).get().then((snapshot) {
    snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      list.add(data['amount']);
    }).toList();
  });
  print(list);
  return list;
}
