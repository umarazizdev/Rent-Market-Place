import 'package:figma2/Utilities/Colors/color.dart';
import 'package:flutter/material.dart';

class ReceiveMsg extends StatefulWidget {
  const ReceiveMsg(
      {super.key, required this.message, required this.date, required this.sc});
  final String message;
  final String date;
  final Size sc;

  @override
  State<ReceiveMsg> createState() => _ReceiveMsgState();
}

class _ReceiveMsgState extends State<ReceiveMsg> {
  @override
  Widget build(BuildContext context) {
    Size sc = Utils().getScreenSize();
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(
          top: 8,
          left: sc.width * 0.03,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: sc.height * 0.0075, bottom: sc.height * 0.008),
              padding: EdgeInsets.symmetric(
                  vertical: sc.height * 0.01, horizontal: sc.width * 0.02),
              decoration: const BoxDecoration(
                color: whiteclr,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Text(
                widget.message,
                style: TextStyle(
                  fontSize: sc.height * 0.02,
                  color: Colors.black,
                ),
              ),
            ),
            Text(
              widget.date,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                fontSize: sc.height * 0.015,
              ),
            )
          ],
        ),
      ),
    );
  }
}
