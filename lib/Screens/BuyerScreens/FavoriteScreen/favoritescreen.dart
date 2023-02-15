import 'package:flutter/material.dart';

import '../../../Utilities/Colors/color.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const Text(
                "My Favourites",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 30,
                  color: primaryClr,
                ),
              ),
              const SizedBox(
                height: 3,
              ),
              Container(
                height: 1,
                width: 175,
                decoration: const BoxDecoration(color: blackclr),
              ),
              const SizedBox(
                height: 130,
              ),
              Image.asset(
                "assets/love 1.png",
                height: 130,
              ),
              const SizedBox(
                height: 21,
              ),
              const Text(
                "Your Favourate List is Empty",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
              )
            ],
          ),
        ),
      ),
    );
  }
}
