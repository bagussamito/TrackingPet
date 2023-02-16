import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:petshop/app/controllers/auth_controller.dart';
import 'package:petshop/app/modules/dashboard/views/dashboard_view.dart';
import 'package:petshop/app/modules/dashboard_admin/views/dashboard_admin_view.dart';
import 'package:petshop/app/modules/grooming_admin/views/grooming_admin_view.dart';
import 'package:petshop/app/modules/home/controllers/home_controller.dart';
import 'package:petshop/app/modules/setting/views/setting_view.dart';
import 'package:petshop/app/modules/setting_admin/views/setting_admin_view.dart';
import '../../../theme/theme.dart';
import '../../../utils/loading.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  final authC = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    var pages = <Widget>[
      DashboardView(),
      SettingView(),
      DashboardAdminView(),
      GroomingAdminView(),
      SettingAdminView()
    ];

    return FutureBuilder<DocumentSnapshot<Object?>>(
        future: authC.role(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const LoadingView();
          }
          if (snap.hasData) {
            var role = snap.data!.get("role");
            if (role != "Admin") {
              return Scaffold(
                body: Obx(() => pages[controller.currentIndex.value]),
                bottomNavigationBar: Container(
                  decoration: BoxDecoration(
                    color: backgroundOrange,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      navBarItem(context, IconlyLight.home, 0),
                      navBarItem(context, IconlyLight.time_circle, 1),
                    ],
                  ),
                ),
              );
            } else {
              return Scaffold(
                body: Obx(() => pages[controller.currentIndex.value]),
                bottomNavigationBar: Container(
                  decoration: BoxDecoration(
                    color: backgroundOrange,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      navBarItem(context, FontAwesomeIcons.cartShopping, 2),
                      navBarItem(context, FontAwesomeIcons.shower, 3),
                      navBarItem(context, FontAwesomeIcons.user, 4),
                    ],
                  ),
                ),
              );
            }
          } else {
            return LoadingView();
          }
        });
  }

  Widget navBarItem(BuildContext context, IconData icon, int index) {
    double bodyHeight = MediaQuery.of(context).size.height;
    // double bodyWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        controller.changePage(index);
      },
      child: SizedBox(
        height: 0.08.sh,
        child: SizedBox(
          width: 0.05.sw,
          height: 0.25.sh,
          child: Obx(
            () => Icon(
              icon,
              color: (index == controller.currentIndex.value)
                  ? Yellow1
                  : Yellow1.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }
}
