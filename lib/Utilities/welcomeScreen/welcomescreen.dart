import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Colors/color.dart';
import '../../layouts/ScreenLayout/screenlayout.dart';
import '../../layouts/VendorScreenLayout/mainscreen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              },
              child: Container(
                height: 40,
                width: 175,
                decoration: BoxDecoration(
                  color: primaryClr,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                    child: Text(
                  "Find Products",
                  style: TextStyle(
                    color: whiteclr,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w500,
                  ),
                )),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Center(
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ScreenLayout()));
              },
              child: Container(
                height: 40,
                width: 175,
                decoration: BoxDecoration(
                  color: primaryClr,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                    child: Text(
                  "Start as a Vender",
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w500,
                    color: whiteclr,
                  ),
                )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
