import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:petshop/app/modules/layanan_grooming_admin/views/layanan_grooming_admin_view.dart';
import 'package:petshop/app/theme/theme.dart';
import 'package:petshop/app/utils/loading.dart';
import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../routes/app_pages.dart';
import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  DashboardView({Key? key}) : super(key: key);
  final DashboardController controller = Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: controller.getOrderDoc(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return LoadingView();
              }
              if (snap.hasData) {
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
                        children: [
                          SizedBox(
                            height: bodyHeight * 0.06,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Our Services",
                                  textAlign: TextAlign.start,
                                  textScaleFactor: 1,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Purple,
                                    fontSize: 24,
                                  )),
                            ],
                          ),
                          Text(
                              "Banyak Sekali Layanan Yang Kami Berikan Kepada Anda",
                              textAlign: TextAlign.start,
                              textScaleFactor: 1,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Purple,
                                fontSize: 16,
                              )),
                          SizedBox(
                            height: bodyHeight * 0.03,
                          ),
                          CarouselSlider.builder(
                            itemCount: controller.titles.length,
                            itemBuilder: (context, index, _) {
                              return Column(
                                children: [
                                  Image.asset('assets/images/cat.jpg'),
                                  SizedBox(
                                    height: bodyHeight * 0.01,
                                  ),
                                  Text(
                                    controller.titles[index],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Purple),
                                  ),
                                ],
                              );
                            },
                            options: CarouselOptions(
                              autoPlay: true,
                              enlargeCenterPage: true,
                              aspectRatio: 1.3,
                              onPageChanged: (index, reason) {
                                controller.currentIndex.value = index;
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Daftar Grooming Anda",
                                  textAlign: TextAlign.start,
                                  textScaleFactor: 1,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Purple,
                                    fontSize: 24,
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: bodyHeight * 0.01,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.only(bottom: bodyHeight * 0.02),
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snap.data!.docs.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> data =
                                  snap.data!.docs[index].data();
                              var layanan = data['layanan'];
                              var nama_hewan = data['selected item'];
                              var addres = data['lokasi hewan']['address'];
                              var name = data['name'];
                              var status = data['status'];
                              bool isClickable = status == 'Diterima';

                              return Padding(
                                padding:
                                    EdgeInsets.only(bottom: bodyHeight * 0.015),
                                child: Material(
                                  color: Grey1,
                                  borderRadius: BorderRadius.circular(30),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(30),
                                    onTap: isClickable
                                        ? () {
                                            // Tambahkan fungsi yang akan dijalankan ketika data diklik
                                            if (isClickable) {
                                              Get.toNamed(
                                                  Routes.DETAIL_GROOMING,
                                                  arguments: data);
                                            }
                                          }
                                        : () {},
                                    child: SizedBox(
                                      width: bodyWidth * 1,
                                      height: bodyHeight * 0.2,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: bodyWidth * 0.06,
                                              vertical: bodyHeight * 0.02,
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        "Tanggal",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Purple,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      ":",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Purple,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Text(
                                                        "${DateFormat('d MMMM yyyy', 'id-ID').format(DateTime.parse(data['lokasi hewan']['date']))}",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Purple,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        "Layanan",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Purple,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      ":",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Purple,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Text(
                                                        "$layanan",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Purple,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        "Nama Hewan",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Purple,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      ":",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Purple,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Text(
                                                        "$nama_hewan",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Purple,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        "Nama Pemesan",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Purple,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      ":",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Purple,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Text(
                                                        "$name",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Purple,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                        "Status",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Purple,
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      ":",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: Purple,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      flex: 3,
                                                      child: Text(
                                                        "$status",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Purple,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: bodyWidth * 0.06),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    "Lokasi Hewan",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Purple,
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  ":",
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    color: Purple,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Text(
                                                    addres,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Purple,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                print("No data available");
                return LoadingView();
              }
            }));
  }

  void navigateToDetailPage(Map<String, dynamic> data) {
    // Navigasi ke halaman detail dengan melempar argumen
    // Ganti 'Routes.LAYANAN_GROOMING_ADMIN' dengan nama rute halaman detail yang sesuai
    Get.toNamed(Routes.DETAIL_GROOMING, arguments: data);
  }
}
