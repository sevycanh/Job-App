import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:job_app/constants/app_constants.dart';
import 'package:job_app/controllers/exports.dart';
import 'package:job_app/views/common/exports.dart';
import 'package:job_app/views/ui/auth/profile.dart';
import 'package:job_app/views/ui/bookmarks/bookmarks.dart';
import 'package:job_app/views/ui/chat/chat_bot.dart';
import 'package:job_app/views/ui/chat/chat_list.dart';
import 'package:job_app/views/ui/homepage.dart';
import 'package:provider/provider.dart';

import '../common/drawer/drawerScreen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ZoomNotifier>(
      builder: (context, zoomNotifier, child) {
        return ZoomDrawer(
          menuScreen: DrawerScreen(
            indexSetter: (value) {
              zoomNotifier.currentIndex = value;
            },
          ),
          mainScreen: currentScreen(),
          borderRadius: 30,
          showShadow: true,
          angle: 0.0,
          slideWidth: 250,
          menuBackgroundColor: Color(kLightBlue.value),
        );
      },
    );
  }

  Widget currentScreen() {
    var zoomNotifier = Provider.of<ZoomNotifier>(context);
    switch (zoomNotifier.currentIndex) {
      case 0:
        return const HomePage();
      case 1:
        return const ChatsList();
      case 2:
        return const ChatBot();
      case 3:
        return const BookMarkPage();
      case 4:
        return const ProfilePage();
      default:
        return const HomePage();
    }
  }
}


