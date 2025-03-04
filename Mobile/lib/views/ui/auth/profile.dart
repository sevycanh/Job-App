import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:job_app/constants/app_constants.dart';
import 'package:job_app/controllers/exports.dart';
import 'package:job_app/models/response/auth/profile_model.dart';
import 'package:job_app/views/common/app_bar.dart';
import 'package:job_app/views/common/drawer/drawer_widget.dart';
import 'package:job_app/views/common/exports.dart';
import 'package:job_app/views/common/height_spacer.dart';
import 'package:job_app/views/common/width_spacer.dart';
import 'package:job_app/views/ui/auth/login.dart';
import 'package:job_app/views/ui/auth/profile_update.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    var zoomNotifier = Provider.of<ZoomNotifier>(context);
    // var onBoardNotifier = Provider.of<OnBoardNotifier>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: CustomAppBar(
          text: "Profile",
          child: Padding(
            padding: EdgeInsets.all(12.0.h),
            child: const DrawerWidget(),
          ),
        ),
      ),
      body: Consumer<ProfileNotifier>(
        builder: (context, profileNotifier, child) {
          profileNotifier.getProfile();
          return FutureBuilder<ProfileRes>(
            future: profileNotifier.profile,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Text("Error ${snapshot.error}");
              } else {
                final userData = snapshot.data;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Container(
                        width: width,
                        height: height * 0.12,
                        color: Color(kLight.value),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  child: userData!.profile == "null" ? const CircularProgressIndicator() : CachedNetworkImage(
                                    imageUrl: userData.profile,
                                    width: 80.w,
                                    height: 100.w,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                                const WidthSpacer(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ReusableText(
                                        text: userData.username,
                                        style: appstyle(20, Color(kDark.value),
                                            FontWeight.w600)),
                                    Row(
                                      children: [
                                        Icon(
                                          MaterialIcons.location_pin,
                                          color: Color(kDarkGrey.value),
                                        ),
                                        const WidthSpacer(width: 5),
                                        ReusableText(
                                            text: userData.location,
                                            style: appstyle(
                                                16,
                                                Color(kDarkGrey.value),
                                                FontWeight.w600)),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                profile = userData.skills;
                                Get.to(() => ProfileUpdate(profile: userData.profile));
                              },
                              child: const Icon(
                                Feather.edit,
                                size: 18,
                              ),
                            )
                          ],
                        ),
                      ),
                      const HeightSpacer(size: 20),
                      Stack(
                        children: [
                          Container(
                            width: width,
                            height: height * 0.12,
                            color: Color(kLightGrey.value),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(left: 12.w),
                                  width: 60.w,
                                  height: 70.h,
                                  color: Color(kLight.value),
                                  child: const Icon(
                                    FontAwesome5Regular.file_pdf,
                                    color: Colors.red,
                                    size: 40,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ReusableText(
                                        text: "Resume from JobDCD",
                                        style: appstyle(18, Color(kDark.value),
                                            FontWeight.w500)),
                                    ReusableText(
                                        text: "JobDCD Resume",
                                        style: appstyle(
                                            18,
                                            Color(kDarkGrey.value),
                                            FontWeight.w500)),
                                  ],
                                ),
                                const WidthSpacer(width: 1)
                              ],
                            ),
                          ),
                          Positioned(
                              top: 2.h,
                              right: 5.w,
                              child: GestureDetector(
                                onTap: () {},
                                child: ReusableText(
                                    text: "Edit",
                                    style: appstyle(16, Color(kOrange.value),
                                        FontWeight.w500)),
                              ))
                        ],
                      ),

                      const HeightSpacer(size: 20),
                      Container(
                        padding: EdgeInsets.only(left: 8.w),
                        width: width,
                        height: height * 0.06,
                        color: Color(kLightGrey.value),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: ReusableText(
                              text: userData.email,
                              style: appstyle(
                                  16, Color(kDark.value), FontWeight.w600)),
                        ),
                      ),
                      const HeightSpacer(size: 20),
                      Container(
                        padding: EdgeInsets.only(left: 8.w),
                        width: width,
                        height: height * 0.06,
                        color: Color(kLightGrey.value),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/usa.svg",
                                height: 20.h,
                                width: 20.w,
                              ),
                              const WidthSpacer(width: 15),
                              ReusableText(
                                  text: userData.phone,
                                  style: appstyle(
                                      16, Color(kDark.value), FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                      const HeightSpacer(size: 20),
                      Container(
                        color: Color(kLightGrey.value),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.h),
                                child: ReusableText(
                                    text: "Skills",
                                    style: appstyle(16, Color(kDark.value),
                                        FontWeight.w600)),
                              ),
                              const HeightSpacer(size: 3),
                              SizedBox(
                                height: height * 0.4,
                                child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8.w, vertical: 8.h),
                                    child: ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: userData.skills.length,
                                        itemBuilder: (context, index) {
                                          final skill = userData.skills[index];
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.w),
                                                width: width,
                                                height: height * 0.06,
                                                color: Color(kLight.value),
                                                child: ReusableText(
                                                    text: skill,
                                                    style: appstyle(
                                                        16,
                                                        Color(kDark.value),
                                                        FontWeight.normal))),
                                          );
                                        })),
                              ),
                              const HeightSpacer(size: 3),

                            ]),
                      ),
                      Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GestureDetector(
                    onTap: () async {
                      zoomNotifier.currentIndex = 0; // 0 is Home screen, 1 is Chat, 2....
                      //onBoardNotifier.isLastPage = false; // false để hiển thị nút skip và next
                      final SharedPreferences preferences = await SharedPreferences.getInstance();
                      preferences.setBool('loggedIn', false);
                      Get.to(() => const LoginPage());
                    },
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ReusableText(
                          text: "Sign Out",
                          style: appstyle(
                              16, Color(kOrange.value), FontWeight.w600)),
                    ),
                  ),
                )
                    ],
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
