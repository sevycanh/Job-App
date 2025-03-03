import 'package:flutter/foundation.dart';
import 'package:job_app/models/response/jobs/get_job.dart';
import 'package:job_app/models/response/jobs/jobs_response.dart';
import 'package:job_app/services/helpers/jobs_helper.dart';

class JobsNotifier extends ChangeNotifier {
  late Future<List<JobsResponse>> jobsList;
  late Future<List<JobsResponse>> recent;
  late Future<GetJobRes> job;

  getJobs() {
    jobsList = JobsHelper.getJobs();
  }

  getRecent() {
    recent = JobsHelper.getRecent();
  }

  getJob(String jobId){
    job = JobsHelper.getJob(jobId);
  }
}
