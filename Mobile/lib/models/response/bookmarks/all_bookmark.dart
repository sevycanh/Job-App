import 'dart:convert';

List<AllBookmark> allBookmarkFromJson(String str) => List<AllBookmark>.from(json.decode(str).map((x) => AllBookmark.fromJson(x)));

String allBookmarkToJson(List<AllBookmark> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllBookmark {
    final String id;
    final Job job;
    final String userId;

    AllBookmark({
        required this.id,
        required this.job,
        required this.userId,
    });

    factory AllBookmark.fromJson(Map<String, dynamic> json) => AllBookmark(
        id: json["_id"],
        job: Job.fromJson(json["job"]),
        userId: json["userId"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "job": job.toJson(),
        "userId": userId,
    };
}

class Job {
    final String id;
    final String title;
    final String location;
    final String description;
    final String company;
    final String salary;
    final String period;
    final String contract;
    final List<String> requirements;
    final String imageUrl;
    final String agentId;

    Job({
        required this.id,
        required this.title,
        required this.location,
        required this.description,
        required this.company,
        required this.salary,
        required this.period,
        required this.contract,
        required this.requirements,
        required this.imageUrl,
        required this.agentId,
    });

    factory Job.fromJson(Map<String, dynamic> json) => Job(
        id: json["_id"],
        title: json["title"],
        location: json["location"],
        description: json["description"],
        company: json["company"],
        salary: json["salary"],
        period: json["period"],
        contract: json["contract"],
        requirements: List<String>.from(json["requirements"].map((x) => x)),
        imageUrl: json["imageUrl"],
        agentId: json["agentId"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "location": location,
        "description": description,
        "company": company,
        "salary": salary,
        "period": period,
        "contract": contract,
        "requirements": List<dynamic>.from(requirements.map((x) => x)),
        "imageUrl": imageUrl,
        "agentId": agentId,
    };
}
