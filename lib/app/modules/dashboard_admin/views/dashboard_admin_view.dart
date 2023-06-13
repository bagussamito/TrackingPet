import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:petshop/app/modules/setting/views/setting_view.dart';
import 'package:petshop/app/theme/theme.dart';
import 'package:petshop/app/utils/loading.dart';
import 'package:anim_search_bar/anim_search_bar.dart';

import '../controllers/dashboard_admin_controller.dart';

class DashboardAdminView extends GetView<DashboardAdminController> {
  DashboardAdminView({Key? key}) : super(key: key);
  final DashboardAdminController controller =
      Get.put(DashboardAdminController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: StreamBuilder<QuerySnapshot<Object?>>(
            stream: controller.getBarangDoc(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return LoadingView();
              }
              if (snap.hasData) {
                var listAllDocs = snap.data!.docs;

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final textScale = MediaQuery.of(context).textScaleFactor;
                    final bodyHeight = MediaQuery.of(context).size.height;
                    -MediaQuery.of(context).padding.top;
                    final bodyWidth = MediaQuery.of(context).size.width;
                    return SingleChildScrollView(
                      reverse: false,
                      padding: EdgeInsets.only(
                        left: bodyWidth * 0.05,
                        right: bodyWidth * 0.05,
                        bottom: bodyHeight * 0.01,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: bodyHeight * 0.06,
                          ),
                          Text("Ini Dashboard Admin",
                              textAlign: TextAlign.start,
                              textScaleFactor: 1,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                color: Purple,
                                fontSize: 20,
                              )),
                          SizedBox(
                            height: bodyHeight * 0.006,
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                return LoadingView();
              }
            }));
  }
}
