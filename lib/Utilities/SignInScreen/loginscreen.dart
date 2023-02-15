import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../Colors/color.dart';
import '../../main.dart';
import '../../Screens/BuyerScreens/GoogleScreen/googlescreen.dart';
import '../SignUpScreen/signupscreen.dart';
import '../welcomeScreen/welcomescreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isChecked = false;
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  signin() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailcontroller.text, password: passwordcontroller.text);
      box.write("uid", credential.user!.uid);
      box.write("islogin", true);
      EasyLoading.showToast("Successfully signin");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: ((context) => const WelcomeScreen())),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        EasyLoading.showError("No user found for that email.");
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        EasyLoading.showError("Wrong password provided for that user.");

        print('Wrong password provided for that user.');
      }
    }
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 15),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  // ?????????????????????????????1st container
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GoogleScreen(),
                        ),
                      );
                    },
                    child: Container(
                      height: 55,
                      width: 391,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(45),
                        border: Border.all(
                          color: borderClr,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 70.0,
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/unnamed-removebg.png",
                              height: 40,
                            ),
                            const Text(
                              "Sign In With",
                              style: TextStyle(
                                fontSize: 14,
                                color: textClr,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ?????????????????????????????2nd container
                  const SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      children: [
                        Container(
                          height: 1,
                          width: 80,
                          decoration: const BoxDecoration(color: borderClr),
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        const Text(
                          "Or Sign In With",
                          style: TextStyle(
                              fontSize: 14,
                              color: textClr,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Container(
                          height: 1,
                          width: 85,
                          decoration: const BoxDecoration(color: borderClr),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
                    width: 391,
                    child: TextFormField(
                      controller: emailcontroller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            left: 43, top: 23, bottom: 17),
                        hintText: "Enter Email",
                        hintStyle: const TextStyle(
                            color: textClr, fontWeight: FontWeight.w400),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(45),
                          borderSide: const BorderSide(color: borderClr),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(45),
                          borderSide: const BorderSide(color: borderClr),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(45),
                          borderSide: const BorderSide(color: redclr),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(45),
                          borderSide: const BorderSide(color: redclr),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  // ?????????????????????????????3rd container

                  SizedBox(
                    height: 55,
                    width: 391,
                    child: TextFormField(
                      obscureText: true,
                      controller: passwordcontroller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            left: 43, top: 23, bottom: 17),
                        hintText: "Enter Password",
                        hintStyle: const TextStyle(
                            color: textClr, fontWeight: FontWeight.w400),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(45),
                          borderSide: const BorderSide(color: borderClr),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(45),
                          borderSide: const BorderSide(color: borderClr),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(45),
                          borderSide: const BorderSide(color: redclr),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(45),
                          borderSide: const BorderSide(color: redclr),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        checkColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith(
                            (states) => borderClr),
                        value: isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isChecked = value!;
                          });
                        },
                      ),
                      RichText(
                        text: const TextSpan(
                          text: "Remember Me",
                          style: TextStyle(
                              color: textClr,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                          children: [
                            TextSpan(
                                text: "*", style: TextStyle(color: primaryClr))
                          ],
                        ),
                      )
                    ],
                  ),
                  // ???????????????????????????????????4rth container
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        EasyLoading.show();
                        signin();
                      }
                    },
                    child: Container(
                      height: 55,
                      width: 391,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(45),
                          color: primaryClr),
                      child: const Center(
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 24,
                            color: wbackgroundclr,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 23,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Row(
                        children: [
                          RichText(
                            text: const TextSpan(
                              text: "Not Ragister Yet?",
                              style: TextStyle(
                                  color: textClr,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400),
                              children: [
                                TextSpan(
                                    text: " Create An Account",
                                    style: TextStyle(color: primaryClr))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
