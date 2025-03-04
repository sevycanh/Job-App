import 'dart:convert';

import 'package:http/http.dart' as https;
import 'package:job_app/models/request/auth/profile_update_model.dart';
import 'package:job_app/models/request/auth/signup_model.dart';
import 'package:job_app/models/response/auth/login_res_model.dart';
import 'package:job_app/models/response/auth/profile_model.dart';
import 'package:job_app/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/request/auth/login_model.dart';

class AuthHelper {
  static var client = https.Client();
  static Future<bool> login(LoginModel model) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    var url = Uri.http(Config.apiUrl, Config.loginUrl);
    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model),
    );

    if (response.statusCode == 200) {
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();

      String token = loginResponseModelFromJson(response.body).userToken;
      String userID = loginResponseModelFromJson(response.body).id;
      String profile = loginResponseModelFromJson(response.body).profile;

      await preferences.setString('token', token);
      await preferences.setString('userId', userID);
      await preferences.setString('profile', profile);
      await preferences.setBool('loggedIn', true);
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> signUp(SignUpModel model) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    var url = Uri.http(Config.apiUrl, Config.signUpUrl);
    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> updateProfile(
      ProfileUpdateReq model, String userId) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'token': 'Bearer $token'
    };
    var url = Uri.http(Config.apiUrl, Config.profileUrl);
    var response = await client.put(
      url,
      headers: requestHeaders,
      body: jsonEncode(model),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<ProfileRes> getProfile() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'token': 'Bearer $token'
    };
    var url = Uri.http(Config.apiUrl, Config.profileUrl);
    var response = await client.get(
      url,
      headers: requestHeaders,
    );

    if (response.statusCode == 200) {
      var profile = profileResFromJson(response.body);
      return profile;
    } else {
      throw Exception("Failed to get the profile");
    }
  }
}
