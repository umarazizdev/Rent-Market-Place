// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:figma2/Screens/SellerScreens/MessageScreen/receiverbubble.dart';
// import 'package:figma2/Utilities/Colors/color.dart';
// import 'package:figma2/main.dart';
// import 'package:flutter/material.dart';

// import '../../BuyerScreens/MessageScreen/sender.dart';

// class SellMessageBody extends StatefulWidget {
//   final String uid1;

//   const SellMessageBody({super.key, required this.uid1});
//   @override
//   _SellMessageBodyState createState() => _SellMessageBodyState();
// }

// class _SellMessageBodyState extends State<SellMessageBody> {
//   Stream<QuerySnapshot>? messageStream;
//   @override
//   void initState() {
//     messageStream = FirebaseFirestore.instance
//         .collection('Messages')
//         .where('customerid', isEqualTo: widget.uid1)
//         .where('vendorid', isEqualTo: box.read('uid'))
//         .orderBy('createdAt', descending: true)
//         .snapshots();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size sc = Utils().getScreenSize();
//     return
//      StreamBuilder(
//       stream: messageStream,
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (snapshot.hasError) {
//           return const Text("something is wrong");
//         }
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(
//             child: CircularProgressIndicator(
//               strokeWidth: 1,
//               color: primaryClr,
//             ),
//           );
//         }
//         final data = snapshot.data!.docs;
//         return Expanded(
//           child: ListView.builder(
//             itemCount: data.length,
//             reverse: true,
//             physics: const ScrollPhysics(),
//             shrinkWrap: true,
//             itemBuilder: (context, index) {
//               Timestamp t = data[index]['time'];
//               DateTime d = t.toDate();
//               return data[index]['customer'] == false
//                   ? SenderBubble(
//                       message: data[index]['message'],
//                       date: d.hour.toString() + ":" + d.minute.toString(),
//                       sc: sc)
//                   : ReceiveMsg(
//                       message: data[index]['message'],
//                       date: d.hour.toString() + ":" + d.minute.toString(),
//                       sc: sc);
//             },
//           ),
//         );
//       },
//     );
//   }
// }
