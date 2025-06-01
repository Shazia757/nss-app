import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nss/database/local_storage.dart';
import 'package:nss/view/authentication/login_screen.dart';
import 'package:nss/view/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3)).then(
      (value) {
        (LocalStorage().readUser().admissionNo == null)
            ? Get.offAll(() => LoginScreen())
            : Get.offAll(() => HomeScreen());
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              minRadius: 50,
              child: Image.asset("assets/logos/logo.png", height: 150),
            ),
            SizedBox(height: 25),
            Text(
              "NSS Farook College",
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
