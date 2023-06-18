import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/rendering.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:petshop/app/modules/setting/views/setting_view.dart';
import 'package:petshop/app/theme/theme.dart';
import 'package:petshop/app/utils/loading.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:sizer/sizer.dart';

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

                return SingleChildScrollView(
                    reverse: false,
                    padding: EdgeInsets.only(
                      left: 3.w,
                      right: 3.w,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 6.h,
                        ),
                        Text("Riwayat Pesanan Grooming",
                            textAlign: TextAlign.start,
                            textScaleFactor: 1,
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Purple,
                              fontSize: 20.sp,
                            )),
                        SizedBox(
                          height: 1.h,
                        ),
                        SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Container(
                            height: 80.h,
                            child: ContainedTabBarView(
                                tabs: [
                                  Text(
                                    "Selesai",
                                    textAlign: TextAlign.start,
                                    textScaleFactor: 1,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12.sp,
                                        color: Purple),
                                  ),
                                  Text(
                                    "Dalam Proses",
                                    textAlign: TextAlign.start,
                                    textScaleFactor: 1,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12.sp,
                                        color: Purple),
                                  ),
                                ],
                                tabBarViewProperties:
                                    const TabBarViewProperties(
                                        physics:
                                            NeverScrollableScrollPhysics()),
                                tabBarProperties: TabBarProperties(
                                    height: 10.h,
                                    indicator: ContainerTabIndicator(
                                        width: 28.w,
                                        height: 5.h,
                                        radius: BorderRadius.circular(10),
                                        color: Grey1),
                                    indicatorColor: Grey1,
                                    indicatorWeight: 5.0,
                                    labelColor: backgroundOrange,
                                    unselectedLabelColor: Colors.grey[400]),
                                views: [
                                  StreamBuilder<
                                          QuerySnapshot<Map<String, dynamic>>>(
                                      stream: controller.orderDone(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return LoadingView();
                                        }
                                        if (!snapshot.hasData ||
                                            snapshot.data!.docs.isEmpty) {
                                          return Padding(
                                              padding: EdgeInsets.only(top: 15),
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    Text("Progres Masih Kosong",
                                                        style: TextStyle(
                                                          fontSize: 12.sp,
                                                          color: Purple,
                                                        ))
                                                  ],
                                                ),
                                              ));
                                        }

                                        return SingleChildScrollView(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            padding:
                                                EdgeInsets.only(bottom: 1.h),
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount:
                                                snapshot.data!.docs.length,
                                            itemBuilder: (context, index) {
                                              Map<String, dynamic> data =
                                                  snapshot.data!.docs[index]
                                                      .data();
                                              var layanan = data['layanan'];
                                              var nama_hewan =
                                                  data['selected item'];
                                              var addres = data['lokasi hewan']
                                                  ['address'];
                                              var name = data['name'];
                                              var uid = data['uid'];

                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 1.h),
                                                child: Material(
                                                  color: Grey1,
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  child: SizedBox(
                                                    width: 10.w,
                                                    height: 32.3.h,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                              right: 3.w,
                                                              left: 2.w,
                                                              top: 2.h,
                                                              bottom: 3.h,
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              1.h),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        "Tanggal: ",
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        textScaleFactor:
                                                                            1,
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            fontSize: 12.sp,
                                                                            color: Purple),
                                                                      ),
                                                                      Text(
                                                                        "${DateFormat('d MMMM yyyy', 'id-ID').format(DateTime.parse(data['lokasi hewan']['date']))}",
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        textScaleFactor:
                                                                            1,
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            fontSize: 12.sp,
                                                                            color: Purple),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              1.h),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        "Layanan yang diambil: ",
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        textScaleFactor:
                                                                            1,
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            fontSize: 12.sp,
                                                                            color: Purple),
                                                                      ),
                                                                      Text(
                                                                        "$layanan",
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        textScaleFactor:
                                                                            1,
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            fontSize: 12.sp,
                                                                            color: Purple),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              1.h),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Text(
                                                                              "Nama Hewan: ",
                                                                              textAlign: TextAlign.start,
                                                                              textScaleFactor: 1,
                                                                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.sp, color: Purple),
                                                                            ),
                                                                            Text(
                                                                              "$nama_hewan",
                                                                              textAlign: TextAlign.start,
                                                                              textScaleFactor: 1,
                                                                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.sp, color: Purple),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              1.h),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        "Nama Pemesan: ",
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        textScaleFactor:
                                                                            1,
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            fontSize: 12.sp,
                                                                            color: Purple),
                                                                      ),
                                                                      Text(
                                                                        "$name",
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        textScaleFactor:
                                                                            1,
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            fontSize: 12.sp,
                                                                            color: Purple),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          top: 1
                                                                              .h),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        "Lokasi Hewan: ",
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        textScaleFactor:
                                                                            1,
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            fontSize: 12.sp,
                                                                            color: Purple),
                                                                      ),
                                                                      Text(
                                                                        "$addres",
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        textScaleFactor:
                                                                            1,
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            fontSize: 12.sp,
                                                                            color: Purple),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      }),
                                  StreamBuilder<
                                          QuerySnapshot<Map<String, dynamic>>>(
                                      stream: controller.orderProses(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return LoadingView();
                                        }
                                        if (!snapshot.hasData ||
                                            snapshot.data!.docs.length == 0) {
                                          return Padding(
                                              padding:
                                                  EdgeInsets.only(top: 10.h),
                                              child: Center(
                                                child: Column(
                                                  children: [
                                                    Text("Progres Masih Kosong",
                                                        style: TextStyle(
                                                          fontSize: 12.sp,
                                                          color: Purple,
                                                        ))
                                                  ],
                                                ),
                                              ));
                                        }

                                        return SingleChildScrollView(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            padding:
                                                EdgeInsets.only(bottom: 2.h),
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount:
                                                snapshot.data!.docs.length,
                                            itemBuilder: (context, index) {
                                              Map<String, dynamic> data =
                                                  snapshot.data!.docs[index]
                                                      .data();
                                              var layanan = data['layanan'];
                                              var nama_hewan =
                                                  data['selected item'];
                                              var addres = data['lokasi hewan']
                                                  ['address'];
                                              var name = data['name'];
                                              var uid = data['uid'];

                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 1.h),
                                                child: Material(
                                                  color: Grey1,
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  child: SizedBox(
                                                    width: 10.w,
                                                    height: 32.3.h,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Expanded(
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                              right: 3.w,
                                                              left: 2.w,
                                                              top: 2.h,
                                                              bottom: 3.h,
                                                            ),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              1.h),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        "Tanggal: ",
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        textScaleFactor:
                                                                            1,
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            fontSize: 12.sp,
                                                                            color: Purple),
                                                                      ),
                                                                      Text(
                                                                        "${DateFormat('d MMMM yyyy', 'id-ID').format(DateTime.parse(data['lokasi hewan']['date']))}",
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        textScaleFactor:
                                                                            1,
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            fontSize: 12.sp,
                                                                            color: Purple),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              1.h),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        "Layanan yang diambil: ",
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        textScaleFactor:
                                                                            1,
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            fontSize: 12.sp,
                                                                            color: Purple),
                                                                      ),
                                                                      Text(
                                                                        "$layanan",
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        textScaleFactor:
                                                                            1,
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            fontSize: 12.sp,
                                                                            color: Purple),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              1.h),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Text(
                                                                              "Nama Hewan: ",
                                                                              textAlign: TextAlign.start,
                                                                              textScaleFactor: 1,
                                                                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.sp, color: Purple),
                                                                            ),
                                                                            Text(
                                                                              "$nama_hewan",
                                                                              textAlign: TextAlign.start,
                                                                              textScaleFactor: 1,
                                                                              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12.sp, color: Purple),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              1.h),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        "Nama Pemesan: ",
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        textScaleFactor:
                                                                            1,
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            fontSize: 12.sp,
                                                                            color: Purple),
                                                                      ),
                                                                      Text(
                                                                        "$name",
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        textScaleFactor:
                                                                            1,
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            fontSize: 12.sp,
                                                                            color: Purple),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          top: 1
                                                                              .h),
                                                                  child: Row(
                                                                    children: [
                                                                      Text(
                                                                        "Lokasi Hewan: ",
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        textScaleFactor:
                                                                            1,
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            fontSize: 12.sp,
                                                                            color: Purple),
                                                                      ),
                                                                      Text(
                                                                        "$addres",
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                        textScaleFactor:
                                                                            1,
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                            fontSize: 12.sp,
                                                                            color: Purple),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      }),
                                ]),
                          ),
                        )
                      ],
                    ));
              } else {
                return LoadingView();
              }
            }));
  }
}
