// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:figma2/main.dart';
// import 'package:flutter/material.dart';

// import '../../../Utilities/Colors/color.dart';

// class SellBottomBar extends StatelessWidget {
//   final String uid2;
//   SellBottomBar({
//     Key? key,
//     required this.uid2,
//   }) : super(key: key);

//   var message = TextEditingController();
//   CollectionReference messageStream =
//       FirebaseFirestore.instance.collection('Messages');
//   users() {
//     messageStream.doc().set(
//       {
//         'message': message.text.trim(),
//         'time': DateTime.now(),
//         'uid': box.read('uid'),
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return  Container(
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//       child: Row(
//         children: [
//           Expanded(
//             child: Container(
//               decoration: BoxDecoration(
//                 color: wbackgroundclr.withOpacity(0.6),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: TextFormField(
//                 controller: message,
//                 decoration: const InputDecoration(
//                   labelText: 'Enter message',
//                   labelStyle: TextStyle(fontSize: 13.5),
//                   floatingLabelBehavior: FloatingLabelBehavior.never,
//                   hintStyle: TextStyle(fontSize: 13.5),
//                   contentPadding:
//                       EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
//                   focusedBorder: OutlineInputBorder(
//                     borderSide: BorderSide.none,
//                   ),
//                   enabledBorder: UnderlineInputBorder(
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//                 validator: (value) {},
//                 onSaved: (value) {
//                   message.text = value!;
//                 },
//               ),
//             ),
//           ),
//           IconButton(
//             onPressed: () {
//               if (message.text.isNotEmpty) {
//                 users();
//                 message.clear();
//               }
//             },
//             icon: const Icon(
//               Icons.send_sharp,
//               color: primaryClr,
//             ),
//           ),
//         ],
//       ),
//     );
  
//     }
// }
