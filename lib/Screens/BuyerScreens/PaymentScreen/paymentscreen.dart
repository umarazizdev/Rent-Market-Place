import 'package:flutter/material.dart';

import '../../../Utilities/Colors/color.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 3,
                  ),
                  const Text(
                    "Payment Slection",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 19,
                      color: primaryClr,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                    height: 2,
                    width: 145,
                    decoration: const BoxDecoration(
                      color: Color(0xff5A5757),
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                ],
              ),
            ),
            const Center(
              child: Text(
                "Payment Methods",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 19,
                ),
              ),
            ),
            const SizedBox(
              height: 45,
            ),
            Center(
              child: Container(
                height: 30,
                width: 225,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(
                    color: const Color(0xff63B1F9),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 13,
                            width: 14,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: blackclr, width: 1.3)),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Text(
                            "Feature Ad For 7 Days",
                            style: TextStyle(
                                fontSize: 8, fontWeight: FontWeight.w400),
                          ),
                        ],
                      ),
                      const Text(
                        "\&350/Only",
                        style: TextStyle(
                            fontSize: 8,
                            color: primaryClr,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 14,
            ),
            const Center(
              child: Text(
                "Select Your Payment Mehtod",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(
              height: 35,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 23.0),
              child: Row(
                children: [
                  Image.asset(
                    "assets/174861.png",
                    height: 26,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const Text(
                    "PayPal",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            const Divider(
              thickness: 1.6,
              color: Color(0xffD9D9D9),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 23.0),
              child: Row(
                children: [
                  Image.asset(
                    "assets/3771347.png",
                    height: 26,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    "Payment With Bank Account",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Center(
              child: SizedBox(
                height: 40,
                width: 200,
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: primaryClr,
                  onPressed: () {},
                  child: const Text(
                    "Pay",
                    style: TextStyle(
                      color: whiteclr,
                      fontSize: 21,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
