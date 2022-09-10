import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/firebaseservice.dart';

// CollectionReference user = firestore.collection('${FirebaseAuth.instance.currentUser!.email');

Future<List<String>> incomeCategoList() async {
  List<String> list = [];
  await firestore.collection('${FirebaseAuth.instance.currentUser!.email}').doc('Income-catego').collection('data').get().then((snapshot) {
    snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

      list.add(data['categoname']);
    }).toList();
  });
  // print(list);
  return list;
}

Future<List<String>> incomeCategoImgList() async {
  List<String> list = [];
  await user.doc('Income-catego').collection('data').get().then((snapshot) {
    snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

      list.add(data['imagId']);
    }).toList();
  });
  // print(list);
  return list;
}

Future<List<String>> outcomeCategoList() async {
  List<String> list = [];
  await user.doc('Outcome-catego').collection('data').get().then((snapshot) {
    snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

      list.add(data['categoname']);
    }).toList();
  });
  // print(list);
  return list;
}

Future<List<String>> outcomeCategoImgList() async {
  List<String> list = [];
  await user.doc('Outcome-catego').collection('data').get().then((snapshot) {
    snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

      list.add(data['imagId']);
    }).toList();
  });
  print(list);
  return list;
}

Future<int> incomecategovalue(String catego) async {
  List<int> list = [0];
  int value = 0;
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
  // print(list);
  for (var i = 0; i < list.length; i++) {
    value += list[i];
  }
  return value;
}

Future<int> outcomecategovalue(String catego) async {
  List<int> list = [0];
  int value = 0;
  await user
      .doc('Outcome')
      .collection('outcome-data')
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
  for (var i = 0; i < list.length; i++) {
    value += list[i];
  }
  print(value);
  return value;
}

Future<List> incomevalue() async {
  List<int> list = [0];
  await user
      .doc('Income')
      .collection('income-data')
      .orderBy('created At')
      .get()
      .then((snapshot) {
    snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

      list.add(data['amount']);
    }).toList();
  });
  print(list);
  return list;
}

Future<List> outcomevalue() async {
  List<int> list = [0];
  await user
      .doc('Outcome')
      .collection('outcome-data')
      .orderBy('created At')
      .get()
      .then((snapshot) {
    snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      list.add(data['amount']);
    }).toList();
  });
  print(list);
  return list;
}

Future<List> savingtotal() async {
  List<int> list = [0];

  await FirebaseFirestore.instance
      .collection("${FirebaseAuth.instance.currentUser!.email}")
      .doc("Saving")
      .collection("saving-data")
      .get()
      .then((snapshot) {
    snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
      list.add(data['addPrice']);
    }).toList();
  });
  print(list);
  return list;
}
