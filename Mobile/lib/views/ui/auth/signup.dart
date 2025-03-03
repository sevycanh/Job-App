import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:job_app/controllers/exports.dart';
import 'package:job_app/controllers/signup_provider.dart';
import 'package:job_app/models/request/auth/signup_model.dart';
import 'package:job_app/views/ui/auth/login.dart';
import 'package:provider/provider.dart';

import '../../../constants/app_constants.dart';
import '../../common/app_bar.dart';
import '../../common/custom_btn.dart';
import '../../common/custom_textfield.dart';
import '../../common/exports.dart';
import '../../common/height_spacer.dart';
import '../../common/reusable_text.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var loginNotifier = Provider.of<LoginNotifier>(context);

    return Consumer<SignUpNotifier>(
      builder: (context, signUpNotifier, child) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: CustomAppBar(
              text: "Sign Up",
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: const Icon(CupertinoIcons.arrow_left),
              ),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Form(
              key: signUpNotifier.signUpFormKey,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const HeightSpacer(size: 50),
                  ReusableText(
                      text: 'Hello, welcome!',
                      style: appstyle(30, Color(kDark.value), FontWeight.w600)),
                  ReusableText(
                      text: "Fill the details to sign up for an account",
                      style: appstyle(
                          16, Color(kDarkGrey.value), FontWeight.w600)),
                  const HeightSpacer(size: 30),
                  CustomTextField(
                    controller: name,
                    keyboardType: TextInputType.text,
                    hintText: "Full name",
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your name";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const HeightSpacer(size: 20),
                  CustomTextField(
                    controller: email,
                    keyboardType: TextInputType.emailAddress,
                    hintText: "Email",
                    validator: (value) {
                      if (value!.isEmpty || !value.contains("@")) {
                        return "Please enter a valid email";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const HeightSpacer(size: 20),
                  CustomTextField(
                    controller: password,
                    keyboardType: TextInputType.text,
                    hintText: "Password",
                    validator: (value) {
                      if (value!.isEmpty || value.length < 5) {
                        return "Please enter a valid password >5 characters";
                      }
                      return null;
                    },
                    obscureText: signUpNotifier.isObscure,
                    suffixIcon: GestureDetector(
                      onTap: () {
                        signUpNotifier.isObscure = !signUpNotifier.isObscure;
                      },
                      child: Icon(
                        signUpNotifier.isObscure
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Color(kDark.value),
                      ),
                    ),
                  ),
                  const HeightSpacer(size: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => const LoginPage());
                      },
                      child: ReusableText(
                          text: 'Login',
                          style: appstyle(
                              14, Color(kDark.value), FontWeight.w500)),
                    ),
                  ),
                  const HeightSpacer(size: 50),
                  CustomButton(
                    onTap: () {
                      loginNotifier.firstTime = !loginNotifier.firstTime;
                      if (signUpNotifier.validateAndSave()) {
                        SignUpModel model = SignUpModel(
                            username: name.text,
                            email: email.text,
                            password: password.text);

                            signUpNotifier.upSignUp(model);
                      } else {
                        Get.snackbar("SignUp Failed", "Please try again bbb",
                            colorText: Color(kLight.value),
                            backgroundColor: Color(kOrange.value),
                            icon: const Icon(Icons.add_alert));
                      }
                    },
                    text: 'Sign Up',
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
