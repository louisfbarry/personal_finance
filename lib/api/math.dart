import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../api./firebaseservice.dart';

CollectionReference user = firestore.collection('${currentuser!.email}');

double total = 0;
List value = [];

categoValue(Stream<QuerySnapshot> _usersStream, String name) {
  return Container(
    color: Colors.green,
    height: 100,
    width: 200,
    child: StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder:
          (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        total = 0;
        value = [];
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }

        if (snapshot.hasData) {
          snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            total += data['amount'];
            value.add(data['amount']);
            print(total);
          }).toList();
        }
        print(value);
        return Text('$total');
      },
    ),
  );
}
