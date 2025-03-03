import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:job_app/constants/app_constants.dart';
import 'package:job_app/controllers/exports.dart';
import 'package:job_app/models/request/bookmarks/bookmarks_model.dart';
import 'package:job_app/models/request/chat/create_chat.dart';
import 'package:job_app/models/request/messaging/send_message.dart';
import 'package:job_app/services/helpers/chat_helper.dart';
import 'package:job_app/services/helpers/messaging_helper.dart';
import 'package:job_app/views/common/app_bar.dart';
import 'package:job_app/views/common/custom_outline_btn.dart';
import 'package:job_app/views/common/exports.dart';
import 'package:job_app/views/common/height_spacer.dart';
import 'package:job_app/views/ui/mainscreen.dart';
import 'package:provider/provider.dart';

class JobPage extends StatefulWidget {
  const JobPage({super.key, required this.title, required this.id});

  final String title;
  final String id;

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<JobsNotifier>(
      builder: (context, jobsNotifier, child) {
        jobsNotifier.getJob(widget.id);
        return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: CustomAppBar(
                text: widget.title,
                actions: [
                  Consumer<BookMarkNotifier>(
                    builder: (context, bookMarkNotifier, child) {
                      bookMarkNotifier.loadJobs();
                      return GestureDetector(
                        onTap: () {
                          if (bookMarkNotifier.jobs.contains(widget.id)) {
                            bookMarkNotifier.deleteBookmark(widget.id);
                          } else {
                            BookmarkReqResModel model =
                                BookmarkReqResModel(job: widget.id);
                            bookMarkNotifier.addBookmark(model, widget.id);
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.only(right: 12.0),
                          child: !bookMarkNotifier.jobs.contains(widget.id)
                              ? Icon(Fontisto.bookmark)
                              : const Icon(Fontisto.bookmark_alt),
                        ),
                      );
                    },
                  )
                ],
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: const Icon(CupertinoIcons.arrow_left),
                ),
              ),
            ),
            body: FutureBuilder(
              future: jobsNotifier.job,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Text("Error ${snapshot.error}");
                } else {
                  final job = snapshot.data;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Stack(
                      children: [
                        ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            const HeightSpacer(size: 30),
                            Container(
                              width: width,
                              height: height * 0.27,
                              color: Color(kLightGrey.value),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(job!.imageUrl),
                                  ),
                                  const HeightSpacer(size: 10),
                                  ReusableText(
                                      text: job.title,
                                      style: appstyle(22, Color(kDark.value),
                                          FontWeight.w600)),
                                  const HeightSpacer(size: 5),
                                  ReusableText(
                                      text: job.location,
                                      style: appstyle(
                                          16,
                                          Color(kDarkGrey.value),
                                          FontWeight.normal)),
                                  const HeightSpacer(size: 15),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 50),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CustomOutlineBtn(
                                            width: width * 0.26,
                                            height: height * 0.04,
                                            color2: Color(kLight.value),
                                            text: job.contract,
                                            color: Color(kOrange.value)),
                                        Row(
                                          children: [
                                            ReusableText(
                                                text: job.salary,
                                                style: appstyle(
                                                    14,
                                                    Color(kDark.value),
                                                    FontWeight.w500)),
                                            SizedBox(
                                              width: width * 0.2,
                                              child: ReusableText(
                                                  text: "/${job.period}",
                                                  style: appstyle(
                                                      13,
                                                      Color(kDark.value),
                                                      FontWeight.w500)),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const HeightSpacer(size: 20),
                            ReusableText(
                                text: "Job Description",
                                style: appstyle(
                                    22, Color(kDark.value), FontWeight.w600)),
                            const HeightSpacer(size: 10),
                            Text(
                              job.description,
                              textAlign: TextAlign.justify,
                              maxLines: 8,
                              style: appstyle(16, Color(kDarkGrey.value),
                                  FontWeight.normal),
                            ),
                            const HeightSpacer(size: 20),
                            ReusableText(
                                text: "Requirements",
                                style: appstyle(
                                    22, Color(kDark.value), FontWeight.w600)),
                            const HeightSpacer(size: 10),
                            SizedBox(
                              height: height * 0.6,
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: job.requirements.length,
                                itemBuilder: (context, index) {
                                  final req = job.requirements[index];
                                  String bullet = "\u2022";
                                  return Text(
                                    "$bullet $req\n",
                                    maxLines: 4,
                                    textAlign: TextAlign.justify,
                                    style: appstyle(16, Color(kDark.value),
                                        FontWeight.normal),
                                  );
                                },
                              ),
                            ),
                            const HeightSpacer(size: 100)
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 20.h),
                            child: CustomOutlineBtn(
                                onTap: () {
                                  CreateChat model =
                                      CreateChat(userId: job.agentId);
                                  ChatHelper.apply(model).then((value) {
                                    if (value[0]) {
                                      SendMessage model = SendMessage(
                                          content:
                                              "Hello, I'm interested in ${job.title} job in ${job.location}",
                                          chatId: value[1],
                                          receiver: job.agentId);

                                      MessagingHelper.sendMessage(model)
                                          .whenComplete(() {
                                        Get.to(() => const MainScreen());
                                      });
                                    }
                                  });
                                },
                                color2: Color(kOrange.value),
                                width: width,
                                height: height * 0.06,
                                text: "Apply Now",
                                color: Color(kLight.value)),
                          ),
                        )
                      ],
                    ),
                  );
                }
              },
            ));
      },
    );
  }
}
