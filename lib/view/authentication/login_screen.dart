import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nss/controller/account_controller.dart';
import 'package:nss/view/common_pages/custom_decorations.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AccountController c = Get.put(AccountController());
    final theme = Theme.of(context);
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                color: theme.colorScheme.onPrimary,
                image: DecorationImage(
                  image: AssetImage('assets/images/login-bg.png'),
                  fit: BoxFit.cover,
                )),
            child: ListView(children: [
              const SizedBox(height: 100),
              CircleAvatar(
                radius: 50,
                child: Image.asset("assets/logos/logo.png", height: 100),
              ),
              SizedBox(height: 10),
              Text(
                "NSS Farook College",
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              Card(
                  margin:
                      const EdgeInsets.only(bottom: 20, left: 20, right: 20),
                  color: theme.colorScheme.onPrimary,
                  elevation: 5,
                  child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(children: [
                        Text(
                          "Sign in to your account",
                          style: theme.textTheme.titleLarge,
                        ),
                        CustomWidgets().textField(
                            color: Colors.grey.shade100,
                            controller: c.userNameController,
                            label: "Admission No",
                            errorText: c.errorMessage.value.isNotEmpty
                                ? c.errorMessage.value
                                : null,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            margin: EdgeInsets.symmetric(vertical: 10)),
                        Obx(() => SizedBox(
                              height: 65,
                              child: CustomWidgets().textField(
                                color: Colors.grey.shade100,
                                controller: c.passwordController,
                                hideText: c.isObscure.value,
                                label: "Password",
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                suffix: GestureDetector(
                                  onTap: () => (c.isObscure.value)
                                      ? c.showPassword()
                                      : c.hidePassword(),
                                  child: Icon(
                                    c.isObscure.value
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            )),
                        const SizedBox(height: 20),
                        Obx(
                          () => c.isLoading.value
                              ? CircularProgressIndicator()
                              : CustomWidgets().buildActionButton(
                                  context: context,
                                  text: 'Login',
                                  color: theme.colorScheme.onPrimaryFixed,
                                  onPressed: () => c.login(),
                                ),
                        ),
                      ]))),
              const Align(
                  alignment: Alignment.bottomCenter,
                  child: Text("Version 0.0.1")),
              Obx(() => c.errorMessage.value.isNotEmpty
                  ? Text(
                      c.errorMessage.value,
                      style: TextStyle(color: Colors.red),
                    )
                  : SizedBox()),
            ])));
  }
}
