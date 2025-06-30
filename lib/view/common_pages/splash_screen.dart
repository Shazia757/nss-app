import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nss/api.dart';
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
    Future.delayed(Duration(seconds: 1)).then(
      (value) {
        Api().checkVersion().then(
          (value) {
            if (value?.message == 'Up to date') {
              ((LocalStorage().readUser().admissionNo == null) || (LocalStorage().readUser().admissionNo == ''))
                  ? Get.offAll(() => LoginScreen())
                  : Get.offAll(
                      () => HomeScreen(),
                    );
            } else {
              if (value?.status ?? false) {
                Get.to(() => AppUpdateScreen(status: true));
              } else {
                Get.offAll(() => AppUpdateScreen(status: false));
              }
            }
            // if (value?.status ?? false) {
            //   ((LocalStorage().readUser().admissionNo == null) || (LocalStorage().readUser().admissionNo == ''))
            //       ? Get.offAll(() => LoginScreen())
            //       : Get.offAll(
            //           () => HomeScreen(),
            //         );
            // } else {
            //   Get.to(() => AppUpdateScreen());
            // }
          },
        );
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

class AppUpdateScreen extends StatelessWidget {
  const AppUpdateScreen({super.key, required this.status});
  final bool status;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: SizedBox(),
        actions: [
          TextButton(
              onPressed: () {
                ((LocalStorage().readUser().admissionNo == null) || (LocalStorage().readUser().admissionNo == ''))
                    ? Get.offAll(() => LoginScreen())
                    : Get.offAll(
                        () => HomeScreen(),
                      );
              },
              child: (status)
                  ? const Text(
                      "Skip",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    )
                  : SizedBox()),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Illustration or Icon
              Icon(
                Icons.system_update,
                size: 100,
                color: Colors.blueAccent,
              ),
              const SizedBox(height: 30),

              // Title
              (status)
                  ? const Text(
                      "Update Available",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    )
                  : const Text(
                      "Update Required",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
              const SizedBox(height: 16),

              // Subtitle / description
              const Text(
                "A new version of the app is available. Update now to enjoy the latest features and improvements.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Update Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Handle update logic
                  },
                  child: const Text(
                    "Update Now",
                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Skip Button
            ],
          ),
        ),
      ),
    );
  }
}
