import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_app/constants/app_constants.dart';
import 'package:job_app/models/request/bookmarks/bookmarks_model.dart';
import 'package:job_app/models/response/bookmarks/all_bookmark.dart';
import 'package:job_app/services/helpers/book_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';


class BookMarkNotifier extends ChangeNotifier {
  List<String> _jobs =[];
  Future<List<AllBookmark>>? bookmarks;

  List<String> get jobs => _jobs;
  set jobs(List<String> newList){
    _jobs = newList;
    notifyListeners();
  }

  Future<void> addJob(String jobId) async {
    final prefs = await SharedPreferences.getInstance();
    if (_jobs.isNotEmpty){
      _jobs.insert(0, jobId);
      prefs.setStringList('jobId', _jobs);
      notifyListeners();
    } else {
      _jobs.insert(0, jobId);
      prefs.setStringList('jobId', _jobs);
      notifyListeners();
    }
  }

  Future<void> loadJobs()async {
    final prefs = await SharedPreferences.getInstance();
    final jobs = prefs.getStringList('jobId');

    if (jobs != null){
      _jobs = jobs;
    }
  }

  addBookmark(BookmarkReqResModel model, String jobId){
    BookMarkHelper.addBookmark(model).then((response) {
      if (response[0]){
        addJob(jobId);
        Get.snackbar("Bookmark successfully added", "Done",
        colorText: Color(kLight.value),
        backgroundColor: Color(kLightBlue.value),
        icon: const Icon(Icons.bookmark_add));
      } else if (!response[0]){
        Get.snackbar("Failed to add Bookmark", "Please try again",
        colorText: Color(kLight.value),
        backgroundColor: Color(kLightBlue.value),
        icon: const Icon(Icons.bookmark_add));
      }
    });
  }

  Future<void> removeJob(String jobId) async {
    final prefs = await SharedPreferences.getInstance();
    if (_jobs.isNotEmpty){
      _jobs.remove(jobId);
      prefs.setStringList('jobId', _jobs);
      notifyListeners();
    } 
  }

  deleteBookmark(String jobId){
    BookMarkHelper.deleteBookmark(jobId).then((response) {
      if (response){
        removeJob(jobId);
        Get.snackbar("Bookmark successfully delete", "Please check your bookmark",
        colorText: Color(kLight.value),
        backgroundColor: Color(kOrange.value),
        icon: const Icon(Icons.bookmark_remove_outlined));
      } else if (!response){
        Get.snackbar("Failed to delete Bookmark", "Please try again",
        colorText: Color(kLight.value),
        backgroundColor: Color(kLightBlue.value),
        icon: const Icon(Icons.bookmark_add));
      }
    });
  }

  getBookmarks(){
    bookmarks = BookMarkHelper.getBookmarks();
  }
}
