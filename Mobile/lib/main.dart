import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:job_app/controllers/exports.dart';
import 'package:job_app/firebase_options.dart';
import 'package:job_app/views/ui/auth/login.dart';
import 'package:job_app/views/ui/mainscreen.dart';
import 'package:job_app/views/ui/onboarding/onboarding_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'views/common/exports.dart';

Widget defaultHome = const OnBoardingScreen();

void main() async {
  Gemini.init(apiKey: GEMINI_API_KEY);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);

  final SharedPreferences preferences = await SharedPreferences.getInstance();

  final entrypoint = preferences.getBool('entrypoint') ?? false;
  final loggedIn = preferences.getBool('loggedIn') ?? false;

  if (entrypoint && !loggedIn) {
    defaultHome = const LoginPage();
  } else if (entrypoint && loggedIn) {
    defaultHome = const MainScreen();
  }

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => OnBoardNotifier()),
    ChangeNotifierProvider(create: (context) => LoginNotifier()),
    ChangeNotifierProvider(create: (context) => ZoomNotifier()),
    ChangeNotifierProvider(create: (context) => SignUpNotifier()),
    ChangeNotifierProvider(create: (context) => JobsNotifier()),
    ChangeNotifierProvider(create: (context) => BookMarkNotifier()),
    ChangeNotifierProvider(create: (context) => ImageUploader()),
    ChangeNotifierProvider(create: (context) => ProfileNotifier()),
    ChangeNotifierProvider(create: (context) => ChatNotifier(),)
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        useInheritedMediaQuery: true,
        designSize: const Size(
            375, 812), //Đây là kích thước thiết kế ban đầu của ứng dụng.
        minTextAdapt:
            true, //tự động điều chỉnh kích thước của văn bản để nó phù hợp với màn hình.
        splitScreenMode: true, //kích hoạt chế độ màn hình chia để sử dụng.
        builder: (context, child) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'JobDCD',
            theme: ThemeData(
              scaffoldBackgroundColor: Color(kLight.value),
              iconTheme: IconThemeData(color: Color(kDark.value)),
              primarySwatch: Colors.grey,
            ),
            home: defaultHome,
          );
        });
  }
}
