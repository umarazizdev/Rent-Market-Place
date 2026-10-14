import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:figma2/Utilities/welcomeScreen/welcomescreen.dart';
import 'package:figma2/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleScreen extends StatefulWidget {
  const GoogleScreen({super.key});
  @override
  State<GoogleScreen> createState() => _GoogleScreenState();
}

class _GoogleScreenState extends State<GoogleScreen> {
  @override
  void initState() {
    super.initState();
    // Screen khulte hi direct Google login
    WidgetsBinding.instance.addPostFrameCallback((_) => _signInWithGoogle());
  }

  Future<void> _signInWithGoogle() async {
    try {
      EasyLoading.show(status: 'Signing with Google...');
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) { EasyLoading.dismiss(); Navigator.pop(context); return; }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      final userCred = await FirebaseAuth.instance.signInWithCredential(credential);
      
      await FirebaseFirestore.instance.collection('users').doc(userCred.user!.uid).set({
        'name': userCred.user!.displayName ?? 'User',
        'email': userCred.user!.email,
        'uid': userCred.user!.uid,
        'avatar': userCred.user!.photoURL ?? '',
        'image': true,
      }, SetOptions(merge: true));

      box.write('uid', userCred.user!.uid);
      box.write('islogin', true);
      EasyLoading.dismiss();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const WelcomeScreen()), (route) => false);
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // UI same rakha hai, bas loader dikhega
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 170, child: Image.asset("assets/google.png")),
            const SizedBox(height: 20),
            const CircularProgressIndicator(),
            const SizedBox(height: 10),
            const Text("Signing in with Google...")
          ],
        ),
      ),
    );
  }
}