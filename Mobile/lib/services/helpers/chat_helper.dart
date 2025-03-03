import 'dart:convert';

import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:http/http.dart' as https;
import 'package:job_app/models/request/chat/create_chat.dart';
import 'package:job_app/models/response/chat/get_chat.dart';
import 'package:job_app/models/response/chat/initial_msg.dart';
import 'package:job_app/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatHelper {
  static var client = https.Client();

  //apply for job
  static Future<List<dynamic>> apply(CreateChat model) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'token': 'Bearer $token'
    };
    var url = Uri.http(Config.apiUrl, Config.chatsUrl);
    var response = await client.post(url,
        headers: requestHeaders, body: jsonEncode(model.toJson()));

    if (response.statusCode == 200) {
      var first = initialChatFromJson(response.body).id;
      return [true, first];
    } else {
      return [false];
    }
  }

  static Future<List<GetChats>> getConversations() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'token': 'Bearer $token'
    };
    var url = Uri.http(Config.apiUrl, Config.chatsUrl);
    var response = await client.get(url, headers: requestHeaders);

    if (response.statusCode == 200) {
      var chats = getChatsFromJson(response.body);
      return chats;
    } else {
      throw Exception("Error getConversations");
    }
  }

  static Future<String> getAnswerWithGemini(String question) async {
  try {
    final response = await Gemini.instance.prompt(parts: [
      Part.text(question),
    ]);
    return response?.output ?? 'No response';
  } catch (e) {
    return 'ERROR';
  }
}

  // Future<void> sendMessage(String userMessage) async {
  //   // Thêm tin nhắn người dùng vào danh sách
  //   messages.add({"role": "user", "content": userMessage});

  //   try {
  //     final response = await gemini.chat(messages);

  //     if (response?.content != null) {
  //       // Thêm phản hồi của AI vào danh sách
  //       messages.add({"role": "model", "content": response!.content!});
  //     }
  //   } catch (e) {
  //     print("Lỗi khi gửi tin nhắn: $e");
  //   }
  // }
}
