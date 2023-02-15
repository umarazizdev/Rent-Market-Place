import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma2/Utilities/SignInScreen/loginscreen.dart';
import 'package:figma2/Utilities/welcomeScreen/welcomescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../Colors/color.dart';
import '../../main.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  signUp() async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailcontroller.text.trim(),
        password: passwordcontroller.text.trim(),
      );

      box.write('uid', credential.user!.uid);
      box.write('islogin', true);
      user.doc(credential.user!.uid).set({
        'name': firstnamecontroller.text,
        'uid': credential.user!.uid,
        'image': false,
        'avatar': '',
      });

      EasyLoading.showSuccess("Successfully SignUp");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => WelcomeScreen(),
          ),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        EasyLoading.showError('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        EasyLoading.showError('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  TextEditingController emailcontroller = TextEditingController();
  var passwordcontroller = TextEditingController();
  var firstnamecontroller = TextEditingController();
  var lastnamecontroller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 17.0, right: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  InkWell(
                    onTap: () {},
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
                              "Sign Up With",
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
                  const SizedBox(
                    height: 20,
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
                          "Or Sign Up With",
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
                    height: 22,
                  ),
                  SizedBox(
                    width: 391,
                    child: TextFormField(
                      controller: firstnamecontroller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter first name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            left: 33, top: 22, bottom: 18),
                        hintText: "First Name",
                        hintStyle: const TextStyle(
                            color: textClr,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
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
                  SizedBox(
                    width: 391,
                    child: TextFormField(
                      controller: lastnamecontroller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter last name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            left: 33, top: 22, bottom: 18),
                        hintText: "Last Name",
                        hintStyle: const TextStyle(
                            color: textClr,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
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
                  SizedBox(
                    width: 391,
                    child: TextFormField(
                      controller: emailcontroller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter email';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            left: 33, top: 22, bottom: 18),
                        hintText: "Enter Email",
                        hintStyle: const TextStyle(
                            color: textClr,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
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
                  SizedBox(
                    width: 391,
                    child: TextFormField(
                      controller: passwordcontroller,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(
                            left: 33, top: 22, bottom: 18),
                        hintText: "Enter Password",
                        hintStyle: const TextStyle(
                            color: textClr,
                            fontSize: 16,
                            fontWeight: FontWeight.w400),
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
                    height: 35,
                  ),
                  InkWell(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        EasyLoading.show();
                        signUp();
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
                          "Register",
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
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Row(
                        children: [
                          RichText(
                            text: const TextSpan(
                              text: "Already Have An Account",
                              style: TextStyle(
                                  color: textClr,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                              children: [
                                TextSpan(
                                    text: " Login",
                                    style: TextStyle(
                                        color: primaryClr, fontSize: 14))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
