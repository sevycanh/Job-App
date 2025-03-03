import 'dart:convert';

SignUpModel signupModelFromJson(String str) => SignUpModel.fromJson(json.decode(str));

String signupModelToJson(SignUpModel data) => json.encode(data.toJson());

class SignUpModel {
    SignUpModel({
        required this.username,
        required this.email,
        required this.password,
    });

    final String username;
    final String email;
    final String password;

    factory SignUpModel.fromJson(Map<String, dynamic> json) => SignUpModel(
        username: json["username"],
        email: json["email"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "password": password,
    };
}
