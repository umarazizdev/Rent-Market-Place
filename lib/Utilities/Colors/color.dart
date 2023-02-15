import 'package:flutter/material.dart';

const wbackgroundclr = Color(0xffFFFFFF);
const primaryClr = Color(0xff0D86F5);
const gbackgroundClr = Color(0xffEAEAEA);
const borderClr = Color(0xff5A5757);
const textClr = Color(0xff5A5757);
const whiteclr = Colors.white;
const blackclr = Colors.black;
const redclr = Colors.red;

class Utils {
  getScreenSize() {
    return MediaQueryData.fromWindow(WidgetsBinding.instance.window).size;
  }
}
