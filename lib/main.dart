import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petshop/app/controllers/fcm_controller.dart';

import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:petshop/app/modules/login/views/login_view.dart';
import 'package:petshop/app/modules/register/views/register_view.dart';
import 'package:petshop/app/theme/theme.dart';
import 'package:petshop/app/utils/loading.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'package:page_transition/page_transition.dart';

import 'app/controllers/auth_controller.dart';
import 'app/modules/home/views/home_view.dart';
import 'app/routes/app_pages.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final FCMController fcmController = FCMController();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await initializeDateFormatting('id_ID', null)
      .then((_) => runApp(DelonixPetshop(fcmController: fcmController)));
}

class DelonixPetshop extends StatelessWidget {
  final FCMController fcmController;

  const DelonixPetshop({Key? key, required this.fcmController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return AnnotatedRegion(
          value: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark,
            statusBarColor: light,
          ),
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: "GeekGarden Attendance",
            getPages: AppPages.routes,
            home: SplashScreen(),
            initialBinding: BindingsBuilder(() {
              Get.put(fcmController);
            }),
          ),
        );
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  final authC = Get.put(AuthController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: authC.streamAuthStatus,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            print(snapshot.data);
            return AnnotatedRegion(
              value: SystemUiOverlayStyle(
                statusBarBrightness: Brightness.dark,
                statusBarIconBrightness: Brightness.light,
                statusBarColor: backgroundOrange,
              ),
              child: AnimatedSplashScreen(
                animationDuration: Duration(milliseconds: 900),
                duration: 1200,
                splash: 'assets/icons/logo.png',
                backgroundColor: backgroundOrange,
                nextScreen: HomeScreen(),
                nextRoute: snapshot.data != null &&
                        snapshot.data!.emailVerified == true
                    ? Routes.HOME
                    : Routes.LOGIN,
                splashIconSize: 250,
                splashTransition: SplashTransition.fadeTransition,
                pageTransitionType: PageTransitionType.leftToRight,
              ),
            );
          }
          return LoadingView();
        });
  }
}

class HomeScreen extends StatelessWidget {
  final authC = Get.put(AuthController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: authC.streamAuthStatus,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            print(snapshot.data);
            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: "Delonix Apps",
              initialRoute:
                  snapshot.data != null && snapshot.data!.emailVerified == true
                      ? Routes.HOME
                      : Routes.LOGIN,
              getPages: AppPages.routes,
            );
          }
          return LoadingView();
        });
  }
}
