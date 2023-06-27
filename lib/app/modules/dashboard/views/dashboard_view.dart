import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:petshop/app/theme/theme.dart';
import 'package:petshop/app/utils/loading.dart';
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
                var listAllDocs = snap.data!.docs;
                return LayoutBuilder(
                  builder: (context, constraints) {
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
                          Text("Beberapa Layanan Yang Kami Berikan Kepada Anda",
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
                          SizedBox(
                            height: bodyHeight * 0.01,
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
                          listAllDocs.length == 0
                              ? Center(
                                  child: Text(
                                    'Tidak Ada Data Pesanan',
                                    textAlign: TextAlign.start,
                                    textScaleFactor: 1,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Purple,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(
                                      bottom: bodyHeight * 0.02),
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: snap.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    Map<String, dynamic> data =
                                        snap.data!.docs[index].data();
                                    var layanan = data['layanan'];
                                    var nama_hewan = data['selected item'];
                                    var addres =
                                        data['lokasi hewan']['address'];
                                    var name = data['name'];
                                    var status = data['status'];
                                    bool isClickable = status == 'Selesai';

                                    return Padding(
                                      padding: EdgeInsets.only(
                                          bottom: bodyHeight * 0.015),
                                      child: Material(
                                        color: Color(0xFFE7D8FF),
                                        borderRadius: BorderRadius.circular(30),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          onTap: isClickable
                                              ? () {
                                                  if (isClickable) {
                                                    Get.toNamed(
                                                        Routes.DETAIL_GROOMING,
                                                        arguments: data);
                                                  }
                                                }
                                              : () {},
                                          child: SizedBox(
                                            width: bodyWidth * 1,
                                            height: bodyHeight * 0.28,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        bodyWidth * 0.06,
                                                    vertical: bodyHeight * 0.02,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 2,
                                                            child: Text(
                                                              "Tanggal",
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              textScaleFactor:
                                                                  1,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color:
                                                                      Purple),
                                                            ),
                                                          ),
                                                          Text(
                                                            ":",
                                                            textAlign:
                                                                TextAlign.start,
                                                            textScaleFactor: 1,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Purple),
                                                          ),
                                                          Expanded(
                                                            flex: 3,
                                                            child: Text(
                                                              "${DateFormat('d MMMM yyyy', 'id-ID').format(DateTime.parse(data['lokasi hewan']['date']))}",
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              textScaleFactor:
                                                                  1,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color:
                                                                      Purple),
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
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              textScaleFactor:
                                                                  1,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color:
                                                                      Purple),
                                                            ),
                                                          ),
                                                          Text(
                                                            ":",
                                                            textAlign:
                                                                TextAlign.start,
                                                            textScaleFactor: 1,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Purple),
                                                          ),
                                                          Expanded(
                                                            flex: 3,
                                                            child: Text(
                                                              "$layanan",
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              textScaleFactor:
                                                                  1,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color:
                                                                      Purple),
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
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              textScaleFactor:
                                                                  1,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color:
                                                                      Purple),
                                                            ),
                                                          ),
                                                          Text(
                                                            ":",
                                                            textAlign:
                                                                TextAlign.start,
                                                            textScaleFactor: 1,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Purple),
                                                          ),
                                                          Expanded(
                                                            flex: 3,
                                                            child: Text(
                                                              "$nama_hewan",
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              textScaleFactor:
                                                                  1,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color:
                                                                      Purple),
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
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              textScaleFactor:
                                                                  1,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color:
                                                                      Purple),
                                                            ),
                                                          ),
                                                          Text(
                                                            ":",
                                                            textAlign:
                                                                TextAlign.start,
                                                            textScaleFactor: 1,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Purple),
                                                          ),
                                                          Expanded(
                                                            flex: 3,
                                                            child: Text(
                                                              "$name",
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              textScaleFactor:
                                                                  1,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color:
                                                                      Purple),
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
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              textScaleFactor:
                                                                  1,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color:
                                                                      Purple),
                                                            ),
                                                          ),
                                                          Text(
                                                            ":",
                                                            textAlign:
                                                                TextAlign.start,
                                                            textScaleFactor: 1,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Purple),
                                                          ),
                                                          Expanded(
                                                            flex: 3,
                                                            child: Text(
                                                              "$status",
                                                              textAlign:
                                                                  TextAlign
                                                                      .start,
                                                              textScaleFactor:
                                                                  1,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color:
                                                                      Purple),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal:
                                                          bodyWidth * 0.06),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        flex: 2,
                                                        child: Text(
                                                          "Lokasi Hewan",
                                                          textAlign:
                                                              TextAlign.start,
                                                          textScaleFactor: 1,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Purple),
                                                        ),
                                                      ),
                                                      Text(
                                                        ":",
                                                        textAlign:
                                                            TextAlign.start,
                                                        textScaleFactor: 1,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: Purple),
                                                      ),
                                                      Expanded(
                                                        flex: 3,
                                                        child: Text(
                                                          addres,
                                                          textAlign:
                                                              TextAlign.start,
                                                          textScaleFactor: 1,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: Purple),
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
