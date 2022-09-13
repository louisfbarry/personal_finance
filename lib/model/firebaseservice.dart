import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

var firestore = FirebaseFirestore.instance;
// final currentuser = FirebaseAuth.instance.currentUser;
final auth = FirebaseAuth.instance;

String Cdate = DateFormat("EEEEE, dd, MM, yyyy").format(DateTime.now());

CollectionReference user =
    firestore.collection('${FirebaseAuth.instance.currentUser!.email}');
// final Stream<QuerySnapshot> incomeStream = firestore
//     .collection('${FirebaseAuth.instance.currentUser!.email}')
//     .doc('Income')
//     .collection('income-data')
//     .orderBy('created At', descending: true)
//     .snapshots();
// final Stream<QuerySnapshot> outcomeStream = firestore
//     .collection('${FirebaseAuth.instance.currentUser!.email}')
//     .doc('Outcome')
//     .collection('outcome-data')
//     .orderBy('created At', descending: true)
//     .snapshots();

class API {
  addCollection() {
    user.doc('Income').set({'Created At': Cdate});
    user.doc('Outcome').set({'Created At': Cdate});
    user.doc('Saving').set({'Created At': Cdate});
    user.doc('Income-catego').set({'Created At': Cdate});
    user.doc('Outcome-catego').set({'Created At': Cdate});
    user
        .doc('Income-catego')
        .collection('data')
        .doc('Salary')
        .set({'categoname': 'Salary', 'imagId': 'job'});

    user
        .doc('Outcome-catego')
        .collection('data')
        .doc('Food')
        .set({'categoname': 'Food', 'imagId': 'food'});
    user
        .doc('Outcome-catego')
        .collection('data')
        .doc('Bill')
        .set({'categoname': 'Bill', 'imagId': 'bill'});
  }

  incomeadding(String category, int amount, String note) {
    final incomeId = user.doc('Income').collection('income-data').doc();
    incomeId.set({
      'category': category,
      'id': incomeId.id,
      'amount': amount,
      'note': note,
      'created At': Cdate,
    });
  }

  outcomeadding(String category, int amount, String note) {
    final outcomeId = user.doc('Outcome').collection('outcome-data').doc();
    outcomeId.set({
      'category': category,
      'id': outcomeId.id,
      'amount': amount,
      'note': note,
      'created At': Cdate,
    });
  }

  incomehistroydelete(String id) {
    user.doc('Income').collection('income-data').doc(id).delete();
  }

  outcomehistorydelete(String id) {
    user.doc('Outcome').collection('outcome-data').doc(id).delete();
  }

  incomehistroyupdate(String catego, int amount, String note, String id) {
    user
        .doc('Income')
        .collection('income-data')
        .doc(id)
        .update({'category': catego, 'amount': amount, 'note': note});
  }

  outcomehistroyupdate(String catego, int amount, String note, String id) {
    user
        .doc('Outcome')
        .collection('outcome-data')
        .doc(id)
        .update({'category': catego, 'amount': amount, 'note': note});
  }

  savingadding(
    String title,
    int targetPrice,
    int addPrice,
  ) {
    final savingDataId = user.doc("Saving").collection('saving-data').doc();
    savingDataId.set({
      'title': title,
      'targetPrice': targetPrice,
      'addPrice': addPrice,
      'createdAt': DateTime.now(),
      'id': savingDataId.id
    });
  }

  savingPriceAdding(
    int price,
    String id,
  ) {
    final savingHistory = user
        .doc("Saving")
        .collection('saving-data')
        .doc(id)
        .collection('add-prices')
        .doc();
    savingHistory.set(
        {'price': price, 'id': savingHistory.id, 'createdAt': DateTime.now()});
  }

  updateSaving(String id, String title, int targetPrice) {
    user
        .doc("Saving")
        .collection("saving-data")
        .doc(id)
        .update({"title": title, "targetPrice": targetPrice});
  }
}
