import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../model/firebaseservice.dart';

CollectionReference user = firestore.collection('${currentuser!.email}');

// double total = 0;
// List value = [];

// categoValue(Stream<QuerySnapshot> _usersStream) {
//   return Container(
//     color: Colors.green,
//     height: 100,
//     width: 200,
//     child: StreamBuilder<QuerySnapshot>(
//       stream: _usersStream,
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         total = 0;
//         value = [];
//         if (snapshot.hasError) {
//           return const Text('Something went wrong');
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Text("Loading");
//         }

//         if (snapshot.hasData) {
//           snapshot.data!.docs.map((DocumentSnapshot document) {
//             Map<String, dynamic> data =
//                 document.data()! as Map<String, dynamic>;
//             total += data['amount'];
//             value.add(data['amount']);
//           }).toList();
//         }
//         print(value);
//         return Text('$total');
//       },
//     ),
//   );
// }

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
