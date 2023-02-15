import 'package:figma2/Utilities/SignInScreen/loginscreen.dart';
import 'package:figma2/Utilities/welcomeScreen/welcomescreen.dart';
import 'package:figma2/Utilities/Colors/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_storage/get_storage.dart';

final box = GetStorage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // Future userSignIn() async {
  //   if (box.read('islogin') == true) {
  //     return const WelcomeScreen();
  //   } else {
  //     return const LoginScreen();
  //   }
  // }

  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Figma',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, AsyncSnapshot<User?> user) {
            if (user.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryClr,
                ),
              );
            } else if (user.hasData) {
              return const WelcomeScreen();
            } else {
              return const LoginScreen();
            }
          }),
      builder: EasyLoading.init(),
    );
  }
}
