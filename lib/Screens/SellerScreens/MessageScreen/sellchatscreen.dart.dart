import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma2/Screens/SellerScreens/MessageScreen/receiverbubble.dart';
import 'package:figma2/Screens/SellerScreens/MessageScreen/sellmesssagebody.dart';
import 'package:figma2/Utilities/Colors/color.dart';
import 'package:figma2/main.dart';
import 'package:flutter/material.dart';

import '../../BuyerScreens/MessageScreen/sender.dart';

class SellChatScreen extends StatefulWidget {
  final String ven;
  final String cus;
  const SellChatScreen({
    super.key,
    required this.ven,
    required this.cus,
  });

  @override
  State<SellChatScreen> createState() => _SellChatScreenState();
}

class _SellChatScreenState extends State<SellChatScreen> {
  Stream<QuerySnapshot>? _usersStream;
  Stream<QuerySnapshot>? messageStream1;
  @override
  void initState() {
    // checkUserExistInbox();

    messageStream1 = FirebaseFirestore.instance
        .collection('Messages')
        .where('customerid', isEqualTo: widget.ven)
        .where('vendorid', isEqualTo: box.read('uid'))
        .orderBy('createdAt', descending: true)
        .snapshots();
    super.initState();
  }

  var message = TextEditingController();

  CollectionReference inbox = FirebaseFirestore.instance.collection('inbox');

  CollectionReference messageStream =
      FirebaseFirestore.instance.collection('Messages');
  seller() {
    messageStream.doc().set(
      {
        'message': message.text,
        'time': DateTime.now(),
        'customerid': widget.ven,
        'vendorid': box.read('uid'),
        'customer': false,
        'createdAt': Timestamp.now(),
      },
    );
  }

  Future<void> addInbox() {
    // Call the user's CollectionReference to add a new user
    return inbox
        .add({'customerid': widget.ven, 'vendorid': box.read('uid')})
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    Size sc = Utils().getScreenSize();
    return Scaffold(
      backgroundColor: gbackgroundClr,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: primaryClr),
        backgroundColor: wbackgroundclr.withOpacity(0.6),
        elevation: 0,
        title: StreamBuilder<QuerySnapshot>(
          stream: _usersStream = FirebaseFirestore.instance
              .collection('users')
              .where('uid', isEqualTo: widget.ven)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading...");
            }

            return ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.all(0),
              itemCount: 1,
              itemBuilder: (context, index) {
                final data = snapshot.data!.docs[index];
                return InkWell(
                  onTap: () {},
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: data['image'] == true
                            ? NetworkImage(
                                data['avatar'],
                              )
                            : const NetworkImage(
                                "https://www.lightsong.net/wp-content/uploads/2020/12/blank-profile-circle.png",
                              ),
                      ),
                      SizedBox(
                        width: sc.width * 0.013,
                      ),
                      SizedBox(
                        width: sc.width * 0.29,
                        child: Text(
                          data['name'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                              fontSize: 13,
                              color: blackclr,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),

        /* Row(
          children: [
            const CircleAvatar(),
            const SizedBox(
              width: 6,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: sc.width * 0.32,
                  child: Text(
                    widget.cus,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                        fontSize: 14,
                        color: blackclr,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
        */
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.video_call)),
        ],
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: messageStream1,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text("something is wrong");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 1,
                    color: primaryClr,
                  ),
                );
              }
              final data = snapshot.data!.docs;
              return Expanded(
                child: ListView.builder(
                  itemCount: data.length,
                  reverse: true,
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    Timestamp t = data[index]['time'];
                    DateTime d = t.toDate();
                    return data[index]['customer'] == false
                        ? SenderBubble(
                            message: data[index]['message'],
                            date: d.hour.toString() + ":" + d.minute.toString(),
                            sc: sc)
                        : ReceiveMsg(
                            message: data[index]['message'],
                            date: d.hour.toString() + ":" + d.minute.toString(),
                            sc: sc);
                  },
                ),
              );
            },
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: wbackgroundclr.withOpacity(0.6),
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
                      seller();

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
        ],
      ),
    );
  }
}
