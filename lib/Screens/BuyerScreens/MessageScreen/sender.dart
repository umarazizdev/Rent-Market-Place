import 'package:flutter/material.dart';

import '../../../Utilities/Colors/color.dart';

class SenderBubble extends StatefulWidget {
  const SenderBubble(
      {super.key, required this.message, required this.date, required this.sc});
  final String message;
  final String date;
  final Size sc;
  @override
  State<SenderBubble> createState() => _SenderBubbleState();
}

class _SenderBubbleState extends State<SenderBubble> {
  @override
  Widget build(BuildContext context) {
    Size sc = Utils().getScreenSize();
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.only(
          top: 8,
          right: sc.width * 0.03,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: sc.height * 0.0075, bottom: sc.height * 0.008),
              padding: EdgeInsets.symmetric(
                  vertical: sc.height * 0.01, horizontal: sc.width * 0.02),
              decoration: const BoxDecoration(
                color: primaryClr,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Text(
                widget.message,
                style: TextStyle(
                  fontSize: sc.height * 0.02,
                  color: Colors.white.withOpacity(0.9),
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
