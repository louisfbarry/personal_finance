import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finance/model/firebaseservice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

// ignore: must_be_immutable
class CategoDetail extends StatefulWidget {
  Stream<QuerySnapshot> userstream;
  CategoDetail({Key? key, required this.userstream}) : super(key: key);

  @override
  State<CategoDetail> createState() => _CategoDetailState();
}

class _CategoDetailState extends State<CategoDetail> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: widget.userstream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [CircularProgressIndicator()],
              );
            }
            List<DetailStyle> detail = [];
            snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              detail.add(DetailStyle(data: data));
            }).toList();
            return Column(
              children: detail,
            );
          },
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class DetailStyle extends StatefulWidget {
  Map<String, dynamic> data;
  DetailStyle({Key? key, required this.data}) : super(key: key);

  @override
  State<DetailStyle> createState() => _DetailStyleState();
}

class _DetailStyleState extends State<DetailStyle> {
  String showdate = '';

  bool confirmpass = true;

  bool submitted = false;

  bool isloading = false;

  String today = DateFormat("EEEEE, dd, MM, yyyy").format(DateTime.now());
  String yesterday = DateFormat("EEEEE, dd, MM, yyyy")
      .format(DateTime.now().subtract(const Duration(days: 1)));

  TextEditingController? amountcontroller;
  TextEditingController? categocontroller;

  datechecking() {
    if (widget.data['created At'].toString() == today) {
      showdate = 'today';
    } else if (widget.data['created At'].toString() == yesterday) {
      showdate = 'yesterday';
    } else {
      showdate = 'no One';
    }
  }

  @override
  void initState() {
    amountcontroller = TextEditingController(text: '${widget.data['amount']}');
    categocontroller =
        TextEditingController(text: '${widget.data['category']}');
    datechecking();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            backgroundColor: Colors.transparent,
            barrierColor: Colors.transparent,
            context: context,
            builder: (_) {
              return Container(
                height: 400,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(167, 220, 220, 220),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: IconButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, 'income');
                              },
                              icon: const Icon(Icons.close))),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 5.0),
                          child: Text('Amount'),
                        ),
                        SizedBox(
                          height: 60,
                          width: 300,
                          child: TextFormField(
                            controller: amountcontroller,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.number,
                            autovalidateMode: submitted
                                ? AutovalidateMode.always
                                : AutovalidateMode.disabled,
                            validator: RequiredValidator(
                                errorText: 'Pls enter your amount'),
                            decoration: InputDecoration(
                              errorBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.redAccent),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    width: 1, color: Colors.black),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 2,
                                      color: Color.fromARGB(157, 9, 237, 176)),
                                  borderRadius: BorderRadius.circular(10)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      width: 1, color: Colors.redAccent),
                                  borderRadius: BorderRadius.circular(10)),
                              // filled: true,
                              // fillColor: const Color.fromARGB(157, 9, 237, 176),

                              hintText: '${widget.data['amount']}',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ]),
                ),
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    showdate,
                    style: const TextStyle(color: Color.fromARGB(178, 0, 0, 0)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.badge_outlined),
                          Text(
                            '${widget.data['category']} ',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.black),
                          ),
                        ],
                      ),
                      Text(
                        '${widget.data['amount']} MMK',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
