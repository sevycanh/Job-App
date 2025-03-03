import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:job_app/constants/app_constants.dart';
import 'package:job_app/models/response/jobs/jobs_response.dart';
import 'package:job_app/views/common/app_style.dart';
import 'package:job_app/views/common/height_spacer.dart';
import 'package:job_app/views/common/reusable_text.dart';
import 'package:job_app/views/common/width_spacer.dart';

class JobHorizontalTile extends StatelessWidget {
  const JobHorizontalTile({super.key, this.onTap, required this.job});

  final void Function()? onTap;
  final JobsResponse job;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(right: 12.w),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          width: width * 0.7,
          color: Color(kLightGrey.value),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(job.imageUrl),
                  ),
                  const WidthSpacer(width: 15),
                  ReusableText(
                      text: job.company,
                      style: appstyle(15, Color(kDark.value), FontWeight.w600))
                ],
              ),
              const HeightSpacer(size: 5),
              ReusableText(
                  text: job.title,
                  style: appstyle(20, Color(kDark.value), FontWeight.w600)),
              ReusableText(
                  text: job.location,
                  style: appstyle(16, Color(kDarkGrey.value), FontWeight.w600)),
              const HeightSpacer(size: 10),
              Row(
                children: [
                  Row(
                    children: [
                      ReusableText(
                          text: job.salary,
                          style: appstyle(
                              20, Color(kDark.value), FontWeight.w600)),
                      ReusableText(
                          text: "/${job.period}",
                          style: appstyle(
                              20, Color(kDarkGrey.value), FontWeight.w600)),
                    ],
                  ),
                  SizedBox(width: width * 0.05),
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: Color(kLight.value),
                    child: const Icon(Ionicons.chevron_forward),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
