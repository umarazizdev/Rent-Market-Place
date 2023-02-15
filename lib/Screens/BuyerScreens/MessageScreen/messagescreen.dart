import 'package:flutter/material.dart';
import '../../../Utilities/Colors/color.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({Key? key}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  bool msg = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        msg = true;
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          "Messages",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: msg == true ? primaryClr : blackclr,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Container(
                          height: 2,
                          width: 85,
                          decoration: const BoxDecoration(color: blackclr),
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        msg = false;
                      });
                    },
                    child: Column(
                      children: [
                        Text(
                          "Notifications",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: msg == false ? primaryClr : blackclr,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Container(
                          height: 2,
                          width: 95,
                          decoration: const BoxDecoration(color: primaryClr),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Visibility(
              visible: msg == true ? true : false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 135),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/comments 2.png",
                        height: 90,
                      ),
                      const SizedBox(height: 30),
                      const Text("No Messages yet !",
                          style: TextStyle(
                              fontSize: 16.5, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 10),
                      const Text("Send your First messages",
                          style: TextStyle(
                              color: textClr,
                              fontSize: 16.5,
                              fontWeight: FontWeight.w500))
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: msg == false ? true : false,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 135),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/notifications 1.png",
                        height: 90,
                      ),
                      const SizedBox(height: 30),
                      const Text("No Notification yet !",
                          style: TextStyle(
                              fontSize: 16.5, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 10),
                      const Text("Send your First messages",
                          style: TextStyle(
                              color: textClr,
                              fontSize: 16.5,
                              fontWeight: FontWeight.w500))
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
