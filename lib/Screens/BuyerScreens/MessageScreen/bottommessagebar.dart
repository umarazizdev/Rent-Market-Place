import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma2/main.dart';
import 'package:flutter/material.dart';

import '../../../Utilities/Colors/color.dart';

class BottomMeassageBar extends StatefulWidget {
  final String id;
  BottomMeassageBar({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<BottomMeassageBar> createState() => _BottomMeassageBarState();
}

class _BottomMeassageBarState extends State<BottomMeassageBar> {
  var message = TextEditingController();

  CollectionReference messageStream =
      FirebaseFirestore.instance.collection('Messages');
  CollectionReference inbox = FirebaseFirestore.instance.collection('inbox');

  users() {
    messageStream.doc().set(
      {
        'message': message.text,
        'time': DateTime.now(),
        'customerid': box.read('uid'),
        'vendorid': widget.id,
        'customer': true,
        'createdAt': Timestamp.now(),
      },
    );
    if (!exist) {
      addInbox();
      setState(() {
        exist = true;
      });
    }
  }

  bool exist = false;
  checkUserExistInbox() async {
    FirebaseFirestore.instance
        .collection('inbox')
        .where('customerid', isEqualTo: box.read('uid'))
        .where('vendorid', isEqualTo: widget.id)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc.exists) {
          setState(() {
            exist = true;
          });
        }
      });
    });
  }

  @override
  void initState() {
    checkUserExistInbox();
    super.initState();
  }

  Future<void> addInbox() {
    // Call the user's CollectionReference to add a new user
    return inbox
        .add({'customerid': box.read('uid'), 'vendorid': widget.id})
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: wbackgroundclr,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TextFormField(
                  controller: message,
                  decoration: const InputDecoration(
                    labelText: 'Enter message',
                    labelStyle: TextStyle(fontSize: 13.5),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    hintStyle: TextStyle(fontSize: 13.5),
                    contentPadding:
                        EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {},
                  onSaved: (value) {
                    message.text = value!;
                  },
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                if (message.text.isNotEmpty) {
                  users();
                  message.clear();
                }
              },
              icon: const Icon(
                Icons.send_sharp,
                color: primaryClr,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
