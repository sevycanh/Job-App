
import 'dart:convert';

BookmarkReqRes bookmarkReqResFromJson(String str) => BookmarkReqRes.fromJson(json.decode(str));

class BookmarkReqRes {
    final String id;

    BookmarkReqRes({
        required this.id,
    });

    factory BookmarkReqRes.fromJson(Map<String, dynamic> json) => BookmarkReqRes(
        id: json["_id"],
    );

}
