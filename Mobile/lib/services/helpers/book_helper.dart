import 'dart:convert';

import 'package:http/http.dart' as https;
import 'package:job_app/models/request/bookmarks/bookmarks_model.dart';
import 'package:job_app/models/response/bookmarks/all_bookmark.dart';
import 'package:job_app/models/response/bookmarks/book_res.dart';
import 'package:job_app/services/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookMarkHelper {
  static var client = https.Client();

  static Future<List<dynamic>> addBookmark(BookmarkReqResModel model) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'token': 'Bearer $token'
    };
    var url = Uri.http(Config.apiUrl, Config.bookmarkUrl);
    var response = await client.post(
      url,
      headers: requestHeaders,
      body: jsonEncode(model.toJson())
    );

    if (response.statusCode == 200) { // trả về 200 là sai (201 mới đúng) nhưng do trong BE để status(200) giờ phải ghi theo nếu ko phải sửa lại BE
      String bookmarkID = bookmarkReqResFromJson(response.body).id;
      return [true, bookmarkID];
    } else {
      return [false];
    }
  }

  static Future<bool> deleteBookmark(String jobId) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'token': 'Bearer $token'
    };
    var url = Uri.http(Config.apiUrl, "${Config.bookmarkUrl}/$jobId");
    print(url.toString());
    var response = await client.delete(
      url,
      headers: requestHeaders
    );

    print(response.statusCode.toString());

    if (response.statusCode == 200) { // trả về 200 là sai (201 mới đúng) nhưng do trong BE để status(200) giờ phải ghi theo nếu ko phải sửa lại BE
      return true;
    } else {
      return false;
    }
  }

  static Future<List<AllBookmark>> getBookmarks() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('token');

    Map<String, String> requestHeaders = {
      'Content-Type': 'application/json',
      'token': 'Bearer $token'
    };
    var url = Uri.http(Config.apiUrl, Config.bookmarkUrl);
    var response = await client.get(
      url,
      headers: requestHeaders
    );

    if (response.statusCode == 200) { 
      print("1" + response.body);
      var bookmarks = allBookmarkFromJson(response.body);
      print(bookmarks.toString());
      return bookmarks;
    } else {
      throw Exception('Failed to load bookmarks');
    }
  }
}
