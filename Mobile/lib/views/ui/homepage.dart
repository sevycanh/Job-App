import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:job_app/constants/app_constants.dart';
import 'package:job_app/controllers/exports.dart';
import 'package:job_app/views/common/app_bar.dart';
import 'package:job_app/views/common/app_style.dart';
import 'package:job_app/views/common/drawer/drawer_widget.dart';
import 'package:job_app/views/common/heading_widget.dart';
import 'package:job_app/views/common/height_spacer.dart';
import 'package:job_app/views/common/search.dart';
import 'package:job_app/views/common/vertical_shimmer.dart';
import 'package:job_app/views/common/vertical_tile.dart';
import 'package:job_app/views/ui/jobs/job_page.dart';
import 'package:job_app/views/ui/jobs/jobs_list.dart';
import 'package:job_app/views/ui/jobs/widgets/horizontal_shimmer.dart';
import 'package:job_app/views/ui/jobs/widgets/horizontal_tile.dart';
import 'package:job_app/views/ui/search/searchpage.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: CustomAppBar(
            actions: [
              Padding(
                padding: EdgeInsets.all(12.h),
                child: const CircleAvatar(
                  radius: 15,
                  backgroundImage: AssetImage("assets/images/user.png"),
                ),
              )
            ],
            child: Padding(
              padding: EdgeInsets.all(12.0.h),
              child: const DrawerWidget(),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Consumer<JobsNotifier>(
            builder: (context, jobsNotifier, child) {
              jobsNotifier.getJobs();
              jobsNotifier.getRecent();
              return SafeArea(
                  child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const HeightSpacer(size: 10),
                      Text(
                        "Search \nFind & Apply",
                        style: appstyle(40, Color(kDark.value), FontWeight.bold),
                      ),
                      const HeightSpacer(size: 40),
                      SearchWidget(
                        onTap: () {
                          Get.to(() => SearchPage());
                        },
                      ),
                      const HeightSpacer(size: 30),
                      HeadingWidget(
                        text: 'Popular Jobs',
                        onTap: () {
                          Get.to(()=> const JobListPage());
                        },
                      ),
                      const HeightSpacer(size: 10),
                      SizedBox(
                          height: height * 0.21,
                          child: FutureBuilder(
                            future: jobsNotifier.jobsList,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const HorizontalShimmer();
                              } else if (snapshot.hasError) {
                                return Text("Error ${snapshot.error}");
                              } else {
                                final jobs = snapshot.data;
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: jobs!.length,
                                  itemBuilder: (context, index) {
                                    final job = jobs[index];
                                    return JobHorizontalTile(
                                      onTap: () {
                                        Get.to(() => JobPage(
                                              title: job.title,
                                              id: job.id,
                                            ));
                                      },
                                      job: job,
                                    );
                                  },
                                );
                              }
                            },
                          )),
                      const HeightSpacer(size: 20),
                      HeadingWidget(
                        text: 'Recently Posted',
                        onTap: () {},
                      ),
                      const HeightSpacer(size: 20),
                      SizedBox(
                        height: height * 0.49,
                        child: FutureBuilder(
                          future: jobsNotifier.recent,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const VerticalShimmer();
                            } else if (snapshot.hasError) {
                              return Text("Error ${snapshot.error}");
                            } else {
                              final jobs = snapshot.data;
                              return ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: jobs!.length,
                                itemBuilder: (context, index) {
                                final job = jobs[index];
                                return VerticalTile(
                                  job: job,
                                  onTap: () {
                                    Get.to(() => JobPage(
                                          title: job.title,
                                          id: job.id,
                                        ));
                                  },
                                );
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ));
            },
          ),
        ));
  }
}
