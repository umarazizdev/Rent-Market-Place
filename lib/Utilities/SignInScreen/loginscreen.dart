import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../Colors/color.dart';
import '../../main.dart';
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
        email: emailcontroller.text.trim(),
        password: passwordcontroller.text.trim(),
      );
      box.write("uid", credential.user!.uid);
      box.write("islogin", true);
      EasyLoading.dismiss();
      EasyLoading.showToast("Successfully signin");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: ((context) => const WelcomeScreen())),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      if (e.code == 'user-not-found') {
        EasyLoading.showError("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        EasyLoading.showError("Wrong password provided for that user.");
      } else {
        EasyLoading.showError(e.message.toString());
      }
    }
  }

  // GOOGLE LOGIN - DIRECT
 Future<void> signInWithGoogle() async {
  try {
    EasyLoading.show(status: 'Signing with Google...');
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      EasyLoading.dismiss();
      return;
    }
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCred = await FirebaseAuth.instance.signInWithCredential(credential);

    // Merge = true se user ka data overwrite nahi hoga
    await FirebaseFirestore.instance.collection('users').doc(userCred.user!.uid).set({
      'name': userCred.user!.displayName ?? 'User',
      'email': userCred.user!.email,
      'uid': userCred.user!.uid,
      'avatar': userCred.user!.photoURL ?? '',
      'image': true,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    box.write("uid", userCred.user!.uid);
    box.write("islogin", true);
    EasyLoading.dismiss();
    EasyLoading.showSuccess("Successfully signin");
    
    if(!mounted) return;
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: ((context) => const WelcomeScreen())),
        (route) => false);
  } catch (e) {
    EasyLoading.dismiss();
    EasyLoading.showError(e.toString());
    debugPrint("Google Error: $e");
  }
}

  bool obsecureText = true;
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
                  const SizedBox(height: 50),
                  InkWell(
                    onTap: () {
                      // FIXED: Direct Google Login, GoogleScreen pe nahi bhejna
                      signInWithGoogle();
                    },
                    child: Container(
                      height: 55,
                      width: 391,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(45),
                        border: Border.all(color: borderClr),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 70.0),
                        child: Row(
                          children: [
                            Image.asset("assets/unnamed-removebg.png", height: 40),
                            const Text("Sign In With", style: TextStyle(fontSize: 14, color: textClr, fontWeight: FontWeight.w400)),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      children: [
                        Container(height: 1, width: 80, decoration: const BoxDecoration(color: borderClr)),
                        const SizedBox(width: 3),
                        const Text("Or Sign In With", style: TextStyle(fontSize: 14, color: textClr, fontWeight: FontWeight.w400)),
                        const SizedBox(width: 3),
                        Container(height: 1, width: 85, decoration: const BoxDecoration(color: borderClr)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: 391,
                    child: TextFormField(
                      controller: emailcontroller,
                      validator: (value) => value == null || value.isEmpty ? 'Please enter your email' : null,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(left: 43, top: 23, bottom: 17),
                        hintText: "Enter Email",
                        hintStyle: const TextStyle(color: textClr, fontWeight: FontWeight.w400),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(45), borderSide: const BorderSide(color: borderClr)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(45), borderSide: const BorderSide(color: borderClr)),
                        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(45), borderSide: const BorderSide(color: redclr)),
                        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(45), borderSide: const BorderSide(color: redclr)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 55,
                    width: 391,
                    child: TextFormField(
                      obscureText: obsecureText,
                      controller: passwordcontroller,
                      validator: (value) => value == null || value.isEmpty ? 'Please enter your password' : null,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => obsecureText = !obsecureText),
                          icon: Icon(obsecureText ? Icons.visibility : Icons.visibility_off),
                        ),
                        contentPadding: const EdgeInsets.only(left: 43, top: 23, bottom: 17),
                        hintText: "Enter Password",
                        hintStyle: const TextStyle(color: textClr, fontWeight: FontWeight.w400),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(45), borderSide: const BorderSide(color: borderClr)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(45), borderSide: const BorderSide(color: borderClr)),
                        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(45), borderSide: const BorderSide(color: redclr)),
                        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(45), borderSide: const BorderSide(color: redclr)),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(checkColor: Colors.white, fillColor: MaterialStateProperty.resolveWith((states) => borderClr), value: isChecked, onChanged: (bool? value) => setState(() => isChecked = value!)),
                      RichText(text: const TextSpan(text: "Remember Me", style: TextStyle(color: textClr, fontSize: 12, fontWeight: FontWeight.w400), children: [TextSpan(text: "*", style: TextStyle(color: primaryClr))])),
                    ],
                  ),
                  const SizedBox(height: 20),
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
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(45), color: primaryClr),
                      child: const Center(child: Text("Login", style: TextStyle(fontSize: 24, color: wbackgroundclr, fontWeight: FontWeight.w700))),
                    ),
                  ),
                  const SizedBox(height: 23),
                  InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen())),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Row(children: [RichText(text: const TextSpan(text: "Not Ragister Yet?", style: TextStyle(color: textClr, fontSize: 12, fontWeight: FontWeight.w400), children: [TextSpan(text: " Create An Account", style: TextStyle(color: primaryClr))]))]),
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