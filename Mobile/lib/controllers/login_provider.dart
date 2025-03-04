import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_app/views/ui/auth/update_user.dart';
import 'package:job_app/views/ui/mainscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import '../models/request/auth/login_model.dart';
import '../models/request/auth/profile_update_model.dart';
import '../services/helpers/auth_helper.dart';

class LoginNotifier extends ChangeNotifier {
  bool _obscureText = true;
  bool get obscureText => _obscureText;
  set obscureText(bool newState) {
    _obscureText = newState;
    notifyListeners();
  }

  bool _firstTime = false;
  bool get firstTime => _firstTime;
  set firstTime(bool newState) {
    _firstTime = newState;
    notifyListeners();
  }

  bool? _entrypoint;
  bool get entrypoint => _entrypoint ?? false;
  set entrypoint(bool newState) {
    _entrypoint = newState;
    notifyListeners();
  }

  bool? _loggedIn;
  bool get loggedIn => _loggedIn ?? false;
  set loggedIn(bool newState) {
    _loggedIn = newState;
    notifyListeners();
  }

  getPrefs() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    entrypoint = preferences.getBool('entrypoint') ?? false;
    loggedIn = preferences.getBool('loggedIn') ?? false;
  }

//   final loginFormKey = GlobalKey<FormState>();
//   final profileFormKey = GlobalKey<FormState>();

//   bool validateAndSave() {
//   final form = loginFormKey.currentState;
//   if (form != null && form.validate()) {
//     form.save();
//     return true;
//   }
//   return false;
// }

//   bool profileValidate() {
//     final form = profileFormKey.currentState;

//     if (form!.validate()) {
//       form.save();
//       return true;
//     } else {
//       return false;
//     }
//   }

  userLogin(LoginModel model) {
    AuthHelper.login(model).then((response) {
      if (response && firstTime) {
        Get.off(() => const PersonalDetails());
      } else if (response && !firstTime) {
        Get.off(() => const MainScreen());
      } else if (!response) {
        Get.snackbar("Sign Failed", "Please Check your credentials",
            colorText: Color(kLight.value),
            backgroundColor: Colors.red,
            icon: const Icon(Icons.add_alert));
      }
    });
  }

  logout() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool('loggedIn', false);
    await preferences.remove('token');
    _firstTime = false;
  }

  updateProfile(ProfileUpdateReq model) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userId = preferences.getString('userId');

    AuthHelper.updateProfile(model, userId ?? "").then((response) {
      if (response) {
        Get.snackbar("Profile Update", "Enjoy your search for a job",
            colorText: Color(kLight.value),
            backgroundColor: Color(kLightBlue.value),
            icon: const Icon(Icons.add_alert));

        Future.delayed(const Duration(seconds: 3)).then((value) {
          Get.offAll(() => const MainScreen());
        });
      } else {
        Get.snackbar("Updating Failed", "Please try again",
            colorText: Color(kLight.value),
            backgroundColor: Color(kOrange.value),
            icon: const Icon(Icons.add_alert));
      }
    });
  }
}
