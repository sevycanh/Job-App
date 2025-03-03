import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_app/models/request/auth/signup_model.dart';
import 'package:job_app/services/helpers/auth_helper.dart';
import 'package:job_app/views/ui/auth/login.dart';

import '../constants/app_constants.dart';

class SignUpNotifier extends ChangeNotifier {
// trigger to hide and unhide the password
  bool _isObscureText = true;

  bool get isObscure => _isObscureText;

  set isObscure(bool obsecure) {
    _isObscureText = obsecure;
    notifyListeners();
  }

// triggered when the login button is clicked to show the loading widget
  bool _processing = false;

  bool get processing => _processing;

  set processing(bool newValue) {
    _processing = newValue;
    notifyListeners();
  }

// triggered when the fist time when user login to be prompted to the update profile page
  bool _firstTime = false;

  bool get firstTime => _firstTime;

  set firstTime(bool newValue) {
    _firstTime = newValue;
    notifyListeners();
  }

  final signUpFormKey = GlobalKey<FormState>();

  bool passwordValidator(String password) {
    if (password.isEmpty) return false;
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(password);
  }

  bool validateAndSave() {
    final form = signUpFormKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  upSignUp(SignUpModel model) {
    AuthHelper.signUp(model).then((value) {
      if (value) {
        Get.off(() => const LoginPage());
      } else {
        print('false');
        Get.snackbar("SignUp Failed", "Please try again aaa",
            colorText: Color(kLight.value),
            backgroundColor: Color(kOrange.value),
            icon: const Icon(Icons.add_alert));
      }
    });
  }
}
