import 'package:figma2/Screens/BuyerScreens/PaymentScreen/paymentscreen.dart';
import 'package:flutter/material.dart';

import '../../../Utilities/Colors/color.dart';

class BoosterScreen extends StatefulWidget {
  const BoosterScreen({super.key});

  @override
  State<BoosterScreen> createState() => _BoosterScreenState();
}

class _BoosterScreenState extends State<BoosterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: wbackgroundclr,
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 3,
            ),
            const Text(
              "Booster",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20,
                color: primaryClr,
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Container(
              height: 1,
              width: 75,
              decoration: const BoxDecoration(
                color: Color(0xff5A5757),
              ),
            ),
            const SizedBox(
              height: 76,
            ),
            Container(
              height: 355,
              width: 300,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      offset: Offset(10, 15),
                      color: Colors.grey,
                      blurRadius: 5,
                      spreadRadius: 3),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Container(
                      height: 85,
                      width: 225,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        border: Border.all(
                          color: const Color(0xff63B1F9),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 9.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 17,
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 17,
                                  width: 18,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: blackclr,
                                    ),
                                  ),
                                  child: Center(
                                    child: Container(
                                      height: 10,
                                      width: 11,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: blackclr,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Text(
                                  "Feature Ad For14 Days",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text(
                              "Reach up to 6Times more Buyers Primium Mobiles",
                              style: TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff928D8D),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
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
                                      border: Border.all(color: blackclr)),
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
                            Row(
                              children: const [
                                Text(
                                  "&350/Only",
                                  style: TextStyle(
                                      fontSize: 8,
                                      color: primaryClr,
                                      fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Heavy Discounts And Pakages",
                            style: TextStyle(
                              color: blackclr,
                              fontWeight: FontWeight.w700,
                              fontSize: 8,
                            ),
                          ),
                          Text(
                            "View Pakages",
                            style: TextStyle(
                              color: primaryClr,
                              fontWeight: FontWeight.w700,
                              fontSize: 8,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Container(
                        height: 2,
                        width: 220,
                        decoration:
                            const BoxDecoration(color: Color(0xff7D756C)),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "What Is Featured Ad?",
                            style: TextStyle(
                              color: blackclr,
                              fontWeight: FontWeight.w700,
                              fontSize: 8,
                            ),
                          ),
                          Text(
                            "See Examples",
                            style: TextStyle(
                              color: primaryClr,
                              fontWeight: FontWeight.w700,
                              fontSize: 8,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 36,
                      width: 250,
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        color: primaryClr,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PaymentScreen(),
                              ));
                        },
                        child: const Text(
                          "Proceed To Pay",
                          style: TextStyle(
                            color: whiteclr,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
