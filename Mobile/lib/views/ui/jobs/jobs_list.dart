import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:job_app/controllers/exports.dart';
import 'package:job_app/models/response/jobs/jobs_response.dart';
import 'package:job_app/views/ui/jobs/widgets/job_tile.dart';
import 'package:provider/provider.dart';

import '../../common/app_bar.dart';

class JobListPage extends StatelessWidget {
  const JobListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final jobList = Provider.of<JobsNotifier>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: CustomAppBar(
          text: "Jobs",
          child: GestureDetector(
            onTap: () => Get.back(),
            child: const Icon(CupertinoIcons.arrow_left),
          ),
        ),
      ),
      body: FutureBuilder<List<JobsResponse>>(
        future: jobList.jobsList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Text("Error ${snapshot.error}");
          } else {
            final jobs = snapshot.data;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ListView.builder(
                itemCount: jobs!.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final job = jobs[index];
                  return VerticalTileWidget(
                    job: job,
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
