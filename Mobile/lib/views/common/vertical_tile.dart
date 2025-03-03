import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:job_app/constants/app_constants.dart';
import 'package:job_app/models/response/jobs/jobs_response.dart';
import 'package:job_app/views/common/exports.dart';
import 'package:job_app/views/common/width_spacer.dart';

class VerticalTile extends StatelessWidget {
  const VerticalTile({super.key, this.onTap, required this.job});

  final void Function()? onTap;
  final JobsResponse? job;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        margin: EdgeInsets.only(bottom: 10.h),
        height: height * 0.15,
        width: width,
        color: Color(kLightGrey.value),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Color(kLightGrey.value),
                      radius: 20,
                      backgroundImage: NetworkImage(job!.imageUrl),
                    ),
                    const WidthSpacer(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ReusableText(
                            text: job!.company,
                            style: appstyle(
                                15, Color(kDark.value), FontWeight.w600)),
                        SizedBox(
                          width: width * 0.5,
                          child: ReusableText(
                              text: job!.title,
                              style: appstyle(
                                  20, Color(kDark.value), FontWeight.w600)),
                        )
                      ],
                    ),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(kLight.value),
                      child: const Icon(Ionicons.chevron_forward),
                    )
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 12.w),
              child: Row(
                children: [
                  ReusableText(
                      text: job!.salary,
                      style: appstyle(20, Color(kDark.value), FontWeight.w600)),
                  ReusableText(
                      text: "/${job!.period}",
                      style: appstyle(
                          20, Color(kDarkGrey.value), FontWeight.w600)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
