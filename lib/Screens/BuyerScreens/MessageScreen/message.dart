import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma2/Screens/BuyerScreens/MessageScreen/sender.dart';
import 'package:figma2/Utilities/Colors/color.dart';
import 'package:figma2/main.dart';
import 'package:flutter/material.dart';

import '../../SellerScreens/MessageScreen/receiverbubble.dart';

class Messages extends StatefulWidget {
  final String id;

  const Messages({super.key, required this.id});
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  Stream<QuerySnapshot>? messageStream;
  @override
  void initState() {
    messageStream = FirebaseFirestore.instance
        .collection('Messages')
        .where('customerid', isEqualTo: box.read('uid'))
        .where('vendorid', isEqualTo: widget.id)
        .orderBy('createdAt', descending: true)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size sc = Utils().getScreenSize();
    return StreamBuilder(
      stream: messageStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
        return Expanded(
          child: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            reverse: true,
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final data = snapshot.data!.docs;

              Timestamp t = data[index]['time'];
              DateTime d = t.toDate();
              return data[index]['customer'] == true
                  ? SenderBubble(
                      message: data[index]['message'],
                      date: d.hour.toString() + ":" + d.minute.toString(),
                      sc: sc)
                  : ReceiveMsg(
                      message: data[index]['message'],
                      date: d.hour.toString() + ':' + d.minute.toString(),
                      sc: sc);
              //     Row(
              //   mainAxisAlignment: data[index]['customer'] == true
              //       ? MainAxisAlignment.end
              //       : MainAxisAlignment.start,
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Container(
              //         decoration: BoxDecoration(
              //             color: data[index]['customer'] == true
              //                 ? primaryClr
              //                 : wbackgroundclr),
              //         child: Padding(
              //           padding: const EdgeInsets.all(8.0),
              //           child: Text(
              //             data[index]['message'],
              //             style: TextStyle(
              //                 color: data[index]['customer'] == true
              //                     ? whiteclr
              //                     : blackclr),
              //           ),
              //         ),
              //       ),
              //     ),
              //   ],
              // );

              // if (box.read('isSender') == true) {
              //   return SenderBubble(
              //     message: data[index]['message'],
              //     date: d.hour.toString() + ":" + d.minute.toString(),
              //     sc: sc,
              //   );
              // } else {
              //   return ReceiveMsg(
              //       message: data[index]['message'],
              //       date: d.hour.toString() + ":" + d.minute.toString(),
              //       sc: sc);
              // }
            },
          ),
        );
      },
    );
  }
}
