import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/model/firebaseGet.dart';
import 'package:finance/model/firebaseservice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:form_field_validator/form_field_validator.dart';

List<Categostyle> outcomecategostylelist = [];
List<String> outcomeImg = [
  'arrived',
  'bill',
  'cat',
  'classic-car',
  'coffee',
  'coin',
  'corgi',
  'credit-card',
  'cyclist',
  'engine-oil',
  'fashion',
  'folder',
  'food',
  'laptop',
  'money-bag',
  'online-payment',
  'package-box',
  'suitcase',
  'television'
];

class OutcomeCategoCreate extends StatefulWidget {
  const OutcomeCategoCreate({
    Key? key,
  }) : super(key: key);

  @override
  State<OutcomeCategoCreate> createState() => _OutcomeCategoCreateState();
}

class _OutcomeCategoCreateState extends State<OutcomeCategoCreate> {
  static GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController newcatego = TextEditingController();
  CollectionReference user =
      firestore.collection('${FirebaseAuth.instance.currentUser!.email}');
  String outcomedropdown = 'food';
  Map<String, dynamic>? data;
  String dropdownValue = 'Bill';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  child: const SizedBox(
                    width: 30,
                    child: Divider(
                      color: Colors.black,
                      thickness: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Form(
                key: formKey,
                child: Row(children: [
                  SizedBox(
                    width: 80,
                    height: 50,
                    child: DropdownButtonFormField(
                      value: outcomedropdown,
                      isExpanded: true,
                      items: outcomeImg
                          .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Image(
                                    image: AssetImage('images/$item.png'),
                                  ))))
                          .toList(),
                      onChanged: (newValue) {
                        setState(() {
                          outcomedropdown = newValue.toString();
                        });
                      },
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(5)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  width: 2, color: Colors.black),
                              borderRadius: BorderRadius.circular(5))),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 150,
                    height: 50,
                    child: TextFormField(
                      controller: newcatego,
                      validator: RequiredValidator(
                          errorText: 'Pls enter your category name'),
                      decoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 1, color: Colors.redAccent),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(width: 1, color: Colors.black),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(width: 2, color: Colors.black),
                            borderRadius: BorderRadius.circular(5)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1, color: Colors.redAccent),
                            borderRadius: BorderRadius.circular(5)),
                        hintText: 'Create category',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        user
                            .doc('Outcome-catego')
                            .collection('data')
                            .doc(newcatego.text)
                            .set({
                          'categoname': newcatego.text,
                          'imagId': outcomedropdown
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue[700],
                        // padding: const EdgeInsets.all(10),
                      ),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 7, vertical: 13),
                        child: Text(
                          'Set',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ))
                ]),
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                  stream: firestore
                      .collection('${FirebaseAuth.instance.currentUser!.email}')
                      .doc('Outcome-catego')
                      .collection('data')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SpinKitPulse(
                            color: Colors.grey,
                          )
                        ],
                      );
                    }
                    if (snapshot.hasData) {
                      outcomecategostylelist = [];
                      for (var element in snapshot.data!.docs) {
                        data = element.data() as Map<String, dynamic>;
                        outcomecategostylelist.add(Categostyle(
                            categoname: data!['categoname'],
                            imgname: data!['imagId']));
                        // incomeCategoList.add(data!['categoname']);
                        // incomeCategoImgList.add(data!['imagId']);
                      }
                    }

                    return Card(
                      child: Container(
                        width: MediaQuery.of(context).size.width - 20,
                        child: SingleChildScrollView(
                            child: Column(children: outcomecategostylelist)),
                      ),
                    );
                  }),
            ],
          ),
        ));
  }
}

class Categostyle extends StatefulWidget {
  String categoname;
  String imgname;
  Categostyle({Key? key, required this.categoname, required this.imgname})
      : super(key: key);

  @override
  State<Categostyle> createState() => _CategostyleState();
}

class _CategostyleState extends State<Categostyle> {
  @override
  void initState() {
    outcomeEditdropdown = widget.imgname;
    newEditcatego = TextEditingController(text: widget.categoname);
    // TODO: implement initState
    super.initState();
  }

  TextEditingController newEditcatego = TextEditingController();
  String outcomeEditdropdown = 'a';
  void onSelected(int item, String categoname, String imgname) {
    switch (item) {
      case 0:
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                    contentPadding: const EdgeInsets.all(6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    content: Container(
                      height: 170,
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, right: 8),
                        child: Column(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(Icons.close)),
                            ),
                            Row(children: [
                              SizedBox(
                                width: 100,
                                height: 50,
                                child: DropdownButtonFormField(
                                  value: widget.imgname,
                                  isExpanded: true,
                                  items: outcomeImg
                                      .map((item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: SizedBox(
                                              width: 40,
                                              height: 40,
                                              child: Image(
                                                image: AssetImage(
                                                    'images/$item.png'),
                                              ))))
                                      .toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      widget.imgname = newValue.toString();
                                    });
                                  },
                                  decoration: InputDecoration(
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 1, color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              width: 1, color: Colors.black),
                                          borderRadius:
                                              BorderRadius.circular(5))),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 170,
                                height: 50,
                                child: TextFormField(
                                  controller: newEditcatego,
                                  validator: RequiredValidator(
                                      errorText:
                                          'Pls enter your category name'),
                                  decoration: InputDecoration(
                                    errorBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 1, color: Colors.redAccent),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          width: 1, color: Colors.black),
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 2, color: Colors.black),
                                        borderRadius: BorderRadius.circular(5)),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            width: 1, color: Colors.redAccent),
                                        borderRadius: BorderRadius.circular(5)),
                                    hintText: 'Create category',
                                  ),
                                ),
                              ),
                            ]),
                            const SizedBox(height: 15),
                            ElevatedButton(
                                onPressed: () async {
                                  print(
                                      '${newEditcatego.text} <<< and >>> ${widget.imgname}');
                                  outcomecategoDataEdit(
                                      widget.categoname, newEditcatego.text);
                                  user
                                      .doc('Outcome-catego')
                                      .collection('data')
                                      .doc(widget.categoname)
                                      .delete();
                                  user
                                      .doc('Outcome-catego')
                                      .collection('data')
                                      .doc(newEditcatego.text)
                                      .set({
                                    'categoname': newEditcatego.text,
                                    'imagId': widget.imgname
                                  });
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.blue[700],
                                  // padding: const EdgeInsets.all(10),
                                ),
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    alignment: Alignment.center,
                                    child: const Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Edit',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                    )))
                          ],
                        ),
                      ),
                    ));
              });
            });
        break;
      case 1:
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                contentPadding: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Do you want to delete ?",
                        style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "cancel",
                                style: TextStyle(fontSize: 12),
                              )),
                          TextButton(
                              onPressed: () {
                                outcomecategostylelist = [];
                                setState(() {
                                  print('something');
                                  outcomeCategoDelete(categoname);
                                  outcomecategoDataDelete(categoname);
                                  Navigator.pop(context);
                                  // incomecategoDataDelete(categoname);
                                });
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "delete",
                                style: TextStyle(fontSize: 12),
                              )),
                        ],
                      )
                    ],
                  ),
                ),
              );
            });
          },
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                height: 30,
                width: 30,
                child: Image(image: AssetImage('images/${widget.imgname}.png')),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(widget.categoname),
              )
            ],
          ),
          PopupMenuButton<int>(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            onSelected: (item) =>
                onSelected(item, widget.categoname, widget.imgname),
            itemBuilder: (context) => [
              const PopupMenuItem<int>(
                  value: 0,
                  child: Text(
                    "Edit",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  )),
              const PopupMenuItem<int>(
                  value: 1,
                  child: Text(
                    "Delete",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}